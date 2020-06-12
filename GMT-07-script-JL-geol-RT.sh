#!/bin/sh
# Purpose: Map of geological settings (here: Ryukyu Trench).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Step-1. Generate a file
ps=GMT_JL_geol_RT.ps
# Step-2. GMT set up
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
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R120/134/20/33 -Grt_relief.nc -V
gmt grdinfo @rt_relief.nc
# Step-5. Add coastlines; color areas: land-green water-blue
gmt pscoast -R120/134/20/33 -JL127/27/24/30/6i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Step-6. Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological map of the Ryukyu Trench area" \
    -Bpxg4f2a2 -Bpyg2f1a2 -Bsxg4 -Bsyg4\
    -Lx13c/-3.5c+c50+w500k+l"Lambert conic conformal projection"+f \
    -O -K >> $ps
# Step-10. Add directional rose
gmt psbasemap -R -J \
    --FONT=10p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdg142.5/57.5+w0.5c+f2+l \
    -UBR/3.5c/-3.5c -O -K >> $ps
# Step-7. Add bathymetric contours
gmt grdcontour @rt_relief.nc -R -J -C500 \
    -A2000+f9p,Times-Roman -S4 -T+d15p/3p \
    -W0.1p -O -K >> $ps
# Step-9. Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,red -Gred -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,darkcyan -Gpurple -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -Sc0.3c -Gred -Wthinnest -O -K >> $ps
# Step-10. Add tectonic slab contours
gmt psxy -R -J SC_ryukyus.txt -Wthinner,brown -O -K >> $ps
# Step-11.
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,yellowgreen -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,gold1 -O -K >> $ps
# Names
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
120.5 23.6 Taiwan
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Times-Roman,black+jLB+a-30 -Gwhite@30 >> $ps << EOF
129.0 29.3 Tokara Fault
EOF
# линия kwargs: координаты XY
gmt psxy -R -J -W1p,orange -O -K << EOF >> $ps
127.9 29.8
130.9 28.2
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Times-Roman,black+jLB+a-32 -Gwhite@30 >> $ps << EOF
125.5 26.7 Miyako Fault
EOF
# линия kwargs: координаты XY
gmt psxy -R -J -W1p,orange -O -K << EOF >> $ps
125.0 27.0
127.3 25.6
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Times-Roman,black+jLB+a-46 -Gwhite@30 >> $ps << EOF
126.1 27.5 Kerama Fault
EOF
# линия kwargs: координаты XY
gmt psxy -R -J -W1p,orange -O -K << EOF >> $ps
125.8 27.7
127.7 25.8
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f12p,Times-Roman,black+jLB+a-343 -Gwhite@30 >> $ps << EOF
122.9 24.6 Okinawa
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f12p,Times-Roman,black+jLB+a-297 -Gwhite@30 >> $ps << EOF
128.5 28.0 Trough
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
130.5 32.5 Kyushu
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f13p,Times-Roman,blue+jLB>> $ps << EOF
123.0 31.0 E a s t  C h i n a  S e a
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,black+jLB>> $ps << EOF
123.0 29.0 East China Sea Shelf
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,black+jLB+a-333 >> $ps << EOF
125.5 22.8 R y u k y u
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,black+jLB+a-311 >> $ps << EOF
129.3 25.5 T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
122.5 23.5 R y u k y u
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB+a-330 -Gwhite@30 >> $ps << EOF
125.0 23.7 V o l c a n i c
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB+a-320 -Gwhite@30 >> $ps << EOF
127.3 25.2 I s l a n d s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB+a-310 -Gwhite@30 >> $ps << EOF
128.8 26.5 A r c
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,darkbrown+jLB+a-330>> $ps << EOF
120.5 25.5 Active margin
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,blue+jLB >> $ps << EOF
129.5 21.0 P h i l i p p i n e  S e a
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,brown+jLB -Gwhite@30>> $ps << EOF
128.5 22.5 Philippine Sea Plate
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Times-Roman,brown+jLB -Gwhite@30>> $ps << EOF
122.5 27.5 Eurasian Plate
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,black+jLB+a-15 -Gwhite@30>> $ps << EOF
130.8 26.1 Daito Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,black+jLB+a-30 -Gwhite@30>> $ps << EOF
131.0 24.8 Oki-Daito Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Times-Roman,black+jLB+a-45 -Gwhite@30>> $ps << EOF
131.7 31.8 Kyushu-Palau Ridge
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Helvetica,black+jLB -Gwhite@30>> $ps << EOF
128.4 27.6 Yokoate-jima
EOF
gmt pstext -R -J -N -O -K \
    -F+jTL+f10p,Helvetica,black+jLB -Gwhite@30>> $ps << EOF
