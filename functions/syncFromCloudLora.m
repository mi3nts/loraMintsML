function [] = syncFromCloudLora(gatewayIDs,mintsDataFolder)

    for gatewayIndex = 1: length(gatewayIDs) 
        gatewayID  = gatewayIDs{gatewayIndex}
        system(strcat('rsync -avzrtu --exclude={"*.png","*.jpg"} -e "ssh -p 2222" mints@mintsdata.utdallas.edu:raw/',...
                gatewayID,"/ ",mintsDataFolder,"/raw/",gatewayID,"/"))

    end
    
end



