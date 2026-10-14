load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
;*******************************************************
;*******************************************************
begin
;*******************************************************
domainn = "E-AS"
wks = gsn_open_wks("pdf","Fig.4b.pdf") 
;*******************************************************
;READ***************************************************************
modeln = (/"ACCESS1-0","BCC-CSM1-1","BNU-ESM","CCSM4","CESM1-CAM5","CMCC-CESM",\
        "CNRM-CM5","CSIRO-Mk3-6-0","CanESM2","EC-EARTH","FGOALS-g2","FGOALS-s2",\
        "GFDL-ESM2M","GISS-E2-H","GISS-E2-R","HadCM3","HadGEM2-ES","IPSL-CM5A-LR",\
        "IPSL-CM5A-MR","MIROC-ESM-CHEM","MIROC5","MPI-ESM-LR","MPI-ESM-MR","MRI-CGCM3",\
        "NorESM1-M","inmcm4","CMIP5 MME","ACCESS-ESM1-5","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",\
        "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-1","EC-Earth3",\
        "FGOALS-f3-L","FGOALS-g3","FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H",\
        "INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR",\
        "MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM","CMIP6 MME"/)
varn = (/"pr","tas","ta.3var","hus.3var","zg.3var","uv"/)
sean = (/"JJA","DJF"/)

Nm = dimsizes(modeln)
Nvar = dimsizes(varn)
Nsea = dimsizes(sean)

index_driver = new((/2,Nm,Nvar/), integer)
driver_contribution = new((/2,Nm,Nvar/), float)

dir = "../eval_data/"+domainn+".eval.DEI."

N_CMIP5 = 26
N_CMIP6 = 26

do i = 0,(Nvar-1)
  do j = 0,(Nsea-1)
    f := addfile(dir+varn(i)+"."+sean(j)+".climatemean.nc","r")
    ErrorPenalty := f->ErrorPenalty

    do im = 0,(N_CMIP5-1)
       index_driver(j,im,i) = maxind(ErrorPenalty(im,:))
       driver_contribution(j,im,i) = max(ErrorPenalty(im,:))/sum(ErrorPenalty(im,:))*100
    end do

    do im = 0,(N_CMIP6-1)
      index_driver(j,im+N_CMIP5+1,i) = maxind(ErrorPenalty(im+N_CMIP5,:))
      driver_contribution(j,im+N_CMIP5+1,i) = max(ErrorPenalty(im+N_CMIP5,:))/sum(ErrorPenalty(im+N_CMIP5,:))*100
    end do

    MME_ErrorPenalty := f->MME_ErrorPenalty
    index_driver(j,N_CMIP5,i) = maxind(MME_ErrorPenalty(0,:))
    driver_contribution(j,N_CMIP5,i) = max(MME_ErrorPenalty(0,:))/sum(MME_ErrorPenalty(0,:))*100

    index_driver(j,Nm-1,i) = maxind(MME_ErrorPenalty(1,:))
    driver_contribution(j,Nm-1,i) = max(MME_ErrorPenalty(1,:))/sum(MME_ErrorPenalty(1,:))*100

  end do
end do

modeln := (/"ACCESS-ESM1-5","AWI-CM-1-1-MR","BCC-CSM2-MR","CAMS-CSM1-0",\
        "CESM2-WACCM","CESM2","CIESM","CanESM5","E3SM-1-0","EC-Earth3",\
        "FGOALS-f3-L","FGOALS-g3","FIO-ESM-2-0","GFDL-ESM4","GISS-E2-1-G","GISS-E2-1-H",\
        "INM-CM5-0","IPSL-CM6A-LR","KACE-1-0-G","MCM-UA-1-0","MIROC6","MPI-ESM1-2-HR",\
        "MPI-ESM1-2-LR","MRI-ESM2-0","NESM3","NorESM2-MM","CMIP6 MME"/)
varn = (/"pr","tas","ta.3var","hus.3var","zg.3var","uv"/)
sean = (/"JJA","DJF"/)

