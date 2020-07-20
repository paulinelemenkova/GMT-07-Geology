#!/bin/sh
# Purpose: Map of geological settings (here: Arabian Sea).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert

# GMT set up
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
    
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Cut off the relief map from ETOPO5
#grdcut ETOPO1_Ice_g_gmt4.grd -R47/77/0/31 -Garab_relief.nc
grdcut GEBCO_2019.nc -R47/77/0/31 -Garab_relief.nc
gmt grdinfo @arab_relief.nc

# Add coastlines; color areas: land-green water-blue
#gmt pscoast -R20/120/-65/30 -JQ5.0i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Step-5. Make color palette
#gmt makecpt -dem3.cpt -V -T-7898/8271 > myocean.cpt
gmt makecpt -dem2.cpt -V -T-5760/4357 > myocean.cpt
#gmt makecpt --help
# Make raster image

# Generate a file
ps=GMT_geol_AS.ps
# gmt grdimage GEBCO_2019.nc -Cmyocean.cpt -R120/134/-80/-40 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage arab_relief.nc -Cmyocean.cpt -R47/77/0/31 -JT62/15/6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid, title
gmt psbasemap -R -J \
    -Bpx104f5a5 -Bpyg10f5a5 -Bsxg2.5 -Bsyg2.5 \
    --MAP_TITLE_OFFSET=1.1c \
    --FONT_TITLE=14p,Palatino-Roman,black \
    --FONT_ANNOT_PRIMARY=9p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    -B+t"Geologic and seismic setting and focal mechanisms" -O -K >> $ps
        
# Add elemens of basemap: grids, rose, scale, time stamp
gmt psbasemap -R -J \
    --FONT_ANNOT_PRIMARY=9p,Helvetica,black \
    --FONT_LABEL=9p,Helvetica,black \
    --FONT_TITLE=9p,Helvetica,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Tdx12.6c/14.0c+w0.3i+f2+l+o0.15i \
    -Lx12.5c/-4.3c+c50+w1000k+l"Transverse Mercator projection. Scale: km"+f \
    -UBL/5p/-125p -O -K >> $ps

# legend
gmt psscale -Dg47/-2.9+w15.0c/0.4c+h+o0.3/0i+ml -R47/77/0/31 -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Baf+l"Color scale dem2: DEM scale by Dewez/Wessel [R=-5760/4357, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
# Add bathymetric contours
gmt grdcontour @arab_relief.nc -R -J -C2000 -W0.1p -O -K >> $ps
    
# Add geological lines and points
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
gmt psmeca -R CMT.txt -J -Sd0.4/1/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/1/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f1p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB >> $ps << EOF
63.2 20.8 Oman
63.2 20.2 Abyssal
63.2 19.6 Plain
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,yellow+jLB+a-290 >> $ps << EOF
60.6 16.8 Owen
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,yellow+jLB+a-300 >> $ps << EOF
61.3 18.8 Fracture
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,yellow+jLB+a-310 >> $ps << EOF
62.7 21.2 Zone
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB >> $ps << EOF
60.0 22.6 Gulf of
60.1 22.0 Oman
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,black+jLB -Gwhite@35 >> $ps << EOF
59.0 23.4 Makran Trench
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-335 -Gwhite@40 >> $ps << EOF
47.5 12.5 Gulf of Aden
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
59.0 12.5 Aden-Owen-Carlsberg
59.0 11.6 Triple Junction
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-53 >> $ps << EOF
49.5 29.0 P e r s i a n  G u l f
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
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
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
61.0 15.5 ARABIAN
62.2 14.0 SEA
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB+a-300 -Gwhite@50 >> $ps << EOF
48.0 6.0 S O M A L I
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,red+jLB+a-270 -Gwhite@60 >> $ps << EOF
74.0 2.0 M  a  l  d  i  v  e  s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,black+jLB -Gwhite@35 >> $ps << EOF
53.0 11.4 Socotra
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,black+jLB+a-333 -Gwhite@50 >> $ps << EOF
48.5 15.1 Y E M E N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-40 -Gwhite@35 >> $ps << EOF
58.8 6.7 C a r l s b e r g  R i d g e
EOF

# Add legend -3.0
gmt pslegend -R -J -Dx2.0/-3.7+w14.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=9p,Helvetica,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 1.2c - 0.5p,pink 1.0c Faults on seafloor fabric
S 0.3c - 1.2c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,blue 1.0c Tectonic slab (Assam)
S 0.3c - 1.2c - 0.5p,purple 1.0c Tectonic slab (Indonesia)
S 0.3c - 0.8c - 1.0p,red 1.0c Ridge
S 0.3c f+l+t 0.7c purple 0.01c 1.0c Trench
S 0.3c c 0.2c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add GMT logo
gmt logo -Dx6.2/-5.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f12p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 15.4 GEBCO 15 arc-sec grid. Focal mechanisms dataset: Global CMT Catalog
0.0 14.7 Transverse Mercator prj. Central meridian: 62\232E Standard parallel: 15\232N
EOF

#  Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_geol_AS.ps -A2.2c -E720 -Tj -P -Z
