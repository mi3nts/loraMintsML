function  mintsData = loraRead(fileName)
%LORAREAD Summary of this function goes here
%   Detailed explanation goes here


    %% Setup the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 31);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = ",";

    % Specify column names and types
    opts.VariableNames = ["dateTime", "id", "NH3", "CO", "NO2", "C3H8", "C4H10", "CH4", "H2", "C2H5OH", "P1_lpo", "P1_ratio", "P1_conc", "P2_lpo", "P2_ratio", "P2_conc", "Temperature", "Pressure", "Humidity", "gpsTime", "Latitude", "Longitude", "shuntVoltageBat", "busVoltageBat", "currentBat", "shuntVoltageSol", "busVoltageSol", "currentSol", "CO2", "SCD30_temperature", "SCD30_humidity"];
    opts.VariableTypes = ["datetime", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts     = setvaropts(opts, "id", "EmptyFieldRule", "auto");
    opts     = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss");

    % Import the data
    mintsData = readtable(fileName, opts);
   
    mintsData.dateTime.TimeZone = "utc";
    
    mintsData(isundefined(mintsData.id),:)=[];
    
    %% Clear temporary variables
    clear opts


end

