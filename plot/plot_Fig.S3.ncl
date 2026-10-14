load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*******************************************************
;*******************************************************
begin
;*******************************************************
domainn = "E-AS"
ind_index = 1 ; 0-DEI / 1-KGE / 2-RMSE

if (ind_index.eq.1) then
  indexn = "KGE"
  wks = gsn_open_wks("pdf","Fig.S3.pdf") 
end if

;*******************************************************
;READ***************************************************************
modeln = (/"ACCESS-ESM1-5","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",\
        "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-1","EC-Earth3",\
        "FGOALS-f3-L","FGOALS-g3","FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H",\
        "INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR",\
        "MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM","CMIP6_MME"/)
varn = (/"pr","tas","ta.3var","zg.3var","hus.3var","uv"/)
sean = (/"JJA","DJF"/)

Nm = dimsizes(modeln)
Nvar = dimsizes(varn)
Nsea = dimsizes(sean)


nDEI = new((/2,Nm,Nvar/), float)
model_Rank = new((/2,Nm,Nvar/), integer)

dir = "../eval_data/"+domainn+".eval.DEI."

N_CMIP5 = 26
N_CMIP6 = 26

do i = 0,(Nvar-1)
  do j = 0,(Nsea-1)
    f := addfile(dir+varn(i)+"."+sean(j)+".climatemean.nc","r")
    DEI := f->DEI
    istats := f->stats
    inDEI = DEI/istats(:,2)

    MME_DEI := f->MME_DEI
    MME_stats := f->MME_stats
    MME_DEI = MME_DEI/MME_stats(:,2)

    if (ind_index.eq.0) then
      nDEI(j,0:N_CMIP6-1,i) = inDEI(N_CMIP5:)
      nDEI(j,N_CMIP6,i) = MME_DEI(1)

      Rank_ind := dim_pqsort(nDEI(j,:,i), 1)
    end if
    if (ind_index.eq.1) then
      nDEI(j,0:N_CMIP6-1,i) = 1- sqrt((istats(N_CMIP5:,0)/istats(N_CMIP5:,2))^2+(istats(N_CMIP5:,1)/istats(N_CMIP5:,2)-1)^2+(istats(N_CMIP5:,3)-1)^2)
      nDEI(j,N_CMIP6,i) = 1 - sqrt((MME_stats(1,0)/MME_stats(1,2))^2+(MME_stats(1,1)/MME_stats(1,2)-1)^2+(MME_stats(1,3)-1)^2)

      Rank_ind := dim_pqsort(nDEI(j,:,i), -1)
    end if
    if (ind_index.eq.2) then
      nDEI(j,0:N_CMIP6-1,i) = sqrt((istats(N_CMIP5:,0)/istats(N_CMIP5:,2))^2+1+(istats(N_CMIP5:,1)/istats(N_CMIP5:,2))^2-2*istats(N_CMIP5:,1)/istats(N_CMIP5:,2)*istats(N_CMIP5:,3))
      nDEI(j,N_CMIP6,i) = sqrt((MME_stats(1,0)/MME_stats(1,2))^2+1+(MME_stats(1,1)/MME_stats(1,2))^2-2*MME_stats(1,1)/MME_stats(1,2)*MME_stats(1,3))
    
      Rank_ind := dim_pqsort(nDEI(j,:,i), 1)
    end if

    do im = 0,(N_CMIP6)
      model_Rank(j,Rank_ind(im),i) = im+1
    end do

    if ((i.eq.5).and.(j.eq.0)) then
      VME_all = new(N_CMIP6+1,float)
      VME_all(0:N_CMIP6-1) = istats(N_CMIP5:,0)
      VME_all(N_CMIP6) = MME_stats(1,0)
      Rank_ind := dim_pqsort(VME_all, 1)


      do im = 0,(N_CMIP6)
        if (Rank_ind(im).eq.N_CMIP6) then 
          print(modeln(im)+": "+MME_stats(1,0)+", "+MME_stats(1,1)+", "+MME_stats(1,2)+", "+MME_stats(1,3))
        else
          print(modeln(Rank_ind(im))+": "+istats(N_CMIP5+Rank_ind(im),0)+", "+istats(N_CMIP5+Rank_ind(im),1)+", "+ \
                istats(N_CMIP5+Rank_ind(im),2)+", "+istats(N_CMIP5+Rank_ind(im),3))
        end if
      end do
    end if
  end do
end do


  
varn = (/"Pr","Tas","T","Z","Q","UV"/)
print(min(nDEI)+","+max(nDEI))
;********************************************************
if (ind_index.eq.0) then ;DEI
  levs_CSEI = (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.,1.1,1.2,1.3,1.4/)
end if
if (ind_index.eq.1) then ;KGE
  levs_CSEI := (/0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9/)
end if
if (ind_index.eq.2) then ;RMSE
  levs_CSEI := (/0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.,1.1,1.2,1.3,1.4/)
end if


cmap0 := read_colormap_file("WhiteYellowOrangeRed")
cmap_CSEI := new((/dimsizes(levs_CSEI)+3,4/), float)

if (ind_index.eq.1) then ;KGE
  cmap_CSEI(2:,:) = span_color_rgba(cmap0(160:20,:), dimsizes(levs_CSEI)+1)
else
  cmap_CSEI(2:,:) = span_color_rgba(cmap0(20:160,:), dimsizes(levs_CSEI)+1)
end if

;********************************************************
box_width  = 0.03
box_height = 0.018
title_height = 0.13
model_height = 0.02
x_width = 0.2

