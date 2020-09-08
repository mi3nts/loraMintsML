 # loraMintsML
 The current Repo houses codes for the analysis of Mints Lora Nodes. The repo is divided into 3 sections:
  - Data Processing 
  - Time Series Representations 
  - Calibration 
  
  
## Data Processing 
The data processing section is designed to download and concatinate data files of individual nodes. 

### Operation Pre Requisites 

#### Rsync 
The code needs rsync installed on your PC. 
```sudo apt install rsync grsync```

#### Data Access 
The host computer should have access to **mints@mintsdata.utdallas.edu:raw**. This will be provided upod request. 


#### Example shell script to get Lora data under in its raw from *mintsdata.utdallas.edu* 

```
rsync -avzrtu --exclude={"*.png","*.jpg"} -e "ssh -p 2222" mints@mintsdata.utdallas.edu:raw/b827ebf74482/ /media/teamlary/teamlary3/air930/mintsData/b827ebf74482/
```
**(b827ebf74482 is the gateway ID for this example)**

### Operation

Once access is granted to **mints@mintsdata.utdallas.edu:raw** the YAML(mintsDefinitions.yaml) file needs to be modified. The directory structure in which the files are situated is given below.
<pre>── <font color="#729FCF"><b>loraMintsML</b></font>
│   ├── <font color="#729FCF"><b>firmware</b></font>
│   │       ├── mintsDefinitions.yaml
│   │   └── <font color="#729FCF"><b>dataProcessing</b></font>
│   │       ├── L0001_raw2Mat.m
</pre>

Please choose a directory where you need to create the mints data files with the name 'mintsData'. **Make sure to keep a common 'mintsData' for all MINTS Projects**. Then point to the said folder on the yaml file under the label 'dataFolder'. In most Mints Data packages are resampled within a pre defined period for synchronizing multiple data samples. For Lora sensor data and mints other MINTS Air Monitoring data sources its fit to resample to a period of 30 seconds. As such 30 can be put under timeSpan. Under the gatewayIDs list, type in all the Lora Gateway IDs present. After registering each Lora node on the Gateways, list them down under the loraIDs field on the YAML file. The rest of the fields present are for the lora Data calibration purposes. **Since the YAML file is shared by all the sections present, its put under the firmware folder. If needed unique YAML file can be used for each section.** An example YAML File is given below. 
```
dataFolder: "/media/teamlary/teamlary3/air930/mintsData"

timeSpan: 30 

gatewayIDs: 
    - "b827eb60cd60"
    - "b827eb52fc29"
    - "b827ebf74482"
    - "b827eb70fd4c"

loraIDs:
    - "475a5fe3002e0023"
    - "475a5fe3002a0019"
    - "475a5fe3003e0023"
    - "475a5fe30031001b"
    - "475a5fe300320019"
    - "475a5fe300380019"
    - "477b41f200290024"
    - "475a5fe3002e001f"
    - "477b41f20047002e"
    - "475a5fe30021002d"
    - "475a5fe30031001f"
    - "475a5fe30028001f"
    - "478b5fe30040004b"
    - "472b544e00250037"
    - "47eb5580003c001a"
    - "47db5580001e0039"
    - "479b558000380033"
    - "472b544e00230033"
    - "478b558000330027"
    - "475a5fe30035001b"
    - "472b544e0024004b"
    - "470a55800048003e"
    - "475a5fe3002a001a"
    - "47cb5580003a001c"
    - "475a5fe300300019"
    - "475a5fe3002e0018"
    - "472b544e0018003d"
    - "476a5fe300220022"
    - "472b544e001b003c"
    - "47bb558000280041"
    - "47db5580002d0043"
    - "477b41f20048001f"
    - "47fb558000450044"
    - "475b41f20037001e"
    - "478b5fe30040004b"
    - "475a5fe30039002a"
    - "479b5580001a0031"
    - "475a5fe3002f001b"
    - "47cb5580002e004a"
    - "471a55800038004e"


airmarID: "001e0610c0e4"

deployments:
    "477b41f20047002e": "2020-08-20 00:00:00"
    "472b544e00250037": "2020-08-20 00:00:00"

binsPerColumn  : 400
numberPerBin   : 2 
pValid         : 0.15

```
Once the YAML file is updated you can run the ' L0001_raw2Mat.m' file under matlab **(Make sure you point to the proper YAML file on the matlab script)**. This should result in creating unique .mat files for each node which concatinates all lora data belonging to that node. The said files can be found within the folder structure described below.

<pre>── <font color="#729FCF"><b>mintsData</b></font>
│   ├── <font color="#729FCF"><b>rawMats</b></font>
│   │   └── <font color="#729FCF"><b>lora</b></font>
│   │        ─ lora
│   │             ├── loraMints_470a55800048003e.mat
│   │             ├── loraMints_472b544e0018003d.mat
│   │             ├── loraMints_472b544e001b003c.mat
│   │             ├── ...
</pre>

The 'loraMints_--loraID--.mat' files contains the folowing data attributes. 
- NH3              
- CO               
- NO2              
- C3H8             
    - 'C4H10'            
    - 'CH4'              
    - 'H2'               
    - 'C2H5OH'           
    - 'P1_lpo'           
    - 'P1_ratio'         
    - 'P1_conc'          
    - 'P2_lpo'           
    - 'P2_ratio'         
    - 'P2_conc'          
    - 'Temperature'      
    - 'Pressure'         
    - 'Humidity'         
    - 'gpsTime'          
    - 'Latitude'         
    - 'Longitude'        
    - 'shuntVoltageBat'  
    - 'busVoltageBat'    
    - 'currentBat'       
    - 'shuntVoltageSol'  
    - 'busVoltageSol'    
    - 'currentSol'       
    - 'CO2'              
    - 'SCD30_temperature'
    - 'SCD30_humidity'   





