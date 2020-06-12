#!/bin/sh
# Purpose: geological map
# Area: Philippine Sea Basin
# Mercator prj. GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=Geol_PSB.ps
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.5c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,blue \
    MAP_GRID_PEN_SECONDARY thinnest,blue \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 8p,Helvetica,dimgray \
    FONT_LABEL 8p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Extract a subset of GEBCO for the study area
grdcut GEBCO_2019.nc -R120/152/4/35 -Gpsb_relief.nc
#grdcut earth_relief_01m.grd -R120/152/4/35 -Gpsb_relief.nc
# Step-6. Make raster image
gmt grdimage psb_relief.nc -Cbathy.cpt -R120/152/4/35 -JM16c -P -I+a15+ne0.75 -Xc -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological and tectonic settings of the Philippine Sea Basin" \
    -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3 \
    -Lx13.0c/-3.0c+c50+w500k+l"Behrman cylindrical projection. Scale (km)"+f \
    -UBL/-0.2c/-3.0c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour psb_relief.nc -R -J -C500 -W0.1p -O -K >> $ps
# Step-7. Add color legend
gmt psscale -Dg114.0/4+w17.0c/0.4c+v+o0.3/0i+ml -Rpsb_relief.nc -J -Cbathy.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Topographic color palette: bathy [R=-8000/0, C=RGB], via aquamarine at mid-depths" \
    -I0.2 -By+lm -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.6c/0.2c+l+t -Wthinnest,navyblue -Ggreen -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,darkgray -Gpurple -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,yellowgreen -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,gold1 -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_marjapkur.txt -W0.6p,red,- -O -K >> $ps
gmt psxy -R -J SC_wphilippines.txt -W0.6p,red,- -O -K >> $ps
gmt psxy -R -J SC_luzon.txt -W0.6p,red,- -O -K >> $ps
gmt psxy -R -J SC_ryukyus.txt -Wthinner,brown -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Philippine_Sea.txt -L -W3p,red -O -K >> $ps
gmt psxy -R -J TP_Pacific.txt -L -W3p,red -O -K >> $ps
gmt psxy -R -J TP_Eurasian.txt -L -W3p,red -O -K >> $ps
# Add magnetic lineation picks
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthinnest,yellow -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
#gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
# Step-8. Add ophiolites
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Wthin,orange -Gorange -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f13p,Helvetica−Bold,gold+jLB -Gdimgray@30 >> $ps << EOF
145.0 30.8 PACIFIC PLATE
128.0 20.0 PHILIPPINE SEA PLATE
135.0 4.1 CAROLINE PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
123.5 31.5 EAST
123.5 30.7 CHINA
123.5 30.0 SEA
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@20 >> $ps << EOF
130 32.5 KYUSHU
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-262 >> $ps << EOF
144.2 27.5 I z u - B o n i n
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-265 >> $ps << EOF
145.0 27.5 T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB -Gwhite@40 >> $ps << EOF
142.3 34.0 Boso Triple Junction
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-300 -Gwhite@40 >> $ps << EOF
131.8 28.5 Nankai
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Times−Bold,blue+jLB+a-317 -Gwhite@40 >> $ps << EOF
133.2 30.7 Trough
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Times−Bold,blue+jLB+a-340 -Gwhite@40 >> $ps << EOF
135 32.0 Suruga
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-325 -Gwhite@40 >> $ps << EOF
137.2 32.8 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-20 -Gwhite@40 >> $ps << EOF
139.7 34.3 Sagami
139.7 33.8 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-80 -Gwhite@40 >> $ps << EOF
141.8 28.7 Bonin Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-66 >> $ps << EOF
125.6 15 Philippine
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-77 >> $ps << EOF
127.5 11 Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-326 >> $ps << EOF
126.1 22.8 R y u k y u
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-303 >> $ps << EOF
129.8 25.3 T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-44 >> $ps << EOF
144.6 23.7 Mariana
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-62 >> $ps << EOF
146.9 21.6 Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jBL+a-345 >> $ps << EOF
141 10.0 Mariana
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jBL+a-335 >> $ps << EOF
144.5 10.9 Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB+a-80 -Gwhite@30 >> $ps << EOF
140.3 33.0 I Z U - B O N I N  V O L C A N I C  A R C
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,white+jBL+a-305 >> $ps << EOF
137.7 6.8 Yap Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,white+jBL+a-310 >> $ps << EOF
134.0 4.2 Palau Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,black+jLB+a-350 -Gwhite@40 >> $ps << EOF
136.0 5.7 West Caroline Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-290 -Gwhite@40 >> $ps << EOF
139.2 11.9 Parece Vela Rift
142.1 4.8 Eauripik Rise
EOF
gmt pstext -R -J -N -O -K \
--F+f10p,Times−Bold,blue+jLB+a-280 -Gwhite@40 >> $ps << EOF
133.4 6.3 Kyushu Palau Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-75 -Gwhite@40 >> $ps << EOF
138.3 28.9 Ogasawara Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB -Gwhite@40 >> $ps << EOF
145.0 25.4 Ogasawara Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@40 >> $ps << EOF
134.0 23.0 SHIKOKU BASIN
EOF
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Ggreen -W1.0p -O -K << EOF >> $ps
147.3 35.5 170 1.2c
146 32.5 190 1.2c
138.2 31.2 155 1.2c
EOF
gmt pstext -R -J -N -O -K \
    -F+f9p,Helvetica,midnightblue+jLB -Gwhite@30 >> $ps << EOF
