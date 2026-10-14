







********************** Data *********************

Evaluation results of CMIP5 and CMIP6 models by the DEI and its error decompositions are saved as NetCDF files in the ./eval_data folder, with the name 'E-AS.eval.DEI.var.season.climatmean'. The 'var' includes precipitation (pr), near-surface temperature (tas), multi-level air temperature (ta.3var), multi-level geopotential height (zg.3var), multi-level specific humidity (hus.3var), and multi-level vector wind (uv). The 'season' includes JJA and DJF. 

Each NetCDF file comprises six sets of performance metrics:

stats            [Nmodel]x[4] - ME (VME), modelled SD (cRMSL), observed SD (cRMSL), CORR (cVSC) 
                                for scalar variable (multiple fields) simulated by models
DEI              [Nmodel]     - Decomposable error index of models
ErrorPenalty     [Nmodel]x[3] - Error components of DEI targeting mean error (Mean), anomaly amplitude 
                                error (AnoA), and anomaly similarity error (AnoS) for models

MME_stats        [Nmme]x[4]   - ME (VME), modelled SD (cRMSL), observed SD (cRMSL), CORR (cVSC) 
                                for scalar variable (multiple fields) simulated by CMIP5 MME and CMIP6 MME
MME_DEI          [Nmme]       - Decomposable error index of CMIP5 MME and CMIP6 MME
MME_ErrorPenalty [Nmme]x[3]   - Error components of DEI targeting mean error (Mean), anomaly amplitude 
                                error (AnoA), and anomaly similarity error (AnoS) for CMIP5 MME and CMIP6 MME


Nmodel is the number of all CMIP5 and CMIP6 models, including "ACCESS1-0","BCC-CSM1-1","BNU-ESM","CCSM4",\
     "CESM1-CAM5","CMCC-CESM","CNRM-CM5","CSIRO-Mk3-6-0","CanESM2","EC-EARTH","FGOALS-g2","FGOALS-s2",\
     "GFDL-ESM2M","GISS-E2-H","GISS-E2-R","HadCM3","HadGEM2-ES","IPSL-CM5A-LR","IPSL-CM5A-MR","MIROC-ESM-CHEM",\
     "MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",\
     "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-1","EC-Earth3","FGOALS-f3-L","FGOALS-g3",\
     "FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H","INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G",
     "MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR","MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM"
        
********************** Script *********************

We provide NCL and Python scripts to generate Figures 2–7 and S2–S3 in the manuscript.

