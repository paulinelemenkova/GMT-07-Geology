#!/bin/sh
# Purpose: Map of geological settings (here: Kermadec-Tonga trenches).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=GMT_geol_KTT.ps
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 0.5c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_SECONDARY thinnest,dimgray \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 7p,Helvetica,dimgray \
    FONT_LABEL 7p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Cut off the relief map from ETOPO5
#gmt grdcut GEBCO_2019.nc -R177/193/-37/-13.5 -Gtkt_relief_GEBCO.nc -V
#gmt grdimage tkt_relief_GEBCO.nc -Cibcso -R177/193/-37/-13.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
#gmt grdimage earth_relief_01m.grd -Cibcso -R177/193/-37/-13.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage earth_relief_01m.grd -Crainbow -R177/193/-37/-13.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological and tectonic setting of the Kermadec and Tonga trenches" \
    -Bpxg4f2a4 -Bpyg4f2a4 -Bsxg4 -Bsyg4 \
    -Lx12.6c/-2.8c+c50+w400k+l"Mercator projection. Scale at 12\232N, km"+f \
    -UBL/-0.2c/-2.9c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour @tkt_relief.nc -R -J -C500 \
    -A1000+f7p,Times-Roman -S4 -T+d15p/3p \
    -W0.2p,white -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,black -Ggreen -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2001.points.gmt -Sc0.1c -Gyellow -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,magenta -Gmagenta -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,violet -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,orange -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_tonga.txt -W0.6p,red,- -O -K >> $ps
# Add magnetic lineation picks
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthin,purple -Gpurple -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
# Step-7. Add color legend
gmt psscale -Dg175/-37+w24.5c/0.4c+v+o0.3/0i+ml \
    -Rtkt_relief.nc -J -Crainbow.cpt \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Baf+l"Color scale legend: depth and height elevations (m)" \
    -I0.2 -By+lm -O -K >> $ps
# Add text
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB+a-290 -Gwhite@20>> $ps << EOF
182.5 -35 K e r m a d e c   T r e n c h
186.5 -23 T o n g a   T r e n c h
183.5 -22 Tofua Arc Volcanic Front
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
178 -24.0 South Fiji
178 -24.5 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB+a-60 -Gwhite@20 >> $ps << EOF
186.4 -30.8 Louisville Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
185.3 -26.0 Osborne
185.3 -26.3 Seamount
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
188.1 -18.2 Capricorne
188.1 -18.5 Seamount
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
190 -23.0 PACIFIC
190 -23.5 PLATE
179 -27.0 INDO-AUSTRALIAN
179 -27.5 PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
186 -30.0 KERMADEC
186 -30.5 PLATE
190.5 -19.0 TONGA
190.5 -19.5 PLATE
180.5 -21.0 CONWAY REEF
180.5 -21.5 MICROPLATE
184 -14.0 FUTUNA PLATE
189 -14.0 NIUAFO'OU PLATE
EOF
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.7c+bt+ea -Gred@20 -W2.0p -O -K >> $ps << EOF
189.0 -23 171 1.5c
185.5 -30 173 1.5c
190 -19.0 175 1.5c
182.0 -22 -30 1.5c
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,midnightblue+jLB >> $ps << EOF
189.5 -24.0 77 mm/yr
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
182 -19.0 Lau
182 -19.5 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
188 -15.0 Pago Pago
188 -15.5 American Samoa
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,black+jLB -Gwhite@20 >> $ps << EOF
178 -18.0 Fiji
EOF
# Add legend
gmt pslegend -R -J -Dx0.5/-2.2+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c t 0.2c red 0.01c 1.0c Volcanoes
S 0.3c v 0.8c red 0.02c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c purple 0.01c 1.0c Magnetic lineation picks
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous provinces
FIN
# Add subtitle
gmt pstext -R -J -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
266.5 17.7 Bathymetry: ETOPO 5 arc min Global Relief Model
EOF
# Add GMT logo
gmt logo -R -J -Dx5.0/0.0c+o1.6c/-3.4c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_geol_KTT.ps -A1.0c -E720 -Tj -P -Z