147.5 35.3 90 mm/yr
146.2 32.5 60 mm/yr
138.0 30.5 50 mm/yr
EOF
# 2. вектор: RYUKYU стрелки тонкие с желтым кружком в начале и острием в конце.
# kwargs: координаты, угол наклона, длина
gmt psxy -R -J -Sv0.5c+ea -Ggreen -W1.2p -O -K << EOF >> $ps
126.8 22.0 140 1.2c
131.0 23.5 140 1.2c
132.2 24.6 140 1.2c
134.4 28.6 140 1.2c
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Times-Roman,black+jLB -Gwhite@30>> $ps << EOF
126.7 21.7 71 mm/yr
130.5 23.1 67 mm/yr
132.0 24.2 62 mm/yr
134.3 28.2 57 mm/yr
EOF
# 8. звездочка // star.
# kwargs: координаты XY, диаметр
gmt psxy -R -J -Sa -W0.2p,black -Gmagenta -O -K << EOF >> $ps
127.8 27.1 0.3c
127.7 27.6 0.3c
127.6 28.1 0.3c
128.1 27.3 0.3c
128.2 27.7 0.3c
129.8 29.4 0.3c
130.0 29.7 0.3c
130.1 30.4 0.3c
122.2 25.1 0.3c
122.7 25.2 0.3c
123.7 25.3 0.3c
123.8 24.3 0.3c
124.2 25.1 0.3c
124.3 25.2 0.3c
EOF
# Add legend
gmt pslegend -R -J -Dx0.5/-2.5+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Hadal trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c purple 0.01c 1.0c Transform lines
S 0.3c t 0.2c red 0.01c 1.0c Volcanoes
S 0.5c v 0.8c khaki1 0.02c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.8c - 0.6p,red 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow 0.01c 1.0c Magnetic lineation picks
S 0.3c c 0.2c orange 0.01c 1.0c Ophiolites
S 0.3c a 0.3c magenta 0.02c 1.0c Hydrothermal area
FIN
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y7.2c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 15.5 Base map: GEBCO bathymetric 15 arc sec grid dataset
EOF
# Add GMT logo
gmt logo -Dx6.3/-1.2+o0.3c/-9.8c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_PSB.ps -A1.5c -E720 -Tj -P -Z