Nm = dimsizes(modeln)
Nvar = dimsizes(varn)
Nsea = dimsizes(sean)

index_driver := index_driver(:,N_CMIP5+1:,:)
driver_contribution := driver_contribution(:,N_CMIP5+1:,:)

print(num(ismissing(ndtooned(index_driver))))

varn = (/"pr","tas","T","Q","Z","UV"/)
  
;********************************************************
cmap_ME = (/(/ 1.0 , 1.0 , 1.0 /),\
(/ 0.9879336349924586 , 0.9950729009552539 , 0.9979889391654098 /),\
(/ 0.975867269984917 , 0.9901458019105078 , 0.9959778783308195 /),\
(/ 0.9638009049773756 , 0.9852187028657617 , 0.9939668174962293 /),\
(/ 0.951734539969834 , 0.9802916038210155 , 0.991955756661639 /),\
(/ 0.9396681749622926 , 0.9753645047762695 , 0.9899446958270488 /),\
(/ 0.9276018099547512 , 0.9704374057315234 , 0.9879336349924586 /),\
(/ 0.9155354449472096 , 0.9655103066867773 , 0.9859225741578682 /),\
(/ 0.9034690799396682 , 0.9605832076420312 , 0.983911513323278 /),\
(/ 0.8914027149321266 , 0.9556561085972851 , 0.9819004524886877 /),\
(/ 0.8793363499245852 , 0.9507290095525389 , 0.9798893916540975 /),\
(/ 0.8672699849170438 , 0.9458019105077928 , 0.9778783308195073 /),\
(/ 0.8552036199095022 , 0.9408748114630467 , 0.975867269984917 /),\
(/ 0.8431372549019608 , 0.9359477124183007 , 0.9738562091503268 /),\
(/ 0.8310708898944192 , 0.9310206133735546 , 0.9718451483157365 /),\
(/ 0.8190045248868778 , 0.9260935143288085 , 0.9698340874811463 /),\
(/ 0.8069381598793364 , 0.9211664152840624 , 0.9678230266465561 /),\
(/ 0.7948717948717948 , 0.9162393162393162 , 0.9658119658119658 /),\
(/ 0.7828054298642534 , 0.9113122171945701 , 0.9638009049773756 /),\
(/ 0.7707390648567118 , 0.906385118149824 , 0.9617898441427852 /),\
(/ 0.7586726998491704 , 0.901458019105078 , 0.959778783308195 /),\
(/ 0.746606334841629 , 0.8965309200603319 , 0.9577677224736048 /),\
(/ 0.7345399698340875 , 0.8916038210155857 , 0.9557566616390145 /),\
(/ 0.722473604826546 , 0.8866767219708396 , 0.9537456008044243 /),\
(/ 0.7104072398190044 , 0.8817496229260935 , 0.951734539969834 /),\
(/ 0.698340874811463 , 0.8768225238813474 , 0.9497234791352438 /),\
(/ 0.6862745098039216 , 0.8718954248366013 , 0.9477124183006536 /),\
(/ 0.6742081447963801 , 0.8669683257918552 , 0.9457013574660633 /),\
(/ 0.6621417797888386 , 0.8620412267471091 , 0.9436902966314731 /),\
(/ 0.650075414781297 , 0.8571141277023631 , 0.9416792357968828 /),\
(/ 0.6380090497737556 , 0.8521870286576169 , 0.9396681749622926 /),\
(/ 0.6259426847662142 , 0.8472599296128708 , 0.9376571141277024 /),\
(/ 0.6138763197586727 , 0.8423328305681247 , 0.9356460532931121 /),\
(/ 0.6018099547511312 , 0.8374057315233786 , 0.9336349924585218 /),\
(/ 0.5897435897435896 , 0.8324786324786325 , 0.9316239316239315 /),\
(/ 0.5776772247360482 , 0.8275515334338863 , 0.9296128707893413 /),\
(/ 0.5656108597285068 , 0.8226244343891402 , 0.927601809954751 /),\
(/ 0.5535444947209653 , 0.8176973353443941 , 0.9255907491201608 /),\
(/ 0.5414781297134238 , 0.8127702362996481 , 0.9235796882855706 /),\
(/ 0.5294117647058824 , 0.807843137254902 , 0.9215686274509803 /)/)