129.9 29.3 Akuseki-jima
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30>> $ps << EOF
130.3 29.7 Kuchino-shima
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30>> $ps << EOF
130.2 30.1 Kuchinoerabu-jima
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30>> $ps << EOF
130.5 30.7 Ibusuki
130.5 30.4 Volacnic Field
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-330 -Gwhite@30>> $ps << EOF
124.2 24.1 Iriomote-jima
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB+a-330 -Gwhite@30>> $ps << EOF
122.5 25.5 Pengchiahsu
EOF
# 2. вектор: стрелки тонкие с желтым кружком в начале и острием в конце.
# kwargs: координаты, угол наклона, длина
gmt psxy -R -J -Sv0.5c+ea -Gyellow -W1.2p -O -K << EOF >> $ps
124.8 22.0 140 1.2c
128.5 23.5 140 1.2c
130.2 24.6 140 1.2c
132.4 28.6 140 1.2c
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Times-Roman,black+jLB -Gwhite@30>> $ps << EOF
124.7 21.7 71 mm/yr
128.0 23.1 67 mm/yr
130.0 24.2 62 mm/yr
132.3 28.2 57 mm/yr
EOF
# 8. звездочка // star.
# kwargs: координаты XY, диаметр
gmt psxy -R -J -Sa -W0.2p,black -Gmagenta -O -K << EOF >> $ps
127.8 27.1 0.3c
127.7 27.6 0.3c
127.6 28.1 0.3c
128.1 27.3 0.3c
128.2 27.7 0.3c
129.8 29.4 0.3c
130.0 29.7 0.3c
130.1 30.4 0.3c
122.2 25.1 0.3c
122.7 25.2 0.3c
123.7 25.3 0.3c
123.8 24.3 0.3c
124.2 25.1 0.3c
124.3 25.2 0.3c
EOF
gmt psxy -R -J -St -W0.2p,black -Ggreen -O -K << EOF >> $ps
122.4 24.8 0.3c
125.1 26.2 0.3c
127.1 27.4 0.3c
EOF
gmt psxy -R -J -St -W0.2p,black -Ggreen -O -K << EOF >> $ps
123.0 25.0 0.2c
123.2 25.2 0.2c
124.2 25.1 0.2c
126.1 26.0 0.2c
126.2 26.2 0.2c
126.4 27.1 0.2c
127.2 29.1 0.2c
129.1 31.1 0.2c
129.2 31.5 0.2c
EOF
# Step-14. Add text
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,black+jLB >> $ps << END
129.5 16.7 Scale at 24\232N, km
129.5 16.3 Standard paralles at 27\232 and 30\232 N
END
# Add legend
gmt pslegend -R -J -Dx-0.0/-2.8+w18.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=10p,black -O -K << FIN >> $ps
N 3
S 0.3c c 0.3c red 0.02c 1.0c Volcanoes
S 0.3c t 0.3c green 0.02c 1.0c Sedimentary rate 1000 m/Ma
S 0.3c t 0.2c green 0.02c 1.0c Sedimentary rate 500 m/Ma
S 0.3c a 0.3c magenta 0.02c 1.0c Hydrothermal area
S 0.3c v 1.2c yellow 0.01c 1.0c Convergence rate mm/yr
S 0.3c - 0.8c - 0.5p,yellowgreen 1.0c Magnetic anomalies
S 0.3c - 0.8c - 0.5p,brown 1.0c Tectonic slabs
S 0.3c - 1.2c - 0.5p,orange 1.0c Tectonic faults
S 0.3c f+l+t 0.7c darkcyan 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c red 0.01c 1.0c Trench
FIN
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.0c -N -O -K \
    -F+f12p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 15.0 ETOPO 5 global terrain model, 5 min resolution grid
EOF
# Step-19. Add GMT logo
gmt logo -R -J -Dx5.0/-8.0c+o1.8c/-2.0c+w2c -O >> $ps
# Step-20. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_JL_geol_RT.ps -A2.0c -E720 -Tj -P -Z
