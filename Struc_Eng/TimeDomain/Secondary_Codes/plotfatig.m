function[worstlife]=plotfatig(path0, BatchNo, LineNo, PartName, TorB, xaxis, ForNot)

FileName = [path0,BatchNo,'\',LineNo,'_',PartName,'_',TorB,'.csv'];
data=importdata(FileName);
if xaxis =='x' 
    [y,ind] = sort(data(:,2));
else if xaxis == 'y'
        [y,ind] = sort(data(:,3));
    else if xaxis == 'z'
            [y,ind] = sort(data(:,4));
        else
            fprintf(1,'xaxis input is not valid')
        end
    end
end

if ForNot == 'y'
    for i = 1:size(y,1)
        Life(i) = data(ind(i),6);
    end
else if ForNot == 'n'
        for i = 1:size(y,1)
            Life(i) = data(ind(i),5);
        end
    end
end

figure(1)
plot (y,Life,'.-')
% ylim([0 25])
xlabel('Angle(degree) or s(mm)')
ylabel('Estimated fatigue life (yr)')
hgsave ([path0,BatchNo,'\',LineNo,'_',PartName,'_',TorB])
close
worstlife = min(Life);

end