;FUCTION**************************************************
undef("Decompose_DEI2")
function Decompose_DEI2( VME, cRMSL_A, cRMSL_O, cVSC)
local VME, cRMSL, cVSC, C_VME, C_cRMSL, C_cVSC
begin
   AC_VME = VME^2
   AC_cRMSL = (cRMSL_A-cRMSL_O)^2
   AC_cVSC = 2*cRMSL_O^2*(1-cVSC)

   return([/AC_VME,AC_cRMSL,AC_cVSC/])
end
;*******************************************************
undef("Cal_stat4_araweight")
function Cal_stat4_araweight( model, obs, lat_wgt )
local model, obs, lat_wgt, DEI2, VME, ano_A, ano_O, cRMSL_A,\
   cRMSL_O,cVSC
begin
   VME = sqrt(sum((wgt_areaave((model-obs), lat_wgt, 1.0, 0))^2))

   if (dimsizes(dimsizes(model)).gt.2) then
      ano_A = model - conform_dims(dimsizes(model), wgt_areaave(model, lat_wgt, 1.0, 0), 0)
      ano_O = obs - conform_dims(dimsizes(obs), wgt_areaave(obs, lat_wgt, 1.0, 0), 0)
   else 
      ano_A = model - wgt_areaave(model, lat_wgt, 1.0, 0)
      ano_O = obs - wgt_areaave(obs, lat_wgt, 1.0, 0)
   end if

   cRMSL_A = sqrt( sum(wgt_areaave(ano_A^2, lat_wgt, 1.0, 0)))
   cRMSL_O = sqrt( sum(wgt_areaave(ano_O^2, lat_wgt, 1.0, 0)))
   cVSC = sum(wgt_areaave(ano_O*ano_A, lat_wgt, 1.0, 0))/(cRMSL_A*cRMSL_O)

   DEI2 = VME^2 + (cRMSL_A-cRMSL_O)^2 + 2*cRMSL_O^2*(1-cVSC)

   return([/DEI2, VME, cRMSL_A, cRMSL_O, cVSC/])
end
;*******************************************************
undef("Cal_stat4")
function Cal_stat4( model, obs ) ;model & obs NvarxNgrid
local model, obs, DEI2, VME, ano_A, ano_O, cRMSL_A,\
   cRMSL_O,cVSC
begin
   VME = sqrt(sum(dim_avg(model-obs)^2))

   if (dimsizes(dimsizes(model)).gt.1) then
      ano_A = model - conform_dims(dimsizes(model), dim_avg(model), 0)
      ano_O = obs - conform_dims(dimsizes(obs), dim_avg(obs), 0)
   else 
      ano_A = model - avg(model)
      ano_O = obs - avg(obs)
   end if

   cRMSL_A = sqrt( sum(dim_avg(ano_A^2)))
   cRMSL_O = sqrt( sum(dim_avg(ano_O^2)))
   cVSC = sum(dim_avg(ano_O*ano_A))/(cRMSL_A*cRMSL_O)

   DEI2 = VME^2 + (cRMSL_A-cRMSL_O)^2 + 2*cRMSL_O^2*(1-cVSC)

   return([/DEI2, VME, cRMSL_A, cRMSL_O, cVSC/])
end
;*******************************************************
undef("Normalize_field_areawgt")
function Normalize_field_areawgt(model, obs, lat_wgt)
local model, obs, lat_wgt, rms_obs, obs_nor, model_nor
begin
   rms_obs = sqrt( sum(wgt_areaave(obs^2, lat_wgt, 1.0, 0)))
   obs_nor = obs/rms_obs
   model_nor = model/rms_obs 

   return([/obs_nor,model_nor/])
end
;*******************************************************
begin
  varn0 = getenv("varn")
  sean = getenv("sean")

  varn = varn0+"_"+(/"850","500","200"/)
  domainn = "E-AS"
  climatefn =  "climatemean" 
  
