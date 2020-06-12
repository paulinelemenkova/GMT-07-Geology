#!/bin/sh
# Purpose: Map of geological settings (here: Middle America Trench).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=GMT_JL_geol_MAT.ps
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
    FONT_LABEL 7p,Helvetica,dimgray \
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R263/278/7/17 -Gmat_relief.nc -V
# Add coastlines; color areas: land-green water-blue
gmt pscoast -R263/278/7/17 -JL270/12/10/14/6i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological and tectonic setting of the Guatemala Trench area" \
    -Bpxg4f2a2.5 -Bpyg2f1a2 -Bsxg4 -Bsyg4\
    -Lx12.6c/-2.8c+c50+w500k+l"Lambert conic conformal projection. Scale at 12\232N, km"+f \
    -O -K >> $ps
# Add directional rose
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,darkblue \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdg264/8+w0.5c+f2+l \
    -UBL/.6c/-2.8c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour @mat_relief.nc -R -J -C500 \
    -A2000+f7p,Times-Roman -S4 -T+d15p/3p \
    -W0.1p -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,darkred -Gdarkred -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.2c -Ggoldenrod1 -W0.08 -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.2c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,black -Ggreen -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,violet -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,orange -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_camerica.txt -W0.6p,bisque4,- -O -K >> $ps
# Add magnetic lineation picks (gray-colored)
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthinnest,cadetblue -O -K >> $ps
# Add text
gmt pstext -R -J -N -O -K \
-F+f10p,Palatino-Roman,brown+jLB >> $ps << EOF
267.0 10.0 Cocos Plate
EOF
# Text names
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,brown+jLB >> $ps << EOF
274.2 14.3 Carribean Plate
272.0 15.5 Chortis Block
267.5 16.5 North American Plate
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f8p,Times-Roman,black+jLB+a-340 -Gwhite@30 -Wthinnest >> $ps << EOF
270.0 15.8 Motagua Fault
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f8p,Times-Roman,black+jLB+a-2 -Gwhite@30 -Wthinnest >> $ps << EOF
268.3 15.6 Polochic Fault
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
    -F+jTL+f8p,Times-Roman,brown+jLB+a-37 -Gwhite@30 -Wthinnest >> $ps << EOF
274.0 10.0 Nicoya Peninsula
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
    -F+jTL+f8p,Times-Roman,black+jLB+a-305 -Gwhite@30 -Wthinnest >> $ps << EOF
273.5 14.1 Guayape Fault
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
    -F+jTL+f8p,Times-Roman,blue=0.1p,black+jLB+a-350 >> $ps << EOF
264.7 15.5 Gulf of
264.7 15.2 Tehuantepec
271.0 12.7 Gulf of
271.3 12.5 Fonseca
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
    -F+jTL+f9p,Times-Roman,brown+jLB+a-315 >> $ps << EOF
263.4 12.8 Tehuantepec Ridge
275.4 7.3 Cocos
275.6 7.1 Ridge
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f9p,Times-Roman,brown+jLB+a-337 >> $ps << EOF
272.5 16.2 Cayman Ridge
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
    -F+jTL+f9p,Times-Roman,brown=0.1p,black+jLB+a-28 >> $ps << EOF
271.3 14.0 P a c i f i c
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f9p,Times-Roman,brown=0.1p,black+jLB+a-36 >> $ps << EOF
273.4 12.8 V o l c a n i c
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f9p,Times-Roman,brown=0.1p,black+jLB+a-39 >> $ps << EOF
275.4 11.0 C h a i n
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f10p,Times-Roman,blue+jLB+a-25 >> $ps << EOF
264.5 10.0 P a c i f i c  O c e a n
EOF
# Text names
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f10p,Times-Roman,blue+jLB+a-25 >> $ps << FIN
266.5 14.0 M i d d l e
269.5 12.7 A m e r i c a
FIN
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f10p,Times-Roman,blue+jLB+a-21 >> $ps << FIN
268.2 12.5 (G u a t e m a l a)
FIN
# Text names
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+jTL+f10p,Times-Roman,blue+jLB+a-45 >> $ps << FIN
272.7 11.0 T r e n c h
FIN
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Gmidnightblue@30 -W1.0p -O -K << EOF >> $ps
265.0 11.5 50 2c
267.5 10.5 50 2c
270.0 9.5 50 2c
272.0 14.5 180 1c
272.2 14.5 0 1c
EOF
# Add legend
gmt pslegend -R -J -Dx0.5/-2.2+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c darkred 0.01c 1.0c Guatemala Trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c c 0.2c goldenrod1 0.01c 1.0c Ophiolites
S 0.3c t 0.2c red 0.01c 1.0c Volcanoes
S 0.3c v 0.8c midnightblue 0.01c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,orange 1.0c Fracture zones
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,bisque4,- 1.0c Tectonic slabs
S 0.3c c 0.2c -W0.25p,cadetblue 0.01c 1.0c Magnetic lineation picks
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous provinces
FIN
# Add text
gmt pstext -R -J -N -O -K \
    -F+f7p,Palatino-Roman,dimgray+jLB >> $ps << END
274.0 3.8 Standard paralles at 10 and 14 N
END
# Add subtitle
gmt pstext -R -J -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
266.5 17.7 Bathymetry: ETOPO 5 arc min Global Relief Model
EOF
# Add GMT logo
gmt logo -R -J -Dx5.0/0.0c+o1.6c/-3.4c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_JL_geol_MAT.ps -A1.2c -E720 -Tj -P -Z
