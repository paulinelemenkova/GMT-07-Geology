#!/bin/sh
# Purpose: geological map
# Area: Izu-Bonin Trench
# Mercator prj. GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
# FORMAT_GEO_MAP=dddF FORMAT_FLOAT_MAP
ps=Geol_IBT.ps
# GMT set up
gmt set
    FORMAT_DATE_MAP \
    MAP_DEGREE_SYMBOL degree \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.0c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,blue \
    MAP_GRID_PEN_SECONDARY thinnest,blue \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 8p,Times-Roman,dimgray \
    MAP_ANNOT_OBLIQUE \
    FONT_LABEL 8p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Extract a subset of GEBCO for the Izu-Bonin Trench area
grdcut GEBCO_2019.nc -R128/150/20/36 -Gibts_relief.nc
# grdcut earth_relief_01m.grd -R128/150/20/36 -Gibts_relief.nc

# Step-6. Make raster image
gmt grdimage ibts_relief.nc -Cterra -R128/150/20/36 \
    -JM16c -P -I+a15+ne0.75 -Xc -K > $ps

# Add elemens of basemap: title, grids, rose, scale, time stamp -Ba4f4g8
gmt psbasemap -R128/150/20/36 -JM16c -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3\
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -Lx13.0c/-3.0c+c50+w500k+f+l"Mercator cylindrical projection" \
    -O -K >> $ps
    
# Add bathymetric contours
gmt grdcontour ibts_relief.nc -R -J -C500 -W0.1p -U/-0.8c/-3c -O -K >> $ps

# Step-7. Add color legend
gmt psscale -Dg124.5/20+w13.0c/0.4c+v+o0.3/0i+ml -Ribts_relief.nc -J -Cterra \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
-Baf+l"Topographic color palette 'terra' for global bathymetry/topography relief [R=-7000/7000, H=0, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
# Add geological lines and points
#gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
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
# Step-8. Add earthquake points
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.05 -h3 -Scc -Cquakes.cpt -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Wthinnest,black -Gorange -O -K >> $ps

# texts
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,white+jLB >> $ps << EOF
146.0 33.8 PACIFIC PLATE
131.5 23.1 PHILIPPINE SEA PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
130 35.5 SEA OF JAPAN
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@20 >> $ps << EOF
130 32.5 KYUSHU
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-254 >> $ps << EOF
144.2 27.5 I  z  u - B  o  n  i  n
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB+a-265 >> $ps << EOF
142.8 31.9 T  r  e  n  c  h
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB -Gwhite@20 >> $ps << EOF
142.3 35.0 Boso Triple Junction
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-300 -Gwhite@20 >> $ps << EOF
131.4 28.5 Nankai
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Times−Bold,blue+jLB+a-317 -Gwhite@20 >> $ps << EOF
133.2 30.7 Trough
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Times−Bold,blue+jLB+a-340 -Gwhite@20 >> $ps << EOF
135 32.0 Suruga
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-325 -Gwhite@20 >> $ps << EOF
137.2 32.8 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-20 -Gwhite@20 >> $ps << EOF
139.7 34.3 Sagami
139.7 33.8 Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-80 -Gwhite@20 >> $ps << EOF
141.8 28.7 Bonin Ridge
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
-F+f8p,Palatino-Roman,black+jLB+a-80 -Gwhite@30 >> $ps << EOF
140.3 33.0 I  Z  U - B  O  N  I  N   V  O  L  C  A  N  I  C   A  R  C
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB+a-75 -Gwhite@20 >> $ps << EOF
138.3 28.8 Ogasawara Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Times−Bold,blue+jLB -Gwhite@20 >> $ps << EOF
145.0 25.4 Ogasawara Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f8p,Palatino-Roman,black+jLB -Gwhite@20 >> $ps << EOF
136.0 24.0 SHIKOKU BASIN
EOF

# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Gkhaki1@30 -W1.0p -O -K << EOF >> $ps
147.3 35.5 170 1.8c
146 32.5 190 1.8c
138.2 31.2 155 1.8c
EOF
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,midnightblue+jLB -Gwhite@30 >> $ps << EOF
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
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.5c v 0.8c khaki1 0.02c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,sienna2 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaly lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow 0.01c 1.0c Magnetic lineation peaks
S 0.3c c 0.2c orange 0.01c 1.0c Ophiolites
S 0.3c c 0.2c blue 0.01c 0.5c Earthquake depth >300km
S 0.3c c 0.2c green 0.01c 0.5c Earthquake depth 100-300km
S 0.3c c 0.2c red 0.01c 0.5c Earthquake depth <100km
FIN

# Add GMT logo
#gmt logo -Dx6.3/-2.2+o0.3c/-9.8c+w2c -O >> $ps
# Step-11. Add GMT logo
gmt logo -Dx6.5/-3.8+o0.1i/0.1i+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_IBT.ps -A1.5c -E720 -Tj -P -Z
