#!/bin/sh
# Purpose: Map of geological settings (here: Manila Trench).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Step-1. Generate a file
ps=GMT_JL_geol_MnT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=ddd \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1c \
    MAP_ANNOT_OFFSET 0.2c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinnest,dimgray \
    MAP_GRID_PEN_SECONDARY thinnest,white \
    FONT_TITLE 14p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 10p,Helvetica,black \
    FONT_LABEL 10p,Helvetica,black \
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-4. Cut off the relief map from ETOPO1
gmt grdcut earth_relief_01m.grd -R105/123/8/24 -Gmnt_relief.nc -V
gmt grdinfo @mnt_relief.nc
# Step-5. Add coastlines; color areas: land-green water-blue
#gmt pscoast -R105/123/8/24 -JL114/13/16/19/6i -P \
#   -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Step-4. Make color palette
gmt makecpt -Cglobe.cpt -V -T-6200/3500 > myocean.cpt
# Step-5. Make raster image
gmt grdimage mnt_relief.nc -Cmyocean.cpt -R105/123/8/24 -JL114/13/16/19/6i \
   -P -I+a15+ne0.75 -Xc -K > $ps
# Step-6. Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological map of the Manila Trench area" \
    -Bpxg4f2a2 -Bpyg2f1a2 -Bsxg4 -Bsyg4\
    -Lx13c/-3.5c+c50+w500k+l"Lambert conic conformal projection"+f \
    -O -K >> $ps
# Step-10. Add directional rose
gmt psbasemap -R -J \
    --FONT=10p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdg120.5/22.0+w0.5c+f2+l \
    -UBR/3.5c/-3.5c -O -K >> $ps
# Step-7. Add bathymetric contours
gmt grdcontour @rt_relief.nc -R -J -C500 \
    -A2000+f9p,Times-Roman -S4 -T+d15p/3p \
    -W0.1p -O -K >> $ps
# Step-9. Add geological lines and points
gmt psxy -R -J volcanoes.gmt -Sc0.3c -Gred -Wthinnest -O -K >> $ps
# Step-10. Add tectonic slab contours
gmt psxy -R -J SC_wphilippines.txt -Wthick,orange -O -K >> $ps
# Step-11.
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
# Names
# Step-14. Add text
gmt pstext -R -J -N -O -K \
    -F+f10p,Helvetica,black+jLB >> $ps << END
118.0 3.4 Scale at 16\232N, km
118.0 3.0 Standard paralles at 13\232 and 19\232 N
END
# Add legend
gmt pslegend -R -J -Dx-0.0/-2.4+w16.0c+o-0.5/0.1c \
-F+pthin+ithinner+gwhite \
--FONT=10p,black -O -K << FIN >> $ps
N 3
S 0.3c c 0.3c red 0.02c 1.0c Volcanoes
S 0.3c - 0.8c - 0.5p,orange 1.0c Tectonic slabs
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Trench
FIN
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.0c -Y5.5c -N -O -K \
-F+f12p,Palatino-Roman,black+jLB >> $ps << EOF
2.5 14.0 ETOPO 1 global terrain model, 1 min resolution grid
EOF
# Step-19. Add GMT logo
gmt logo -R -J -Dx5.0/-8.0c+o1.8c/-1.0c+w2c -O >> $ps
# Step-20. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_JL_geol_MnT.ps -A2.0c -E720 -Tj -P -Z
