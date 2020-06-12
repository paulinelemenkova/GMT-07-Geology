#!/bin/sh
# Purpose: Map of geological settings (here: Arabian Sea).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert

# Step-1. GMT set up
gmt set FORMAT_GEO_MAP=ddd \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1c \
    MAP_ANNOT_OFFSET 0.2c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_SECONDARY thinnest,dimgray \
    FONT_TITLE 14p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 10p,Helvetica,black \
    FONT_LABEL 10p,Helvetica,black \
    
# Step-2. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Step-4. Cut off the relief map from ETOPO5
#grdcut ETOPO1_Ice_g_gmt4.grd -R47/77/0/31 -Garab_relief.nc
grdcut GEBCO_2019.nc -R47/77/0/31 -Garab_relief.nc
gmt grdinfo @arab_relief.nc

# Step-5. Add coastlines; color areas: land-green water-blue
#gmt pscoast -R20/120/-65/30 -JQ5.0i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Step-5. Make color palette
#gmt makecpt -dem3.cpt -V -T-7898/8271 > myocean.cpt
gmt makecpt -dem2.cpt -V -T-5760/4357 > myocean.cpt
#gmt makecpt --help
# Step-6. Make raster image

# Step-3. Generate a file
ps=GMT_geol_AS.ps
# gmt grdimage GEBCO_2019.nc -Cmyocean.cpt -R120/134/-80/-40 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage arab_relief.nc -Cmyocean.cpt -R47/77/0/31 -JT62/15/6i -P -I+a15+ne0.75 -Xc -K > $ps
    
# Step-6. Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx12.6c/14.0c+w0.3i+f2+l+o0.15i \
    -Lx12.5c/-3.8c+c50+w800k+l"Transverse Mercator projection. Scale: km"+f \
    -UBL/5p/-110p -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg2.5 -Bsyg2.5 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Geologic and seismic setting and focal mechanisms" -O -K >> $ps

# legend
gmt psscale -Dg47/-2.5+w15.0c/0.4c+h+o0.3/0i+ml -R47/77/0/31 -J -Cmyocean.cpt \
    --FONT_LABEL=7p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale dem2: DEM scale by Dewez/Wessel [R=-5760/4357, C=RGB]" \
    -I0.2 -By+lmGal -O -K >> $ps
    
# Step-7. Add bathymetric contours
gmt grdcontour @arab_relief.nc -R -J -C2000 -W0.1p -O -K >> $ps
    
# Step-9. Add geological lines and points
#gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,purple -Gpurple -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
# tectonic slab contours
gmt psxy -R -J SC_hindu1.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_hindu2.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_assam.txt -Wthinner,blue -O -K >> $ps
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
#gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,red -Gyellow -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Indian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Eurasian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Arabian.txt -L -Wthickest,red -O -K >> $ps
#
gmt psmeca -R CMT.txt -J -Sd0.4/10/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/8/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/8/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,blue+jLB >> $ps << EOF
63.0 20.8 Oman
62.0 20.3 Abyssal Plain
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,yellow+jLB+a-290 >> $ps << EOF
60.0 17.0 Owen
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,yellow+jLB+a-300 >> $ps << EOF
60.7 18.8 Fracture
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,yellow+jLB+a-315 >> $ps << EOF
62.0 21.0 Zone
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,blue+jLB >> $ps << EOF
60.0 22.8 Gulf of
60.1 22.3 Oman
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
59.0 23.5 Makran Trench
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-335 -Gwhite@40 >> $ps << EOF
47.5 12.5 Gulf of Aden
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
59.0 12.5 Aden-Owen-Carlsberg Triple Junction
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-49 >> $ps << EOF
49.5 29.0 P e r s i a n  G u l f
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,gold+jLB -Gdimgray@30>> $ps << EOF
48.0 20.0 ARABIAN PLATE
64.9 10.5 INDIAN PLATE
54.0 28.0 EURASIAN PLATE
55.0 2.5 SOMALI PLATE
EOF
#gmt pstext -R -J -N -O -K \
#-F+jTL+f9p,Times−Bold,black+jLB+a-325 -Gwhite@40>> $ps << EOF
#63.3 22.1 Murray Ridge
#EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
56.5 21.5 OMAN
60.5 26.0 P A K I S T A N
52.5 30.2 I R A N
74.0 22.0 I N D I A
49.0 22.0 SAUDI
49.0 21.3 ARABIA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,white+jLB >> $ps << EOF
61.0 15.5 ARABIAN
62.2 14.0 SEA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB+a-300 -Gwhite@50 >> $ps << EOF
48.0 6.0 S O M A L I
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,red+jLB+a-270 -Gwhite@60 >> $ps << EOF
74.0 2.0 M  a  l  d  i  v  e  s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@50 >> $ps << EOF
53.0 11.5 Socotra
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,black+jLB+a-333 -Gwhite@50 >> $ps << EOF
48.5 15.1 Y E M E N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-40 -Gwhite@60 >> $ps << EOF
58.8 6.8 C a r l s b e r g  R i d g e
EOF

# Add legend -3.0
gmt pslegend -R -J -Dx2.0/-3.2+w14.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 1.2c - 0.5p,pink 1.0c Faults on seafloor fabric
S 0.3c - 1.2c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,blue 1.0c Tectonic slab (Assam)
S 0.3c - 1.2c - 0.5p,purple 1.0c Tectonic slab (Indonesia)
S 0.3c - 0.8c - 1.0p,red 1.0c Ridge
S 0.3c f+l+t 0.7c purple 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Step-19. Add GMT logo
gmt logo -Dx6.2/-4.5+o0.1i/0.1i+w2c -O -K >> $ps

# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.5 15.1 GEBCO 15 arc-sec grid. Focal mechanisms dataset: Global CMT Catalog.
1.7 14.6 Transverse Mercator prj. Central meridian: 62\232E Standard parallel: 15\232N
EOF

# Step-20. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_geol_AS.ps -A2.0c -E720 -Tj -P -Z
