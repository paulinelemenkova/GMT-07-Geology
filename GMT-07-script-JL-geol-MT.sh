#!/bin/sh
# Purpose: Map of geological settings in the Mariana Trench area.
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, psxy, pslegend, pstext, logo, psconvert
# Step-1. Generate a file
ps=GMT_JL_geol_MT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,dimgray \
    MAP_ANNOT_OFFSET_PRIMARY 0.1c \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 8p,Palatino-Roman,dimgray \
    FONT_ANNOT_SECONDARY 7p,Palatino-Roman,dimgray \
    MAP_TITLE_OFFSET 1c \
    FONT_LABEL 7p,Palatino-Roman,dimgray \
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Color palette table
gmt makecpt -Cred,green,blue -T0,70,300,10000 > quakes.cpt
# Step-5. Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R120/160/0/30 -Gmt_relief.nc -V
gmt grdinfo @mt_relief.nc
# Step-6. Add title, coastlines; color areas: land-green water-blue
gmt pscoast -R120/160/0/30 -JL140/15/10/20/6i -P \
    -B+t"Geological settings in the Mariana Trench area" \
    -W0.1p -Gdarkseagreen1 -Slightcyan -Df -K > $ps
# Step-7. Add elemens of basemap: grid, rose, scale, time stamp
gmt psbasemap -R -J \
    --MAP_TITLE_OFFSET=0.3c \
    --FONT_TITLE=8p,Palatino-Roman,dimgray \
    -Bxg4f2a5 -Byg4f2a5 \
    -Tdg124/27+w0.5c+f2+l \
    -Lx5.1i/-0.5i+c50+w1000k+l"Lambert conic conformal projection. Scale at 15\232N, km"+f \
    -O -K >> $ps
# Step-8. Add bathymetric contours
gmt grdcontour @mt_relief.nc -R -J -C1000 \
    -A2000+f6p,Times-Roman -S4 -T+d15p/3p \
    -O -K >> $ps
# Step-9. Add geological lines and points
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,red -Gred -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,purple -Gpurple -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gp7+bred+f-+r300 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,orange -Gorange -O -K >> $ps
# Step-10. Add legend
gmt pslegend -R -J -Dx0.0/-2.6+w5.5c+o0.0/0.2c -F+pthin+ithinner+gwhite \
--FONT_ANNOT_PRIMARY=8p -O -K << EOF >> $ps
S 0.3c f+l+t 0.7c red 0.15p 1.0c Trench
S 0.3c f+l+t 0.7c purple 0.15p 1.0c Ridge
S 0.3c f+l+t 0.7c orange 0.15p 1.0c Transform lines
S 0.3c c 0.2c magenta 0.15p 1.0c Ophiolites
S 0.3c r 0.5c p7+bred+f+r300- 0.15p 1.0c Large igneous provinces (LIPs)
EOF
# Step-11. Add text
gmt pstext -R0/10/0/10 -Jx1i -X2.7c -Y-1.7c -N -O -K \
    -F+f7p,Palatino-Roman,dimgray+jCB >> $ps << END
4.0 0.0 Standard paralles at 10\232 and 20\232 N
END
# Step-12. Add GMT logo
gmt logo -R0/10/0/10 -Jx1i -Dx4.0/0.0c+o0.0c/0.0c+w2c -O -K >> $ps
# Step-13. Add subtitle
gmt pstext -R0/10/0/10 -Jx1i -X-2.7c -Y1.2c -N -O \
    -F+f10p,Palatino-Roman,black+jCB >> $ps << EOF
3.0 5.0 Bathymetric contour: ETOPO 5 arc min Global Relief Model
EOF
# Step-14. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_JL_geol_MT.ps -A0.2c -E720 -Tj -P -Z
