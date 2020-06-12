#!/bin/sh
# Purpose: geological map
# Area: Japan Trench
# Mercator prj. GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=Geol_JT.ps
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.0c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,blue \
    MAP_GRID_PEN_SECONDARY thinnest,blue \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 8p,Helvetica,dimgray \
    FONT_LABEL 8p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Extract a subset of GEBCO for the Japan trench area
gmt grdimage GEBCO_2019.nc -Cgebco.cpt -R128/150/30/46 \
    -JY139/37/16c -P -I+a15+ne0.75 -Xc -K > $ps
#gmt grdimage earth_relief_01m.grd -Cgebco.cpt -R128/150/30/46 \
#    -JY139/37/16c -P -I+a15+ne0.75 -Xc -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological and tectonic settings of the Japan Trench" \
    -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3 \
    -Lx13.0c/-3.0c+c50+w500k+l"Behrman cylindrical projection. Scale (km)"+f \
    -UBL/-0.2c/-3.0c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour jt_relief.nc -R -J -C500 -W0.1p -O -K >> $ps
# Step-7. Add color legend
gmt psscale -Dg124.5/30+w14.2c/0.4c+v+o0.3/0i+ml -Rjt_relief.nc -J -Cgebco.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
-Baf+l"Topographic color palette: GEBCO bathymetric charts [R=-7000/0, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,navyblue -Ggreen -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,darkgray -Gpurple -O -K >> $ps
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
#gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
# Step-8. Add earthquake points
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.05 -h3 -Scc -Cquakes.cpt -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Wthin,orange -Gorange -O -K >> $ps
# texts
gmt pstext -R -J -N -O -K \
-F+f10p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
133 40 SEA OF JAPAN
145.5 38 PACIFIC PLATE
134 30.1 PHILIPPINE SEA PLATE
130 45.2 EURASIAN PLATE
139.5 45.2 NORTH AMERICAN PLATE
143 44.2 (OKHOTSK MICROPLATE)
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@20 >> $ps << EOF
142 43.5 HOKKAIDO
130 32.5 KYUSHU
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB+a-320 -Gwhite@20 >> $ps << EOF
138 35.8 H O N S H U
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Times−Bold,blue+jLB+a-297 -Gwhite@30 >> $ps << EOF
143.1 35.5 J    a    p    a    n    .
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Times−Bold,blue+jLB+a-275 -Gwhite@30 >> $ps << EOF
144.7 38.0 T    r    e    n    c    h
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-330 -Gwhite@40 >> $ps << EOF
145.5 40.8 Kuril-Kamchatka Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB -Gwhite@40 >> $ps << EOF
142.3 35.0 Boso Triple Junction
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-265 -Gwhite@40 >> $ps << EOF
143 30.5 Izu-Bonin Trench
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Times−Bold,blue+jLB+a-317 -Gwhite@40 >> $ps << EOF
133.2 30.7 Nankai
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Times−Bold,blue+jLB+a-340 -Gwhite@40 >> $ps << EOF
135 32.0 Trough
EOF
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Gkhaki1@30 -W1.0p -O -K << EOF >> $ps
148 39.8 160 1.8c
147.3 35.5 170 1.8c
146 32.5 190 1.8c
138.2 31.2 155 1.8c
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,midnightblue+jLB -Gwhite@30 >> $ps << EOF
147.9 39.7 8 cm/yr
147.5 35.3 9 cm/yr
146.2 32.5 6 cm/yr
138.3 31.0 5 cm/yr
EOF
# Add legend
gmt pslegend -R -J -Dx0.5/-2.5+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Hadal trench
S 0.3c f+l+t 0.7c navyblue 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c purple 0.01c 1.0c Transform lines
S 0.3c t 0.2c red 0.01c 1.0c Volcanoes
S 0.5c v 0.8c khaki1 0.02c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,sienna2 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow 0.01c 1.0c Magnetic lineation picks
S 0.3c c 0.2c orange 0.01c 1.0c Ophiolites
S 0.3c c 0.2c blue 0.01c 0.5c Earthquake depth >300km
S 0.3c c 0.2c green 0.01c 0.5c Earthquake depth 100-300km
S 0.3c c 0.2c red 0.01c 0.5c Earthquake depth <100km
FIN
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y8.5c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 10.0 Base map: GEBCO bathymetric 15 arc sec grid dataset
EOF
# Add GMT logo
gmt logo -Dx6.5/-2.2+o0.3c/-9.8c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_JT.ps -A1.0c -E720 -Tj -P -Z
