#!/bin/sh
# Purpose: shaded relief grid raster map from the ETOPO1 from 1 arc minute global data set: Atlantic Ocean
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

# 120W 50E 65S 65N
grdcut ETOPO1_Ice_g_gmt4.grd -R-90/25/-65/65 -Gao_relief.nc
gdalinfo ao_relief.nc -stats
# -8497,6560

# Make color palette
#gmt makecpt -Cdem1.cpt -V -T-8497/6560 > myocean.cpt
#gmt makecpt -Cdem4.cpt -V -T-8497/6560 > myocean.cpt
gmt makecpt -Coleron.cpt -V -T-8497/6560 > myocean.cpt
# makecpt --help

# Generate a file
ps=Geol_AO.ps
# Make raster image
gmt grdimage ao_relief.nc -Cmyocean.cpt -R-90/25/-65/65 -JPoly/4i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx20f10a20 -Bpyg20f10a10 -Bsxg10 -Bsyg10 \
    --MAP_TITLE_OFFSET=1.4c \
    -B+t"Geology of the Atlantic Ocean" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.2c \
    -Lx7.8c/-4.5c+c50+w4000k+l"Polyconic prj. Scale: km"+f \
    -UBL/1.0c/-4.5c -O -K >> $ps
    
# Add color legend
gmt psscale -DjBC+o0.0c/-5.0c+w8c/0.5c+h -R-90/25/-65/65 -J -myocean.cpt \
    --FONT_LABEL=7p,Palatino-Roman,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,dimgray \
    --MAP_LABEL_OFFSET=0.1c \
    -Baf+l"DEM scale by Th Dewez [R=-8497/6560, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Add geological lines and points
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
# tectonic slab contours
gmt psxy -R -J SC_camerica.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_caribbean.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_hellas.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_italia.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_samerica.txt -Wthinner,purple -O -K >> $ps
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthin,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,green -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
#gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,red -Gyellow -O -K >> $ps
#gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ridge.gmt -Wthicker,red -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.1c+l+t -Wthick,yellow -Gyellow -O -K >> $ps

# Add legend -3.0
gmt pslegend -R -J -Dx1.5/-3.8+w10.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
N 2
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 0.8c - 0.5p,green 1.0c Seafloor fabric, faults
S 0.3c - 0.8c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,purple 1.0c Tectonic slab
S 0.3c - 0.8c - 1.0p,red 1.0c Ridge
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add GMT logo
gmt logo -Dx3.9/-2.0+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y6.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
1.0 9.3 ETOPO1 global terrain model 1 arc min grid
EOF

# Convert to image file using GhostScript
gmt psconvert Geol_AO.ps -A4.5c -E720 -Tj -Z
