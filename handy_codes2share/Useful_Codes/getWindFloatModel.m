function [WindFloat,WindFloatType]=getWindFloatModel(model)
objects = model.objects; % model objects
vessel = objects(cellfun(@(obj) isa(obj, 'ofxVesselObject'), objects)); %find the vessel
try 
    foovessel = vessel{1}; %grab first vessel, hopefully only 1 vessel in file
    VesselName =foovessel.name;
    fooVesselType = model(foovessel.VesselType); %takes the current vesseltype of the model!
    VesselType=fooVesselType.name;
%DraftName='Draught1';

    WindFloat = model(VesselName);
    WindFloatType = model(VesselType);
catch
    WindFloat=[];
    WindFloatType=[];
end
end