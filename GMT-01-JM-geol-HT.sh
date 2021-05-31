#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: Aegean Sea, Hellenic Trench)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

#grdcut GEBCO_2019.nc -R19/37/30.5/41.5 -Ght_relief.nc
#grdcut GEBCO_2019.nc -R19/31/32/39 -Ght_relief.nc
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R19/37/30.5/41.5 -Ght_relief.nc

gdalinfo ht_relief.nc -stats
#  Minimum=-5119.000, Maximum=3505.000
# Make color palette
# makecpt --help
gmt makecpt -Cglobe.cpt -V -T-5119/3505 > myocean.cpt

# Generate a file
ps=Geol_HT.ps
# Make raster image
gmt grdimage ht_relief.nc -Cmyocean.cpt -R19/37/30.5/41.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx4f1a2 -Bpyg4f1a2 -Bsxg2 -Bsyg2 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Topographic map of the Eastern Mediterranean Sea with tectonic and geological setting" -O -K >> $ps
    
# Add shorelines
gmt grdcontour ht_relief.nc -R -J -C1000 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Lx13.0c/-2.5c+c50+w400k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-70p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -W0.1p -Df -O -K >> $ps

# Add legend
gmt psscale -Dg16.0/30.5+w11.4c/0.4c+v+o0.3/0i+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=6p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Colors for global bathymetry/topography relief [R=-5119/3505, H=0, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.3c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J SC_hellas.txt -Wthick,purple -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthickest,green -O -K >> $ps
gmt psxy -R -J PB2002_boundaries.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gpurple -O -K >> $ps
gmt psxy -R -J TP_Eurasian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_African.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Arabian.txt -L -Wthickest,red -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sd0.4/2/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
21.0 31.5 AFRICAN PLATE
20.5 40.5 EURASIAN PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
31.0 39.2 ANATOLIAN PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-290 -Gwhite@20 >> $ps << EOF
35.0 31.5 ISRAEL
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,yellow+jLB >> $ps << EOF
22.2 33.5 M  E  D  I  T  E  R  R  A  N  E  A  N   S  E  A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
24.1 39.0 A E G E A N
24.7 38.5 PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
27.0 40.6 Sea of Marmara
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
24.5 35.1 Crete
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
21.4 37.8 Peloponnese
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-335 -Gwhite@30 >> $ps << EOF
32.8 34.9 Cyprus
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,white+jLB+a-45 >> $ps << EOF
21.0 36.5 H e l l e n i c  T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,white+jLB+a-338 >> $ps << EOF
25.0 33.9 Pliny Trench
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,white+jLB+a-333 >> $ps << EOF
26.2 33.9 Strabo Trench
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,white+jLB+a-8 >> $ps << EOF
31.5 34.3 Cyprean
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,white+jLB+a-350 >> $ps << EOF
32.8 34.2 Arc
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB+a-30 -Gwhite@30 >> $ps << EOF
23.5 38.8 Evia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
29.2 41.25 Black Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
25.5 36.5 Santorini
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
27.5 36.5 Rhodes
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
24.2 36.1 Cretan
24.4 35.6 Sea
EOF

# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Ggreen@30 -W1.0p -O -K << EOF >> $ps
20.3 34.5 45 1.5c
26 38.5 230 1.5c #Ag
35.0 38.2 210 1.5c # Tr
26.3 32.5 80 1.5c # Af
36.2 31.0 88 1.5c # Ab
EOF
gmt pstext -R -J -N -O -K \
    -F+f9p,0,midnightblue+jLB -Gwhite@50 >> $ps << EOF
34.8 30.5 20 mm/yr (Ab)
26.5 32.5 2.15 mm/yr (Af)
20.5 34.1 2.15 mm/yr (Af)
26.2 38.5 37 mm/yr (Ag)
EOF

# Add legend
gmt pslegend -R -J -Dx0.5/-1.4+w17.0c+o-1.5/0.0c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 6
S 0.3c f+l+t 0.7c darkred 0.01c 1.0c trench
S 0.3c - 0.8c - 0.5p,purple 1.0c slabs
S 0.3c - 0.8c - 1.0p,red 1.0c plates
S 0.3c v 0.8c green 0.01c 1.0c movements
S 0.3c c 0.15c magenta 0.01c 1.0c ophiolites
S 0.3c t 0.2c red 0.01c 1.0c volcanoes
FIN

# Add GMT logo
gmt logo -Dx6.2/-3.2+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.8 9.7 Topographic grid: GEBCO 15 arc sec resolution global terrain model
EOF

# Convert to image file using GhostScript
gmt psconvert Geol_HT.ps -A0.5c -E720 -Tj -Z