cmap_CORR = (/(/ 1.0 , 1.0 , 1.0 /),\
(/ 0.9898441427853193 , 0.9949723479135244 , 0.9793866264454499 /),\
(/ 0.9796882855706385 , 0.9899446958270488 , 0.9587732528909 /),\
(/ 0.9695324283559578 , 0.9849170437405732 , 0.9381598793363499 /),\
(/ 0.9593765711412771 , 0.9798893916540975 , 0.9175465057817999 /),\
(/ 0.9492207139265962 , 0.9748617395676219 , 0.8969331322272499 /),\
(/ 0.9390648567119155 , 0.9698340874811463 , 0.8763197586726998 /),\
(/ 0.9289089994972348 , 0.9648064353946707 , 0.8557063851181499 /),\
(/ 0.918753142282554 , 0.9597787833081951 , 0.8350930115635998 /),\
(/ 0.9085972850678733 , 0.9547511312217195 , 0.8144796380090498 /),\
(/ 0.8984414278531926 , 0.9497234791352438 , 0.7938662644544998 /),\
(/ 0.8882855706385118 , 0.9446958270487682 , 0.7732528908999498 /),\
(/ 0.8781297134238311 , 0.9396681749622926 , 0.7526395173453997 /),\
(/ 0.8679738562091504 , 0.934640522875817 , 0.7320261437908497 /),\
(/ 0.8578179989944696 , 0.9296128707893414 , 0.7114127702362997 /),\
(/ 0.8476621417797888 , 0.9245852187028658 , 0.6907993966817496 /),\
(/ 0.8375062845651081 , 0.9195575666163902 , 0.6701860231271997 /),\
(/ 0.8273504273504273 , 0.9145299145299145 , 0.6495726495726496 /),\
(/ 0.8171945701357466 , 0.9095022624434389 , 0.6289592760180995 /),\
(/ 0.8070387129210659 , 0.9044746103569633 , 0.6083459024635496 /),\
(/ 0.7968828557063852 , 0.8994469582704877 , 0.5877325289089995 /),\
(/ 0.7867269984917044 , 0.8944193061840121 , 0.5671191553544495 /),\
(/ 0.7765711412770236 , 0.8893916540975364 , 0.5465057817998995 /),\
(/ 0.7664152840623428 , 0.8843640020110608 , 0.5258924082453494 /),\
(/ 0.7562594268476621 , 0.8793363499245852 , 0.5052790346907994 /),\
(/ 0.7461035696329814 , 0.8743086978381096 , 0.4846656611362494 /),\
(/ 0.7359477124183007 , 0.869281045751634 , 0.46405228758169936 /),\
(/ 0.7257918552036199 , 0.8642533936651584 , 0.4434389140271493 /),\
(/ 0.7156359979889392 , 0.8592257415786828 , 0.42282554047259935 /),\
(/ 0.7054801407742584 , 0.8541980894922072 , 0.4022121669180493 /),\
(/ 0.6953242835595776 , 0.8491704374057315 , 0.3815987933634992 /),\
(/ 0.6851684263448969 , 0.8441427853192559 , 0.36098541980894927 /),\
(/ 0.6750125691302162 , 0.8391151332327803 , 0.3403720462543992 /),\
(/ 0.6648567119155354 , 0.8340874811463047 , 0.31975867269984914 /),\
(/ 0.6547008547008547 , 0.8290598290598291 , 0.2991452991452992 /),\
(/ 0.6445449974861739 , 0.8240321769733534 , 0.27853192559074913 /),\
(/ 0.6343891402714932 , 0.8190045248868778 , 0.25791855203619907 /),\
(/ 0.6242332830568125 , 0.8139768728004022 , 0.23730517848164911 /),\
(/ 0.6140774258421318 , 0.8089492207139266 , 0.21669180492709905 /),\
(/ 0.6039215686274509 , 0.803921568627451 , 0.19607843137254902 /)/)
  
