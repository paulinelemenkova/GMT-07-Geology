#!/bin/sh
# Purpose: Map of geological settings (here: New Britain - San Cristobal trenches).
# Mercator prj. GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=Geol_YPT.ps
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.0c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thin,white \
    MAP_GRID_PEN_SECONDARY thinner,white \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 8p,Helvetica,dimgray \
    FONT_LABEL 8p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Extract a subset of SRTM for the Yap and Palau trenches area
#grdcut topo15.grd -R116/145/-6/20 -Gypt_relief.nc
# Cut off the relief map from SRTM
gmt grdimage topo15.grd -Cterra.cpt -R116/145/-6/20 -JY30/7/16c -P -I+a15+ne0.75 -Xc -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological and tectonic setting of the Yap and Palau trenches" \
    -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3 \
    -Lx13.0c/-2.8c+c50+w500k+l"Behrman cylindrical projection. Scale (km)"+f \
    -UBL/-0.2c/-2.9c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour ypt_relief.nc -R -J -C2000 -W0.1p -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J volcanoes.gmt -St0.3c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,green -Ggreen -O -K >> $ps
#gmt psxy -R -J LIPS.2011.gmt -L -G0.1c+bred+f-+r300 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2001.points.gmt -Sc0.2c -Gyellow -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,olivedrab1 -Golivedrab1 -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,violet -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,orange -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_marjapkur.txt -W0.6p,red,- -O -K >> $ps
gmt psxy -R -J SC_wphilippines.txt -W0.6p,red,- -O -K >> $ps
gmt psxy -R -J SC_luzon.txt -W0.6p,red,- -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Philippine_Sea.txt -L -Wthickest,sienna2 -O -K >> $ps
gmt psxy -R -J TP_Pacific.txt -L -Wthickest,sienna2 -O -K >> $ps
# Add magnetic lineation picks
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthinnest,yellow -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Wthinnest,magenta -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@30 >> $ps << EOF
116.5 1.5 KALIMANTAN
119 -2.0 SULAWESI
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,black+jLB -Gwhite@20 >> $ps << EOF
137.3 3 West Caroline
137.3 2.4 Basin
126.0 15.0 West Philippine
126.0 14.4 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,black+jLB+a-350 -Gwhite@20 >> $ps << EOF
136.0 5.5 West Caroline Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,black+jLB+a-290 -Gwhite@20 >> $ps << EOF
139.2 11.9 Parece Vela Rift
142.1 3.2 Eauripik Rise
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB+a-30 -Gwhite@20>> $ps << EOF
139.9 10 Caroline Islands Ridge
139.9 9.1 Caroline Ridge
140.0 8.5 Sorol Trough
139.7 8.0 West Caroline Rise
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,black+jLB+a-280 -Gwhite@20 >> $ps << EOF
132.8 1.0 Ayu Trough
133.4 6.3 Kyushu Palau Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
128.5 13.5 PHILIPPINE SEA PLATE
140 10.0 PACIFIC PLATE
135 1.5 CAROLINE PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jBL+a-70 -Gwhite@30 >> $ps << EOF
126.5 13.0 Philippine Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jBL+a-350 -Gwhite@30 >> $ps << EOF
141 12.0 Mariana Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
120.5 3.5 CELEBES SEA
118.5 8 SULU SEA
117 17 SOUTH
117 16.4 CHINA
117 15.8 SEA
127 -5 BANDA SEA
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jLB+a-308 -Gwhite@30 >> $ps << EOF
137.7 6.8 Yap Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Palatino-Roman,red+jLB+a-310 -Gwhite@30 >> $ps << EOF
133.5 4.5 Palau Trench
EOF
# Step-7. Add color legend
gmt psscale -Dg111.5/-6+w14.2c/0.4c+v+o0.3/0i+ml -Rypt_relief.nc -J -Cterra.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Topographic color scale" \
    -I0.2 -By+lm -O -K >> $ps
# Add legend
gmt pslegend -R -J -Dx0.5/-2.2+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Hadal trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c olivedrab1 0.01c 1.0c Transform lines
S 0.3c t 0.2c red 0.01c 1.0c Volcanoes
S 0.3c v 0.8c red 0.02c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,sienna2 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow 0.01c 1.0c Magnetic lineation picks
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous provinces
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
FIN
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y8.5c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 10.0 Base map: SRTM Global Relief Model 15 arc sec grid. Color palette: Smith topography scale 'sealand'
EOF
# Add GMT logo
gmt logo -Dx6.5/-2.2+o0.3c/-9.5c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_YPT.ps -A1.0c -E720 -Tj -P -Z
