load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
	imgname = "fnl_20100903_18-700map"

	wks_type = "png"
	wks_type@wkWidth = 800
	wks_type@wkHeight = 600

;;imgname   
;;wkWidth
;;wkHeight
   
   wks = gsn_open_wks(wks_type,imgname)
   gsn_define_colormap(wks,"amwg");"WhBlGrYeRe");"WhViBlGrYeOrRe")
   cmap = gsn_retrieve_colormap(wks)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;add file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      diri = "./"
      fili = "changjiang.txt"
      nlvl = 270  
      ncol = 2
     TestData = asciiread (diri+fili , (/nlvl,ncol/), "float")  
      x = TestData (:,0)
      y = TestData (:,1)
      hfili = "huanghe.txt"
      nlvl = 270  
      ncol = 2
     hTestData = asciiread (diri+hfili , (/nlvl,ncol/), "float")  
      hx = hTestData (:,0)
      hy = hTestData (:,1)

	fnlname = "fnldata/2011/fnl_20110624_00_00_c.grb";
;;fnlname
   a = addfile(fnlname,"r")

;A = new((/48/),integer)
;do i=0,23
; A(i) = i
;end do
; do i=22,22
;   t = a->TMP_3_ISBL_10(A(i),:,:) 
;   t=t-273                   
   u = a->U_GRD_3_HTGL_10 (:,:)  
   v = a->V_GRD_3_HTGL_10(:,:)  
   H = a->PRMSL_3_MSL_10(:,:)  
   ;wrf_smooth_2d( t, 5)  
   H=H/100
   wrf_smooth_2d( H, 5 )  
   Time=u@initial_time
   ;p=t@lv_ISBL3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;map
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  res = True
  res@vpXF            = 1  
  res@vpYF            = 1
  res@vpWidthF        = 1
  res@vpHeightF       = 1
  res@cnInfoLabelOn   = False   
  res@gsnLeftString   = ""
  res@gsnCenterString = ""
  res@gsnRightString  = ""
  res@tiXAxisString   = ""

 res@tfDoNDCOverlay=False;True

  res@mpDataBaseVersion="MediumRes"
  res@mpFillOn       = True
  ;res@mpDataSetName="Earth..4"
  res@mpOutlineSpecifiers=(/"China.states"/)
  res@mpSpecifiedFillColors = "White"
  res@mpOutlineOn           = True
  res@mpLandFillColor       = "White";"yellow green"
  res@mpInlandWaterFillColor = "light sky blue";"PaleTurquoise3"
  res@mpOceanFillColor       = "light sky blue";"PaleTurquoise3"
  res@mpGridAndLimbOn   = True   
  res@gsnMaximize = True             
  res@gsnAddCyclic = False   
  res@mpPerimOn         = True         
  res@mpGridLatSpacingF = 5           
  res@mpGridLonSpacingF = 5  
  ;res@mpGridLineDashPattern  = 2     
  res@mpGridLineThicknessF = 0.05
  res@mpGridLineColor = "brown"

  res@mpProjection        = "LambertConformal"
  res@mpMinLatF  = 20                
  res@mpMaxLatF  = 60                
  res@mpMinLonF = 70              
  res@mpMaxLonF = 130

;;mpProjection  
;;mpMinLatF
;;mpMaxLatF
;;mpMinLonF
;;mpMaxLonF

  res@mpLambertParallel1F =  30.0
  res@mpLambertParallel2F =  60.0
  res@mpLambertMeridianF  = 105

;;mpCenterLatF
;;mpCenterLonF
;;mpLambertMeridianF

  res@mpLimitMode       = "LatLon"
  