cmap_SD = (/(/ 1.0 , 1.0 , 1.0 /),\
(/ 1.0 , 0.9909502262443439 , 0.9743589743589743 /),\
(/ 1.0 , 0.9819004524886877 , 0.9487179487179487 /),\
(/ 1.0 , 0.9728506787330317 , 0.9230769230769231 /),\
(/ 1.0 , 0.9638009049773756 , 0.8974358974358975 /),\
(/ 1.0 , 0.9547511312217195 , 0.8717948717948718 /),\
(/ 1.0 , 0.9457013574660633 , 0.8461538461538461 /),\
(/ 1.0 , 0.9366515837104072 , 0.8205128205128205 /),\
(/ 1.0 , 0.9276018099547512 , 0.7948717948717949 /),\
(/ 1.0 , 0.9185520361990951 , 0.7692307692307693 /),\
(/ 1.0 , 0.9095022624434389 , 0.7435897435897436 /),\
(/ 1.0 , 0.9004524886877828 , 0.717948717948718 /),\
(/ 1.0 , 0.8914027149321267 , 0.6923076923076923 /),\
(/ 1.0 , 0.8823529411764706 , 0.6666666666666667 /),\
(/ 1.0 , 0.8733031674208145 , 0.641025641025641 /),\
(/ 1.0 , 0.8642533936651584 , 0.6153846153846154 /),\
(/ 1.0 , 0.8552036199095023 , 0.5897435897435898 /),\
(/ 1.0 , 0.8461538461538461 , 0.5641025641025641 /),\
(/ 1.0 , 0.8371040723981901 , 0.5384615384615385 /),\
(/ 1.0 , 0.828054298642534 , 0.5128205128205128 /),\
(/ 1.0 , 0.8190045248868778 , 0.4871794871794872 /),\
(/ 1.0 , 0.8099547511312217 , 0.46153846153846156 /),\
(/ 1.0 , 0.8009049773755657 , 0.4358974358974359 /),\
(/ 1.0 , 0.7918552036199096 , 0.41025641025641024 /),\
(/ 1.0 , 0.7828054298642534 , 0.3846153846153846 /),\
(/ 1.0 , 0.7737556561085973 , 0.35897435897435903 /),\
(/ 1.0 , 0.7647058823529412 , 0.33333333333333337 /),\
(/ 1.0 , 0.755656108597285 , 0.3076923076923077 /),\
(/ 1.0 , 0.746606334841629 , 0.28205128205128205 /),\
(/ 1.0 , 0.7375565610859729 , 0.2564102564102564 /),\
(/ 1.0 , 0.7285067873303168 , 0.23076923076923084 /),\
(/ 1.0 , 0.7194570135746607 , 0.20512820512820518 /),\
(/ 1.0 , 0.7104072398190046 , 0.17948717948717952 /),\
(/ 1.0 , 0.7013574660633484 , 0.15384615384615385 /),\
(/ 1.0 , 0.6923076923076923 , 0.1282051282051282 /),\
(/ 1.0 , 0.6832579185520362 , 0.10256410256410264 /),\
(/ 1.0 , 0.6742081447963801 , 0.07692307692307698 /),\
(/ 1.0 , 0.6651583710407241 , 0.05128205128205132 /),\
(/ 1.0 , 0.656108597285068 , 0.02564102564102566 /),\
(/ 1.0 , 0.6470588235294118 , 0.0 /)/)

