#!/bin/sh
# Purpose: geological map
# Area: Vanuatu and Vityaz trenches
# Mercator prj. GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=Geol_VVT.ps
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.0c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,white \
    MAP_GRID_PEN_SECONDARY thinnest,white \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 8p,Helvetica,dimgray \
    FONT_LABEL 8p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Extract a subset of GEBCO for the Vanuatu and Vityaz trenches area
grdcut GEBCO_2019.nc -R162.5/191.5/-24/-6 -Gvvt_relief.nc
#grdcut earth_relief_01m.grd -R162.5/191.5/-24/-6 -Gvvt_relief.nc
# Step-6. Make raster image
gmt makecpt -Cabyss.cpt -V -T-8500/1000 > earthvv.cpt
gmt grdimage vvt_relief.nc -Cearthvv.cpt -R162.5/191.5/-24/-6 -JM16c -P -I+a15+ne0.75 -Xc -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological setting of the Vanuatu (New Hebrides) and Vityaz trenches" \
    -Bpxg10f2.5a5 -Bpyg5f2.5a5 -Bsxg5 -Bsyg5 \
    -Lx13.0c/-3.0c+c50+w600k+l"Behrman cylindrical projection. Scale (km)"+f \
    -UBL/-0.2c/-3.0c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour vvt_relief.nc -R -J -C1000 -W0.1p -O -K >> $ps
# Step-7. Add color legend
gmt psscale -Dg158.0/-24+w10.3c/0.4c+v+o0.3/0i+ml -Rvvt_relief.nc -J -Cearthvv.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
-Baf+l"Color palette: abyss, black/dark blue to lightblue for bathymetry [R=-8000/0, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,yellow -Ggreen -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,magenta -Gmagenta -O -K >> $ps
gmt psxy -R -J LIPS.2001.points.gmt -Sc0.1c -Gyellow -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,violet -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,orange -O -K >> $ps
# Add slab contours
#gmt makecpt -Cplasma -T0/700/50 -Z > rain.cpt
gmt psxy -R -J SC_nbritain.txt -W0.6p,yellow1,- -O -K >> $ps
gmt psxy -R -J SC_vanuatu.txt -W0.6p,yellow2,- -O -K >> $ps
#gmt psxy -R -J SC_vanuatu.txt -Sp1p -Crain.cpt -W -O -K >> $ps
gmt psxy -R -J SC_tonga.txt -W0.6p,yellow3,- -O -K >> $ps
#gmt psxy -R -J SC_tonga.txt -Sp1p -Crain.cpt -W -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Pacific.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Australian.txt -L -Wthickest,red -O -K >> $ps
# Add magnetic lineation picks
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthinnest,yellow -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Wthinnest,black -Gorange -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,gold+jLB -Gdimgray@30>> $ps << EOF
174.0 -8.0 PACIFIC PLATE
163.2 -23.0 INDO-
163.2 -23.6 AUSTRALIAN PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,white+jLB+a-291 >> $ps << EOF
186.0 -23.8 Tonga Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,blue+jLB+a-32 -Gwhite@30>> $ps << EOF
170 -9.5 Vityaz Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,blue+jLB+a-74 -Gwhite@40 >> $ps << EOF
166.5 -12.5 Vanuatu (New Hebrides) Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Times-Roman,gold+jLB -Gdimgray@30 >> $ps << EOF
177.8 -17.3 FIJI
189.0 -13.8 SAMOA
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,black+jLB -Gwhite@30 >> $ps << EOF
170.5 -17.0 North Fiji
171.0 -17.8 Basin
182 -18.0 Lau Basin
178 -23.6 South Fiji Basin
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Helvetica−Bold,black+jLB+a-340 -Gwhite@30 >> $ps << EOF
174.0 -22.5 Hunter
174.0 -23.0 Fracture Zone
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Helvetica−Bold,black+jLB -Gwhite@30 >> $ps << EOF
162.7 -12.0 Santa Cruz
162.7 -12.5 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Helvetica−Bold,black+jLB -Gwhite@30 >> $ps << EOF
165 -17.1 North
165 -17.6 Loyalty
165 -18.1 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Helvetica−Bold,black+jLB -Gwhite@30 >> $ps << EOF
162.8 -13.3 West
162.8 -13.8 Torres
162.8 -14.3 Massif
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica−Bold,black+jLB+a-71 -Gwhite@35 >> $ps << EOF
169 -17.5 Coriolis Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica−Bold,black+jLB+a-41 -Gwhite@35 >> $ps << EOF
163 -20.5 New Caledonia
164.0 -19.5 Loyalty Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Times-Roman,black+jLB+a-348 -Gwhite@30 >> $ps << EOF
163.0 -15.5 D'Entrecasteaux
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Helvetica−Bold,black+jLB+a-348 -Gwhite@30 >> $ps << EOF
179.0 -15.0 Fiji Fracture Zone
EOF
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.4c+bt+ea -Gred@20 -W1.0p,black -O -K >> $ps << EOF
164.0 -14.2 30 0.8c
164.5 -16.6 30 0.8c
166.0 -20 30 0.8c
EOF
gmt psxy -R -J -Sv0.4c+bt+ea -Gred@20 -W1.0p,red -O -K >> $ps << EOF
168.0 -22.8 60 0.8c
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Helvetica,red+jLB >> $ps << EOF
164.0 -14.6 12
164.5 -16.5 9
166.1 -20.2 12
168.5 -22.9 4.8
EOF
# Add legend
gmt pslegend -R -J -Dx0.5/-2.3+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Hadal trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c magenta 0.01c 1.0c Transform lines
S 0.3c t 0.3c red 0.01c 1.0c Volcanoes
S 0.5c v 0.8c red 0.02c 1.0c Plate movements, cm/yr
S 0.3c - 0.8c - 1.0p,violet 1.0c Fracture zones
S 0.3c - 0.8c - 1.0p,red 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 1.0p,orange 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,yellow,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow@90 0.01c,yellow 1.0c Magnetic lineation picks
S 0.3c c 0.2c orange 0.01c 1.0c Ophiolites
S 0.3c r 0.7c pink1@50 0.01c 1.0c Large igneous provinces
FIN
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y4.3c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 10.0 Base map: GEBCO bathymetric 15 arc sec grid dataset
EOF
# Add GMT logo
gmt logo -Dx6.3/-1.2+o0.3c/-6.5c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_VVT.ps -A1.2c -E720 -Tj -P -Z
