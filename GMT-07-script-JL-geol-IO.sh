#!/bin/sh
# Purpose: Map of geological settings (here: Ryukyu Trench).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert

# Step-1. GMT set up
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
    
# Step-2. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Step-4. Cut off the relief map from ETOPO5
grdcut ETOPO1_Ice_g_gmt4.grd -R20/120/-65/30 -Gio2_relief.nc
gmt grdinfo @io2_relief.nc

# Step-5. Add coastlines; color areas: land-green water-blue
#gmt pscoast -R20/120/-65/30 -JQ5.0i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Step-5. Make color palette
#gmt makecpt -dem3.cpt -V -T-7898/8271 > myocean.cpt
gmt makecpt -dem2.cpt -V -T-7898/8271 > myocean.cpt
#gmt makecpt --help
# Step-6. Make raster image

# Step-3. Generate a file
ps=GMT_geol_IO.ps
# gmt grdimage GEBCO_2019.nc -Cmyocean.cpt -R120/134/-80/-40 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
#grdcut ETOPO1_Ice_g_gmt4.grd -R20/120/-65/30 -Gio2_relief.nc
gmt grdimage io2_relief.nc -Cmyocean.cpt -R20/120/-65/30 -JQ5.0i -P -I+a15+ne0.75 -Xc -K > $ps
    
# Step-6. Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdx0.8c/10.3c+w0.3i+f2+l+o0.15i \
    -Lx11c/-2.8c+c50+w2000k+l"Cylindrical equidistant prj. Scale: km"+f \
    -UBL/-5p/-80p -O -K >> $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx204f10a10 -Bpyg20f10a10 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_TITLE=12p,Palatino-Roman,black \
    -B+t"Geologic settings of the Indian Ocean" -O -K >> $ps

# legend
gmt psscale -Dg0.0/-65+w12.0c/0.4c+v+o0.3/0i+ml -R20/120/-65/30 -J -Cmyocean.cpt \
    --FONT_LABEL=7p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale: dem2 by Dewez/Wessel [R=0/4900, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
# Step-7. Add bathymetric contours
gmt grdcontour @io2_relief.nc -R -J -C4000 -W0.1p -O -K >> $ps
    
# Step-9. Add geological lines and points
#gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
# tectonic slab contours
gmt psxy -R -J SC_indonesia.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_assam.txt -Wthinner,blue -O -K >> $ps
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
#gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,red -Gyellow -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps

# Add legend -3.0
gmt pslegend -R -J -Dx0.5/-2.2+w14.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 1.2c - 0.5p,pink 1.0c Seafloor fabric, faults
S 0.3c - 1.2c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,blue 1.0c Tectonic slab (Assam)
S 0.3c - 1.2c - 0.5p,purple 1.0c Tectonic slab (Indonesia)
S 0.3c - 0.8c - 1.0p,red 1.0c Ridge
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Step-19. Add GMT logo
gmt logo -Dx5.2/-3.4+o0.1i/0.1i+w2c -O -K >> $ps

# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.0c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.8 10.0 ETOPO 1 global terrain model, 1 min resolution grid
EOF

# Step-20. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_geol_IO.ps -A1.0c -E720 -Tj -P -Z