dis_x = 0.08
y_str = 0.95

box_theight = 0.0075
model_theight = 0.009
factor_theight = 0.0092

x_dis = 0.1

;********************************************************
xbox0  = (/0.0,1.0,1.0,0.0,0.0/) 
ybox0  = (/0.0,0.0,1.0,1.0,0.0/)

lres = True
lres@gsLineThicknessF = 1.
lres@gsLineColor = "white"

fres = True  
fres@gsFillOpacityF = 0.9
tres = True
pres = True

do j = 0,(Nsea-1)
  do im = 0,(Nm-1)
     
    tres@txJust = "CenterRight"
    tres@txFont = 21
    tres@txFontHeightF = model_theight

    itx = x_width + j*Nvar*box_width + dis_x*j
    ity = y_str - im*box_height - 0.5*box_height
   
    if (j.eq.0) then
      gsn_text_ndc(wks, modeln(im)+" -", itx, ity, tres)
    else
      gsn_text_ndc(wks, " -", itx, ity, tres)
    end if

    ybox = y_str - im*box_height - box_height*ybox0

   

    do i = 0,(Nvar-1)
       tres@txJust = "CenterCenter"
      tres@txFont = 21
      tres@txFontHeightF = box_theight

      xbox = x_width + j*Nvar*box_width + dis_x*j + i*box_width + box_width*xbox0
      itx = (min(xbox)+max(xbox))/2.
      ity = (min(ybox)+max(ybox))/2.


      fres@gsFillColor := GetFillColor(levs_CSEI, cmap_CSEI, nDEI(j,im,i))
      gsn_polygon_ndc(wks, xbox, ybox, fres)

      if (model_Rank(j,im,i).lt.50) then
        if (model_Rank(j,im,i).lt.8) then
          tres@txFont = 22
        else
          tres@txFont = 21
        end if
        gsn_text_ndc(wks, sprintf("%3.0f",model_Rank(j,im,i)), itx, ity, tres)  
      end if
      tres@txFont = 21

      ;gsn_text_ndc(wks, sprintf("%3.2f",nDEI(j,im,i)), itx, ity, tres)    
      
      gsn_polyline_ndc(wks, xbox, ybox, lres)

      if ((im.eq.0).and.(i.eq.Nvar-1)) then      
        tres@txJust = "BottomRight"
        tres@txAngleF = "0"
        tres@txFontHeightF = model_theight*1.2

        ity = y_str
        itx = max(xbox)
        
        gsn_text_ndc(wks, sean(j), itx, ity, tres)
      end if
    end do
  end do
  tres@txFontHeightF = box_theight*1.2

  do i = 0,(Nvar-1)
    itx = x_width + j*Nvar*box_width + dis_x*j + i*box_width + box_width*0.5
    ity = y_str - Nm*box_height 
    

    tres@txJust = "CenterRight"
    tres@txAngleF = "90"
    gsn_text_ndc(wks, " -", itx, ity, tres)

    
    ity = ity - 0.6*model_height
    tres@txJust = "CenterCenter"
    tres@txAngleF = "0"
    gsn_text_ndc(wks, varn(i), itx, ity, tres)
  end do
  tres@txAngleF = "0"
end do

xline = (/0,1/)
yline = (/y_str - 27*box_height ,y_str - 27*box_height/)
lres@gsLineColor = "black"
;gsn_polyline_ndc(wks, xline, yline, lres)



lbres = True
lbres@lbOrientation        = 0       ; orientation
lbres@lbLabelFontHeightF   = box_theight               ; label font height
lbres@lbLabelAlignment     = "InteriorEdges"     ; where to label
lbres@lbMonoFillPattern    = True                ; fill sold
lbres@lbLabelFont          = 25
lbres@vpWidthF             = 0.27 ;0.05 
lbres@vpHeightF            = 0.03
lbres@lbLabelFont          = 21

Drivern = (/"Mean bias","Anomalous amplitude bias","Anomalous similarity bias"/)
tres = True
tres@txJust = "CenterLeft"
tres@txAngleF = "0"
tres@txFontHeightF = model_theight*1.2
tres@txFont = 22

lbres = True
lbres@lbOrientation        = 0       ; orientation
lbres@lbLabelFontHeightF   = box_theight               ; label font height
lbres@lbLabelAlignment     = "InteriorEdges"     ; where to label
lbres@lbMonoFillPattern    = True                ; fill sold
lbres@lbLabelFont          = 21
lbres@vpWidthF             = 0.45 ;0.05 
lbres@vpHeightF            = 0.035

lbres@lbFillColors         := cmap_CSEI(2:,:)
gsn_labelbar_ndc(wks,dimsizes(levs_CSEI)+1,levs_CSEI, 0.18, 0.43, lbres)

tres@txFontHeightF = box_theight*1.6
tres@txFont = 22
if (indexn.eq."KGE") then
  gsn_text_ndc(wks, "KGE'':", 0.12,0.42, tres)
else
  if (indexn.eq."RMSE") then
    gsn_text_ndc(wks, "nRMSE:", 0.11,0.42, tres)
  else
    gsn_text_ndc(wks, "nDEI:", 0.11,0.42, tres)
    
  end if
end if

tres@txFontHeightF = box_theight*2.
tres@txJust = "BottomRight"
gsn_text_ndc(wks, "a", 0.1,y_str+(1-y_str)*0.1, tres)
gsn_text_ndc(wks, "b", 0.46,y_str+(1-y_str)*0.1, tres)

;drawNDCGrid(wks)
draw(wks)  
frame(wks)


  


;*******************************************************
end