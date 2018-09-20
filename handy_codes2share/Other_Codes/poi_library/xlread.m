function [num,txt,raw]=xlread(filename,sheet, range)
% 
%   REVISIONS
%   20121004 - First version using JExcelApi
%   20121101 - Modified to use POI library instead of JExcelApi (allows to
%           generate XLSX)
%   20121127 - Fixed bug: use existing rows if present, instead of 
%           overwrite rows by default. Thanks to Dan & Jason.
%   20121204 - Fixed bug: if a numeric sheet is given & didn't exist,
%           an error was returned instead of creating the sheet. Thanks to Marianna
%   20130106 - Fixed bug: use existing cell if present, instead of
%           overwriting. This way original XLS formatting is kept & not
%           overwritten.
%   20130125 - Fixed bug & documentation. Incorrect working of NaN. Thanks Klaus
%   20130227 - Fixed bug when no sheet number given & added Stax to java
%               load. Thanks to Thierry
%
%   Copyright 2012-2013, Alec de Zegher
%==============================================================================

% Check if POI lib is loaded
if exist('org.apache.poi.ss.usermodel.WorkbookFactory', 'class') ~= 8 ...
    || exist('org.apache.poi.hssf.usermodel.HSSFWorkbook', 'class') ~= 8 ...
    || exist('org.apache.poi.xssf.usermodel.XSSFWorkbook', 'class') ~= 8
    
    error('xlWrite:poiLibsNotLoaded',...
        'The POI library is not loaded in Matlab.\nCheck that POI jar files are in Matlab Java path!');
end

% Import required POI Java Classes
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;

import org.apache.poi.ss.util.*;
status=0;

% If no sheet & xlrange is defined, attribute an empty value to it
if nargin < 2; sheet = inf; end
if nargin < 3; range = []; end

% Check if sheetvariable contains range data
if nargin < 3 && ~isempty(strfind(sheet,':'))
    range = sheet;
    sheet = [];
end
%     ctype(1) = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_NUMERIC");
%     ctype(2) = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_STRING");
%     ctype(3) = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_FORMULA");
%     ctype(4) = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_BLANK");
%     ctype(5) = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_BOOLEAN");
%     ctype(6) = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_ERROR");

% Set java path to same path as Matlab path
java.lang.System.setProperty('user.dir', pwd);

% Open a file
xlsFile = java.io.File(filename);

% If file does not exist create a new workbook
if xlsFile.isFile()
    % create XSSF or HSSF workbook from existing workbook
    fileIn = java.io.FileInputStream(xlsFile);
    xlsWorkbook = WorkbookFactory.create(fileIn);
else
    error('xlsfile does not exist');
end
wb = xlsWorkbook;
% If sheetname given, enter data in this sheet
if ~isempty(sheet)
    if isnumeric(sheet)
        % Java uses 0-indexing, so take sheetnumer-1
        % Check if the sheet can exist 
        if xlsWorkbook.getNumberOfSheets() >= sheet && sheet >= 1
            xlsSheet = xlsWorkbook.getSheetAt(sheet-1);
        else
            % There are less number of sheets, that the requested sheet, so
            % return an empty sheet
            xlsSheet = [];
        end
    else
        xlsSheet = xlsWorkbook.getSheet(sheet);
    end
    
    % Create a new sheet if it is empty
    if isempty(xlsSheet)
        error('xlwrite:AddSheet', 'Worksheet does not exist.');
    end
    
else
    % check number of sheets
    nSheets = xlsWorkbook.getNumberOfSheets();
    
    % If no sheets, create one
    if nSheets < 1
        error('Workbook contains no sheets')
    else
        % Select the first sheet
        xlsSheet = xlsWorkbook.getSheetAt(0);
    end
end
rowIterator=xlsSheet.iterator();
firstrow = xlsSheet.getFirstRowNum ();    %% 0-based
lastrow = xlsSheet.getLastRowNum ();

[ firstrow, lastrow, lcol, rcol ] = getusedrange(xlsSheet);
   
if (firstrow == 0 && lastrow == 0)
  % Empty sheet
  rawarr = {};
  disp('Worksheet %s contains no data\n', xlsSheet.getSheetName());
  rstatus = 1;
  return;
else
  nrows = lastrow - firstrow + 1;
  ncols = rcol - lcol + 1;
end

