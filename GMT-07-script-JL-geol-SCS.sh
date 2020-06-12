#!/bin/sh
# Purpose: Map of geological settings (here: South China Sea).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=GMT_JL_geol_SCS.ps
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
gmt grdcut earth_relief_05m.grd -R99/122/2/23 -Gscs_relief.nc -V
#gmt grdinfo @scs_relief.nc
# Add coastlines; color areas: land-green water-blue
gmt pscoast -R99/122/2/23 -JL110/12/8/17/6i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological settings in the South China Sea basin" \
    -Bpxg4f2a5 -Bpyg2f1a2 -Bsxg4 -Bsyg4\
    -Lx12.6c/-1.2c+c50+w800k+l"Lambert conic conformal projection. Scale at 110\232N, km"+f \
    -O -K >> $ps
# Add directional rose
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,darkblue \
    --MAP_TITLE_OFFSET=0.5c \
    -Tdg101/4+w0.5c+f2+l \
    -UBR/15c/-60p -O -K >> $ps
# Add bathymetric contours
gmt grdcontour @scs_relief.nc -R -J -C500 \
    -A2000+f7p,Times-Roman -S4 -T+d15p/3p \
    -W0.1p -O -K >> $ps
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,green -Gred -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.2c -Ggoldenrod1 -Wthinnest -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -Sc0.2c -Gred -Wthinnest -O -K >> $ps
# Add text
gmt pstext -R -J -N -O -K \
-F+f14p,Palatino-Roman,blue+jLB >> $ps << EOF
112.5 12.8 South China Sea
EOF
# Add legend
gmt pslegend -R -J -Dx0.0/-2.6+w4.0c+o1.0/0.5c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
S 0.3c f+l+t 0.7c green 0.01c 1.0c Hadal trench
S 0.3c c 0.2c goldenrod1 0.01c 1.0c Ophiolites
S 0.3c c 0.2c red 0.01c 1.0c Volcanoes
FIN
# Add text
gmt pstext -R -J -N -O -K \
    -F+f7p,Palatino-Roman,dimgray+jLB >> $ps << END
160.0 38.3 Standard paralles at 8 and 12 N
END
# Add subtitle
gmt pstext -R -J -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
142.0 61.4 Bathymetry: ETOPO 5 arc min Global Relief Model
EOF
# Add GMT logo
gmt logo -R -J -Dx5.0/0.0c+o1.6c/-1.8c+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_JL_geol_SCS.ps -A0.2c -E720 -Tj -P -Z