levs := (/30,40,50,60,70,80/)
cmap := new((/3,dimsizes(levs)+3,4/), float)
cmap = 1
;for SD
cmap0 := read_colormap_file("MPL_YlOrRd")
cmap(1,2:,0:2) = span_color_rgba(cmap_SD(5:,:), dimsizes(levs)+1)
print("SD: "+cmap(1,2:,0)+","+cmap(1,2:,1)+","+cmap(1,2:,2)+",")
print("------------")
;for ME
;cmap0 := read_colormap_file("MPL_Blues")
cmap(0,2:,0:2) = span_color_rgba(cmap_ME(5:,:), dimsizes(levs)+1)
print("ME: "+cmap(0,2:,0)+","+cmap(0,2:,1)+","+cmap(0,2:,2))
print("------------")
;for CORR
cmap0 := read_colormap_file("MPL_Greens")
cmap(2,2:,0:2) = span_color_rgba(cmap_CORR(5:,:), dimsizes(levs)+1)
print("CORR: "+cmap(2,2:,0)+","+cmap(2,2:,1)+","+cmap(2,2:,2))

levs_CSEI = (/1.,1.5,2,2.5,3,3.5,4,4.5,5,5.5/)
cmap0 := read_colormap_file("WhiteYellowOrangeRed")
cmap_CSEI := new((/dimsizes(levs_CSEI)+3,4/), float)
cmap_CSEI(2:,:) = span_color_rgba(cmap0(20:160,:), dimsizes(levs_CSEI)+1)

;********************************************************
box_width  = 0.03
box_height = 0.0175
title_height = 0.13
model_height = 0.02
x_width = 0.2

dis_x = 0.05
y_str = 0.95

box_theight = 0.0075
model_theight = 0.009
factor_theight = 0.0092

x_dis = 0.05

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

Nm = Nm -1

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


      fres@gsFillColor = GetFillColor(levs, cmap(index_driver(j,im,i),:,:), driver_contribution(j,im,i))
      gsn_polygon_ndc(wks, xbox, ybox, fres)

      gsn_text_ndc(wks, sprintf("%3.0f",driver_contribution(j,im,i))+"%", itx, ity, tres)    
      
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
  varn = (/"Pr","Tas","T","Z","Q","UV"/)

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

lbres = True
lbres@lbOrientation        = 0       ; orientation
lbres@lbLabelFontHeightF   = box_theight               ; label font height
lbres@lbLabelAlignment     = "InteriorEdges"     ; where to label
lbres@lbMonoFillPattern    = True                ; fill sold
lbres@lbLabelFont          = 25
lbres@vpWidthF             = 0.27 ;0.05 
lbres@vpHeightF            = 0.03
lbres@lbLabelFont          = 21

Drivern = (/"Mean error","Anomaly amplitude error","Anomaly similarity error"/)
tres = True
tres@txJust = "CenterLeft"
tres@txAngleF = "0"
tres@txFontHeightF = model_theight*1.2
tres@txFont = 22

gsn_text_ndc(wks,"Primary source of nDEI2 with its relative contribution:   " \
  ,0.1, 0.43,tres)

tres@txFontHeightF = model_theight*2

gsn_text_ndc(wks,"b" \
  ,0.08, 0.97,tres)

tres@txJust = "CenterRight"
tres@txFont = 21
tres@txFontHeightF = model_theight*1.2

ybox = 0.41-box_height*0.7*ybox0
tres@txJust = "CenterCenter"
do i = 0,2
  if (i.eq.0) then
     xbox = 0.11+0.25*i+xbox0*box_width*2.5
  else
    xbox = max(xbox) + 0.03 + xbox0*box_width*6
  end if
    
  fres@gsFillColor = GetFillColor(levs, cmap(i,:,:), 80)
  gsn_polygon_ndc(wks, xbox, ybox, fres) 

  itx = (min(xbox)+max(xbox))/2.
  ity = (min(ybox)+max(ybox))/2.
  
  gsn_text_ndc(wks, Drivern(i), itx, ity, tres)
  lbres@lbFillColors         := cmap(i,2:,:)
end do


;drawNDCGrid(wks)
draw(wks)  
frame(wks)


  


;*******************************************************
end