%% Create formula evaluator (needed to infer proper cell type into rawarr)
  frm_eval = wb.getCreationHelper().createFormulaEvaluator();

  % Read contents into rawarr
  rawarr = cell (nrows, ncols);               %% create placeholder
  for ii = firstrow:lastrow
    irow = xlsSheet.getRow (ii-1);
    if ~isempty(irow)
      scol = irow.getFirstCellNum;
      ecol = irow.getLastCellNum - 1;
      for jj = lcol:rcol
        scell = irow.getCell(jj-1);
        if ~isempty(scell)
          % Explore cell contents
          type_of_cell = scell.getCellType();
          % 0 = numeric, 1 = string, 2 = formula, 3 = blank, 4= boolean, 5 = error
          if type_of_cell == 2       %%  2 Formula
              cvalue = frm_eval.evaluate(scell);
              if isempty(cvalue)
                  type_of_cell=3;
              else
                type_of_cell = cvalue.getCellType();
              end
            %if ~spsh_opts.formulas_as_text
%               try    
%                 %% Because not al Excel formulas have been implemented in POI
%                 cvalue = frm_eval.evaluate (scell);
%                 type_of_cell = cvalue.getCellType();
%                 %% Separate switch because form.eval. yields different type
%                 switch type_of_cell
%                     %1= numeric, 2= string, 3=formula, 4=blank, 5=boolean, 6=error;
%                   case 1             %% Numeric
%                     rawarr{ii+1-firstrow, jj+1-lcol} = cvalue.getNumberValue ();
%                   case 2               %% String
%                     rawarr{ii+1-firstrow, jj+1-lcol} = char(cvalue.getStringValue ());
%                   case 5              %% Boolean
%                     rawarr{ii+1-firstrow, jj+1-lcol} = cvalue.BooleanValue ();
%                   otherwise
%                     %% Nothing to do here
%                 end
%                 %% Set cell type to blank to skip switch below
%                 type_of_cell = 4;
%               catch
%                 %% In case of formula errors we take the cached results
%                 type_of_cell = scell.getCachedFormulaResultType ();
%                 %% We only need one warning even for multiple errors 
%                 jerror=jerror+1;     
%               end
%             %end
          end
          %% Preparations done, get data values into data array
          switch type_of_cell
            case 0                    %% 0 Numeric
              rawarr{ii+1-firstrow, jj+1-lcol}= scell.getNumericCellValue ();
            case 1                    %% 1 String
              rawarr {ii+1-firstrow, jj+1-lcol} = ...
                                        char (scell.getRichStringCellValue ());
            case 2
              %if (spsh_opts.formulas_as_text)
                tmp = char (scell.getCellFormula ());
                rawarr {ii+1-firstrow, jj+1-lcol} =  tmp;
              %end
            case 3                     %% 3 Blank
              %% Blank; ignore until further notice
            case 4                     %% 4 Boolean
              rawarr {ii+1-firstrow, jj+1-lcol} = scell.getBooleanCellValue ();
            otherwise                         %% 5 Error
              %% Ignore
          end
        end
      end
    end
  end
emptr = cellfun ('isempty', rawarr);
if all(all(emptr))
  rawarr = {};
  xlslimits = [];
else
  nrows = size(rawarr, 1); ncols = size (rawarr, 2);
  irowt = 1;
  rstatus=1;
  while (all (emptr(irowt, :))), irowt=irowt+1; end
  irowb = nrows;
  while (all(emptr(irowb, :))), irowb=irowb-1; end
  icoll = 1;
  while (all(emptr(:, icoll))), icoll=icoll+1; end
  icolr = ncols;
  while (all (emptr(:, icolr))), icolr=icolr-1; end

  %% Crop output cell array and update limits
  rawarr = rawarr(irowt:irowb, icoll:icolr);
  xlslimits = [icoll-1, icolr-ncols; irowt-1, irowb-nrows];
end
if (rstatus)
  [numarr, txtarr, lims] = parsecell(rawarr, xlslimits);
else
  rawarr = {}; numarr = []; txtarr = {};
end
num=numarr;
txt=txtarr;
raw=rawarr;

% Write & close the workbook
fileOut = java.io.FileOutputStream(filename);
xlsWorkbook.write(fileOut);
fileOut.close();

status = 1;