;info--------------------------------------------------------
  
  modeln = (/"ACCESS1-0","BCC-CSM1-1","BNU-ESM","CCSM4","CESM1-CAM5","CMCC-CESM",\
        "CNRM-CM5","CSIRO-Mk3-6-0","CanESM2","EC-EARTH","FGOALS-g2","FGOALS-s2",\
        "GFDL-ESM2M","GISS-E2-H","GISS-E2-R","HadCM3","HadGEM2-ES","IPSL-CM5A-LR",\
        "IPSL-CM5A-MR","MIROC-ESM-CHEM","MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3",\
        "NorESM1-M","inmcm4","ACCESS-ESM1-5","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",\
        "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-1","EC-Earth3",\
        "FGOALS-f3-L","FGOALS-g3","FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H",\
        "INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR",\
        "MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM"/)
  Nm = dimsizes(modeln)

  dir = "../GCM_data/" 

  if  ((varn(0).eq."pr").or.(varn(0).eq."tas")) then     
    fn2 = ".hist.sfcVar."+climatefn+".1979-2005."+sean+".nc"
    fn_obs = "Obs"+fn2
  else
    fn2 = ".hist.airVar."+climatefn+".1979-2005."+sean+".nc"
    fn_obs = "ERA5"+fn2
  end if
  f_obs = addfile(dir+fn_obs, "r")

  domain_lat = (/-0.24,50.5/)
  domain_lon = (/51.59,181.5/)

  Nvar = dimsizes(varn)
  N_CMIP5 = 26

;read-------------------------------------------------------

  Nlon = dimsizes(f_obs->lon({lon|domain_lon(0):domain_lon(1)}))
  Nlat = dimsizes(f_obs->lat({lat|domain_lat(0):domain_lat(1)}))

  obsD := new((/Nvar,Nlat,Nlon/), float)
  do ii = 0,(Nvar-1)
    obsD(ii,:,:) = f_obs->$varn(ii)$({lat|domain_lat(0):domain_lat(1)},{lon|domain_lon(0):domain_lon(1)})
  end do
  dim := dimsizes(obsD)

  obsD@_FillValue = default_fillvalue("float")
  replace_ieeenan(obsD, obsD@_FillValue,0)

  modelD := new((/Nm,Nvar, Nlat,Nlon/), float)

  Mask0 = new(dim, float)
  Mask0 = 0
  Mask0 = Mask0 + obsD - obsD

  
  do i = 0,(Nm-1)
    f := addfile(dir+modeln(i)+fn2, "r")

    do ii = 0,(Nvar-1)
      modelD(i,ii,:,:) = f->$varn(ii)$({lat|domain_lat(0):domain_lat(1)},{lon|domain_lon(0):domain_lon(1)})
    end do

    Mask0 = Mask0 + modelD(i,:,:,:) - modelD(i,:,:,:)
  end do
  
  latwgt = cos(f->lat({lat|domain_lat(0):domain_lat(1)}) * 4.*atan(1.)/180.)
  