;  res@mpLeftCornerLatF  = -2
;  res@mpLeftCornerLonF  = 62
;  res@mpRightCornerLatF = 50
;  res@mpRightCornerLonF = 175
             
  res@tmXBLabelFontHeightF = 0.008
  res@tmXBMajorLengthF     = -0.001
  res@pmTickMarkDisplayMode = "Always" 
  res@gsnDraw=False
  res@gsnFrame=False



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; plot temp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;  plot Hight
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  hres=res 
  hres@cnLineColor = "blue"
  hres@cnLineThicknessF =2
  hres@cnLineDashSegLenF     = 0.18         
  hres@cnLineLabelInterval        = 2
  hres@cnLineLabelFontHeightF   = 0.010  
  hres@cnInfoLabelFontHeightF   = 0.008 
  hres@cnLineLabelPlacementMode   = "constant" 
  hres@lbLabelFontHeightF  = 0.010
  hres@cnLineLabelFontColor  = "blue"
  hres@cnHighLabelsOn = True
  hres@cnLowLabelsOn = True
  hres@cnHighLabelString="G $ZDV$"
  hres@cnLowLabelString="D $ZDV$"
  hres@cnLowLabelFontColor  = "red"
  hres@cnHighLabelFontColor  = "blue"
  hres@cnHighLabelBackgroundColor = -1
  hres@cnHighLabelFontHeightF   = 0.010  
  hres@cnMinLevelValF  = 975              
  hres@cnMaxLevelValF  =1050            
  hres@cnLevelSpacingF = 2.5 
       
  hight=  gsn_csm_contour(wks,H,hres)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ; plot Wind
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  wres=res
  wres@vcRefLengthF  = 0.026        
  wres@vcGlyphStyle  = "WindBarb" ;"CurlyVector"    
  wres@vcWindBarbTickLengthF  = 0.4              
  wres@vcWindBarbTickSpacingF  = 0.14 
  wres@vcRefMagnitudeF    = 4    
  wres@vcMinDistanceF   = 0.04

  wres@vcRefAnnoOn =  False 
  wres@vcRefAnnoOrthogonalPosF = -0.08
  wres@vcRefAnnoParallelPosF    =  0.09
  wres@vcRefAnnoFontHeightF     = 0.008

  u = u*2.5
  v = v*2.5
  wind=gsn_csm_vector(wks,u,v,wres)

  plot=gsn_csm_map(wks,res) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;  add luoyang
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      res@gsMarkerColor = "red"
      res@gsMarkerIndex = 1
      res@gsMarkerSizeF = 0.03
      map2= gsn_add_polymarker(wks,plot,112.47,34.63,res)
      lnres = True
      lnres@gsLineThicknessF = 3.0
   
      txres = True
      txres@txFont        = "helvetica-bold"
      txres@txFontColor   = "Blue"
      txres@txFontHeightF = 0.008
      txres@txJust        = "Topright"
      map1=gsn_add_text(wks,plot,"LY",112.47,34.63,txres)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; overlay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;overlay(plot,tem)
   overlay(plot,hight) 
   overlay(plot,wind)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;  plot changjiang and huanghe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   d=new(270*2,graphic)
   d=gsn_add_polyline(wks,plot,x,y,res)
   hd=new(270*2,graphic)
   hd=gsn_add_polyline(wks,plot,hx,hy,res)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; add text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   amres=True
   amres@txPerimOn             = True
   amres@txPerimColor          = "Black"
   amres@txPerimThicknessF     = 1.0
   amres@txPerimSpaceF         = 0.8
   amres@txFontHeightF   = 0.01
   amres@txFontColor =  "Blue"
   amres@txPerimOn     = True
   
   amres@txBackgroundFillColor = "White"
   
   Time = str_sub_str(Time,":",".");
   time_text = gsn_create_text(wks, "UTC "+ Time, amres) ;
   amres@amParallelPosF   = 0.5
   amres@amOrthogonalPosF = -0.5
   amres@amJust           = "TopRight"
   txt = gsn_add_annotation(plot,time_text,amres)


   mres=True
   mres@txPerimOn             = True
   mres@txPerimColor          = "Black"
   mres@txPerimThicknessF     = 1.0
   mres@txPerimSpaceF         = 0.8
   mres@txFontHeightF   = 0.01
   mres@txFontColor =  "Red"
   mres@txPerimOn     = True

   mres@txBackgroundFillColor = "White"

   lambert_text = gsn_create_text(wks," surface Pressure + 10m(wind)",mres)
   mres@amJust    = "TopRight"
   mres@amParallelPosF   = 0.5
   mres@amOrthogonalPosF = -0.45
   txt = gsn_add_annotation(plot,lambert_text,mres)

   draw(plot)
   frame(wks)

  

 end
