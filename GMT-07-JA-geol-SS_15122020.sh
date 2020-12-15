#!/bin/sh
# Purpose: geologic map from the ETOPO1 from 1 arc minute global data set (here: Scotia Sea)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# Step-2. GMT set up
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

gmt grdcut ETOPO1_Ice_g_gmt4.grd -R270/371/-72/-44 -Gss_relief.nc
#grdcut GEBCO_2019.nc -R270/371/-72/-44 -Gss_relief.nc

gdalinfo ss_relief.nc -stats
# Make color palette
#makecpt --help
gmt makecpt -Cglobe.cpt -V -T-8239/6392 > myocean.cpt

# Generate a file
ps=GMT_geol_SS.ps
gmt grdimage ss_relief.nc -Cmyocean.cpt -R270/-65/340/-45r -JA318/-57/5.5i -P -I+a15+ne0.75 -Xc -K > $ps

# Add isolines
gmt grdcontour ss_relief.nc -R -J -C2000 -W0.1p -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f5a10 -Bpyg10f5a10 -Bsxg5 -Bsyg5 \
    --MAP_FRAME_AXES=wESN \
    --MAP_TITLE_OFFSET=1.5c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_LABEL=8p,Helvetica,black \
    --FONT_TITLE=12p,Helvetica,black \
    -Lx12.0c/-3.3c+c318/-55+w1000k+l"Scale (km) at 42\232W 57\232S"+f \
    -O -K >> $ps

#Add geological lines and points
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,purple -Gpurple -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
gmt psxy -R -J transform.gmt -Sc0.05c -Ggreen -Wthick,green -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Pacific.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Scotia.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Antarctic.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_South_Am.txt -L -Wthickest,red -O -K >> $ps
#
gmt psmeca -R CMT.txt -J -Sd0.4/2/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Helvetica,white+jLB >> $ps << EOF
307 -69.0 W E D D E L L
311 -71.5 S E A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,white+jLB >> $ps << EOF
308 -57.0 S C O T I A   S E A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
292 -69.0 Antarctic
291 -69.8 Peninsula
321.5 -52.5 South
321.5 -53.3 Georgia
EOF

#new
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
315 -61.3 South
315 -62.1 Orkney
315 -62.8 Islands
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-315 -Gwhite@40 >> $ps << EOF
302.0 -62.0 South
302.5 -62.8 Shetland
303.0 -63.6 Islands
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-340 -Gwhite@40 >> $ps << EOF
299.5 -54.0 Burdwood
299.5 -54.7 Bank
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-330 -Gwhite@40 >> $ps << EOF
305 -54.0 North
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-346 -Gwhite@40 >> $ps << EOF
310 -53.5 Scotia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-10 -Gwhite@40 >> $ps << EOF
315 -53.5 Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-333 -Gwhite@40 >> $ps << EOF
305 -60.5 South
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-10 -Gwhite@40 >> $ps << EOF
313 -59.7 Scotia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-332 -Gwhite@40 >> $ps << EOF
322 -60.5 Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-93 -Gwhite@40 >> $ps << EOF
328 -55.5 East Scotia Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-320 -Gwhite@40 >> $ps << EOF
298 -59.3 West Scotia Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-318 -Gwhite@40 >> $ps << EOF
290.0 -59.0 DRAKE PASSAGE
EOF
#

gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
318 -48.5 A T L A N T I C  O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-330 -Gwhite@40 >> $ps << EOF
279.5 -62.0 PACIFIC
279.5 -62.9 OCEAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-25 -Gwhite@40 >> $ps << EOF
287 -53.5 Chile
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,Helvetica,black+jLB+a-285 -Gwhite@40 >> $ps << EOF
289.5 -50.5 Argentina
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
300 -49.8 Falkland
300 -50.6 Islands
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
310 -58.5 SCOTIA PLATE
312 -50.5 SOUTH AMERICAN PLATE
292 -66.0 ANTARCTIC PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
330.5 -58.0 SOUTH
330.5 -59.0 SANDWICH
330.5 -60.0 PLATE
EOF

# Add legend -3.0
gmt pslegend -R -J -Dx1.5/-2.7+w14.0c+o-1.5/0.1c \
    --FONT=8p,black -O -K << FIN >> $ps
H 10 Helvetica Legend
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 0.9c - 0.5p,pink 1.0c Faults on seafloor fabric
S 0.3c - 0.9c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,red 1.0c Ridge
S 0.3c - 0.9c - 1.0p,red 1.0c Tectonic plate boundary
S 0.3c - 0.9c - 1.0p,green 1.0c Transform fault
S 0.3c f+l+t 0.7c purple 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add legend
gmt psscale -Dg268/-68+w10.0c/0.4c+v+o-7.0c/-5.3c+ml -R270/340/-65/-45 -J -Cmyocean.cpt \
    --FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -Bg1000f250a2000 \
    -I0.2 -By+lm -O >> $ps

# Convert to image file using GhostScript
gmt psconvert GMT_geol_SS.ps -A1.5c -E720 -Tj -Z