end
function [ numarr, txtarr, lim ] = parsecell (rawarr, rawlimits)


  lim = struct ( 'numlimits', [],'txtlimits', []);

  numarr = [];
  txtarr = {};
 
  if ~isempty (rawarr)
    %% Valid data returned. Divide into numeric & text arrays
    no_txt = 0; no_num = 0;
    if (all (all (cellfun (@isnumeric, rawarr))))
      numarr = num2cell (rawarr); 
      no_txt = 1;
    elseif (iscellstr (rawarr))
      txtarr = cellstr (rawarr);
      no_num = 1;
    end
    %% Prepare parsing
    [nrows, ncols] = size (rawarr);
 
    %% Find text entries in raw data cell array
    txtptr = cellfun ('isclass', rawarr, 'char');
    if (~no_txt)
      %% Prepare text array. Create placeholder for text cells
      txtarr = cell (size (rawarr));
      txtarr(:) = {''};
      if (any (any (txtptr)))
        %% Copy any text cells found into place holder
        txtarr(txtptr) = rawarr(txtptr);
        %% Clean up text array (find leading / trailing empty
        %% rows & columns)
        irowt = 1;
        while ~any(txtptr(irowt, :)); irowt=irowt+1; end
        irowb = nrows;
        while ~any(txtptr(irowb, :)); irowb=irowb-1; end
        icoll = 1;
        while ~any (txtptr(:, icoll)); icoll=icoll+1; end
        icolr = ncols;
        while ~any (txtptr(:, icolr)); icolr=icolr-1; end
        %% Crop textarray
        txtarr = txtarr(irowt:irowb, icoll:icolr);
        lim.txtlimits = [icoll, icolr; irowt, irowb];
        if ~isempty(rawlimits)
          correction = [1; 1];
          lim.txtlimits(:,1) = lim.txtlimits(:,1) + rawlimits(:,1) - correction;
          lim.txtlimits(:,2) = lim.txtlimits(:,2) + rawlimits(:,1) - correction;
        end
      else
        %% If no text cells found return empty text array
        txtarr = {};
      end
    end

    if ~no_num
      %% Prepare numeric array. Set all text & empty cells to NaN.
      %% First get their locations
      emptr = cellfun('isempty', rawarr);
      emptr(find (txtptr)) = 1;
      if all(all(emptr))
        numarr= [];
      else
        %% Find leading & trailing empty rows
        irowt = 1;
        while (all(emptr(irowt, :))); irowt=irowt+1; end
        irowb = nrows;
        while (all(emptr(irowb, :))); irowb=irowb-1; end
        icoll = 1;
        while (all(emptr(:, icoll))); icoll=icoll+1; end
        icolr = ncols;
        while (all(emptr(:, icolr))); icolr=icolr-1; end

        %% Pre-crop rawarr
        rawarr = rawarr (irowt:irowb, icoll:icolr);
        %% Build numerical array
        numarr = zeros (irowb-irowt+1, icolr-icoll+1);
        %% Watch out for scalar (non-empty) numarr where emptr = 0
        if (sum (emptr(:)) > 0)
          numarr(emptr(irowt:irowb, icoll:icolr)) = NaN;
        end
        numarr(~emptr(irowt:irowb, icoll:icolr)) = cell2mat (rawarr(~emptr(irowt:irowb, icoll:icolr)));
        %% Save limits
        lim.numlimits = [icoll, icolr; irowt, irowb];
        if ~(isempty (rawlimits))
          correction = [1; 1];
          lim.numlimits(:,1) = lim.numlimits(:,1) + rawlimits(:,1) - correction(:);
          lim.numlimits(:,2) = lim.numlimits(:,2) + rawlimits(:,1) - correction(:);
        end
      end
    end

    lim.rawlimits = rawlimits;
 
  end

end
function [ trow, brow, lcol, rcol ] = getusedrange(sh)

  %persistent cblnk; 
  %cblnk = __java_get__ ("org.apache.poi.ss.usermodel.Cell", "CELL_TYPE_BLANK");

  %sh = xls.workbook.getSheetAt (ii-1);          %% Java POI starts counting at 0 

  trow = sh.getFirstRowNum();                  %% 0-based
  brow = sh.getLastRowNum();                   %% 0-based
  %% Get column range
  lcol = 1048577;                               %% OOXML (xlsx) max. + 1
  rcol = 0;
  botrow = brow;
  for jj=trow:brow
    irow = sh.getRow(jj);
    if ~isempty(irow)
      scol = irow.getFirstCellNum;
      %% If getFirstCellNum < 0, row is empty
      if (scol >= 0)
        lcol = min (lcol, scol);
        ecol = irow.getLastCellNum - 1;
        rcol = max (rcol, ecol);
        %% Keep track of lowermost non-empty row as getLastRowNum() is unreliable
%         if  irow.getCell(scol).getCellType () ~= cblnk  && irow.getCell(ecol).getCellType () == cblnk
%           botrow = jj;
%         end
      end
    end
  end
  if (lcol > 1048576)
    %% Empty sheet
    trow = 0; brow = 0; lcol = 0; rcol = 0;
  else
    %% 1-based retvals
    brow = min (brow, botrow) + 1; 
    trow=trow+1; 
    lcol=lcol+1; 
    rcol=rcol+1;
  end

end