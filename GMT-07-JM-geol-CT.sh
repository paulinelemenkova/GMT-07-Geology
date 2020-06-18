#!/bin/sh
# Purpose: shaded relief grid raster map from the ETOPO1 from 1 arc minute global data set (here: Cascadia Trench)
# GMT modules: gmtset, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

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
FONT_LABEL=7p,Helvetica,dimgray \

# Make raster image
#grdcut GEBCO_2019.nc -R224/240/35/55 -Gct_relief.nc
grdcut ETOPO1_Ice_g_gmt4.grd -R224/240/35/55 -Gct_relief.nc
gdalinfo ct_relief.nc -stats
# Minimum=-6201.000, Maximum=4161.000

# Generate a file
ps=GMT_geol_CT.ps

# Make color palette
gmt makecpt -Cdavos.cpt -V -T-6201/4161 > myocean.cpt

# Make raster image
gmt grdimage ct_relief.nc -Cmyocean.cpt -R224/240/35/55 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpxg8f2a4 -Bpyg6f2a2 -Bsxg4 -Bsyg2 \
    --MAP_TITLE_OFFSET=1.0c \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,dimgray \
    --MAP_ANNOT_OFFSET=0.1c \
    -B+t"Geologic settings of the Cascadia Trench, west Canada" -O -K >> $ps
    
# Add legend
gmt psscale -Dg217/35+w15.0c/0.4c+h+o6.8/-1.5c+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=5p,Helvetica,dimgray \
    -Baf+l"Color scale: davos (Perceptually uniform colormap by F. Crameri [C=RGB -6201/4161])" \
    -I0.2 -By+lm -O -K >> $ps

#Add geological lines and points
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Pacific.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Juan.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_North_Am.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J transform.gmt -Sc0.05c -Ggreen -Wthick,green -O -K >> $ps
#
gmt psmeca -R CMT.txt -J -Sd0.4/2/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Texts
# 224
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-43 -Gwhite@40 >> $ps << EOF
233 50.2 Vancouver Island
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,white+jLB >> $ps << EOF
224.5 36.1 P A C I F I C
224.5 35.5 O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,gold+jLB -Gdimgray@30>> $ps << EOF
225.0 50.5 PACIFIC PLATE
231.6 46.7 JUAN
231.6 46.0 DE FUCA
231.6 45.3 PLATE
233.0 52.0 NORTH AMERICAN PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
233 53.0 British Columbia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
237 45.0 Oregon
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times−Bold,red+jLB+a-49 -Gwhite@40 >> $ps << EOF
231 49.8 C a s c a d i a
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times−Bold,red+jLB+a-85 -Gwhite@40 >> $ps << EOF
234.2 46.0 T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-289 -Gwhite@40 >> $ps << EOF
230.3 45.0 Juan de Fuca Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-28 -Gwhite@40 >> $ps << EOF
230 43.8 Bianco Fracture Zone
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
229 42.1 Tufts Abyssal
229 41.6 Plain
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB+a-280 -Gwhite@40 >> $ps << EOF
232.2 41.0 Gorda Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
227.5 40.7 Mendocino Escarpment
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
225.5 38.8 Murray Fracture Zone
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times−Bold,black+jLB -Gwhite@40 >> $ps << EOF
238 42.1 California
EOF

# Add shorelines
gmt grdcontour ct_relief.nc -R -J -C2000 -A1000 -Wthinnest,white -O -K >> $ps

# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,dimgray \
    --MAP_TITLE_OFFSET=0.3c \
    -Lx13.4c/-4.1c+c50+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/10p/-120p -O -K >> $ps
    
# Add GMT logo
gmt logo -Dx6.4/-4.8+o0.1i/0.1i+w2c -O -K >> $ps

# Add legend -3.0
gmt pslegend -R -J -Dx1.0/-3.5+w14.0c+o0/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 0.9c - 0.5p,pink 1.0c Faults on seafloor fabric
S 0.3c - 0.9c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,red 1.0c Ridge
S 0.3c - 0.9c - 1.0p,red 1.0c Tectonic plate boundary
S 0.3c - 0.9c - 1.0p,green 1.0c Transform fault
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/14 -X0.5c -Y7.1c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 22.5 ETOPO1 global terrain model, 1 arc min resolution grid
EOF

# Convert to image file using GhostScript
gmt psconvert GMT_geol_CT.ps -A2.5c -E720 -Tj -Z