;cal--------------------------------------------------------
  ModelPn = (/"Mean","Amplitude","Similarity"/)
  Bias3_contribution = new((/Nm,3/), float)
  Bias3_isdriver = new((/Nm,3/), integer)
  Bias3_isdriver  = 0

  fn = "../eval_data/"+domainn+".eval.DEI."+varn0+".3var."+sean+"."+climatefn+".nc"
  system("rm "+fn)
  fo = addfile(fn, "c")

  stats = new((/Nm,4/), float)
  DEI = new(Nm, float)
  AContri = new((/Nm,3/), float)

  
  do i = 0,(Nm-1)
    nor_imodelD := new(dimsizes(obsD), float)
    nor_iobsD := new(dimsizes(obsD), float)

    do ivar = 0,2
      R0 := Normalize_field_areawgt(modelD(i,ivar,:,:)+Mask0(ivar,:,:), obsD(ivar,:,:)+Mask0(ivar,:,:), latwgt)
      nor_imodelD(ivar,:,:) = R0[1]
      nor_iobsD(ivar,:,:) = R0[0]
    end do
    
    R1 := Cal_stat4_araweight(nor_imodelD, nor_iobsD, latwgt)
    R2 := Decompose_DEI2(R1[1],R1[2],R1[3],R1[4])

    DEI(i) = sqrt(R1[0])
    stats(i,:) = (/R1[1],R1[2],R1[3],R1[4]/)
    AContri(i,:) = (/R2[0],R2[1],R2[2]/)

    RContri3 := (/R2[0],R2[1],R2[2]/)/R1[0]*100

    Bias3_isdriver(i,maxind(RContri3)) = 1
    Bias3_contribution(i,maxind(RContri3)) = RContri3(maxind(RContri3))

  end do

  ;MME
  MME_DEI = new(2, float)
  MME_stats = new((/2,4/), float)
  MME_AContri = new((/2,3/), float)

  do i = 0,1
    if (i.eq.0) then  
      imodelD := dim_avg_n(modelD(0:N_CMIP5-1,:,:,:),0)
    else
      imodelD := dim_avg_n(modelD(N_CMIP5:,:,:,:),0)
    end if
      
    nor_imodelD := new(dimsizes(obsD), float)
    nor_iobsD := new(dimsizes(obsD), float)

    do ivar = 0,2
      R0 := Normalize_field_areawgt(imodelD(ivar,:,:)+Mask0(ivar,:,:), obsD(ivar,:,:)+Mask0(ivar,:,:), latwgt)
      nor_imodelD(ivar,:,:) = R0[1]
      nor_iobsD(ivar,:,:) = R0[0]
    end do
    
    R1 := Cal_stat4_araweight(nor_imodelD, nor_iobsD, latwgt)
    R2 := Decompose_DEI2(R1[1],R1[2],R1[3],R1[4])

    
    MME_DEI(i) = sqrt(R1[0])
    MME_stats(i,:) = (/R1[1],R1[2],R1[3],R1[4]/)
    MME_AContri(i,:) = (/R2[0],R2[1],R2[2]/)

    if (i.eq.0) then
       print("****CMIP5 MME DEI: "+sqrt(R1[0]))
    else
      print("****CMIP6 MME DEI: "+sqrt(R1[0]))
    end if
    print("--"+str_join(tostring(MME_AContri(i,:)*100), ","))
  end do

  stats@longname = "VME, cRMSL_A, cRMSL_O, cVSC"
  AContri@longname = "Mean, AnoA, AnoS"
  MME_DEI@longname = "CMIP5, CMIP6"
  MME_stats@longname = "VME, cRMSL_A, cRMSL_O, cVSC"
  MME_AContri@longname = "Mean, AnoA, AnoS"

  fo->DEI = DEI
  fo->stats = stats
  fo->ErrorPenalty = AContri
 
  fo->MME_DEI = MME_DEI
  fo->MME_stats = MME_stats
  fo->MME_ErrorPenalty = MME_AContri

  N_CMIP5 = 26
  print("******"+domainn+": "+varn(0)+"&"+varn(1)+", "+sean+"******")

  print("------CMIP5-------")
  do i = 0,2
    print(ModelPn(i)+": "+sprintf("%3.2f",sum(Bias3_isdriver(0:N_CMIP5-1,i))/tofloat(N_CMIP5)*100)+\
      "%     ("+min(Bias3_contribution(0:N_CMIP5-1,i))+"%-"+\
      max(Bias3_contribution(0:N_CMIP5-1,i))+"%)" )
  end do
  print("------CMIP6-------")
  do i = 0,2
    print(ModelPn(i)+": "+sprintf("%3.2f",sum(Bias3_isdriver(N_CMIP5:,i))/tofloat(Nm-N_CMIP5)*100)+\
      "%     ("+min(Bias3_contribution(N_CMIP5:,i))+"%-"+\
      max(Bias3_contribution(N_CMIP5:,i))+"%)" )
  end do

end
