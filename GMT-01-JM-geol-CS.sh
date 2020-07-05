#!/bin/sh
# Purpose: shaded relief grid raster map from the ETOPO1 from 1 arc minute global data set (here: Caribbean Sea)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

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
    FONT_LABEL=7p,Helvetica,dimgray
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

#grdcut GEBCO_2019.nc -R270/305/7/25 -Gcs_relief.nc
grdcut ETOPO1_Ice_g_gmt4.grd -R270/305/7/24 -Gcs_relief.nc

gdalinfo cs_relief.nc -stats
# -8619.841796875,5535.625
# Make color palette
# makecpt --help
gmt makecpt -Ctopo.cpt -V -T-8620/5536 > myocean.cpt

# Generate a file
ps=GMT_geol_CS.ps
# Make raster image
gmt grdimage cs_relief.nc -Cmyocean.cpt -R270/305/7/24 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx104f2.5a5 -Bpyg10f2.5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    -B+t"Geologic map of the Caribbean Sea region" -O -K >> $ps
    
# Add shorelines
gmt grdcontour cs_relief.nc -R -J -C1000 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Palatino-Roman,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    -Tdx13.8c/1.0c+w0.2i+f2+l+o0.1c \
    -Lx12.7c/-2.2c+c50+w700k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-60p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -W0.1p -Df -O -K >> $ps

# Add legend
gmt psscale -Dg264.5/7+w7.7c/0.4c+v+o0.3/0i+ml -R270/305/7/24 -J -Cmyocean.cpt \
    --FONT_LABEL=6p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale 'topo': Sandwell/Anderson colors for topography [R=-8620/5536, H=0, C=HSV]" \
    -I0.2 -By+lm -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-65 -Gwhite@40 >> $ps << EOF
298.0 18.0 L e s s e r
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-86 -Gwhite@40 >> $ps << EOF
299.3 15.1 Antilles
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,yellow+jLB >> $ps << EOF
282.4 15.1 C A R I B B E A N  S E A
293 22.0 A T L A N T I C   O C E A N
270.2 9.0 PACIFIC
270.2 8.2.0 OCEAN
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-30 -Gwhite@40 >> $ps << EOF
281 22 Cuba
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
282 18.7 Jamaica
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
287.5 17.5 Hispaniola
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,black+jLB -Gwhite@40 >> $ps << EOF
293 17.5 Puerto Rico
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-20 -Gwhite@30 >> $ps << EOF
279.0 23.5 G    r    e    a    t    e    r       A    n    t    i    l    l    e    s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-27 -Gwhite@30 >> $ps << EOF
286.0 23.5 B a h a m a s
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB+a-350 >> $ps << EOF
276 17.7 Cayman Trough
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB >> $ps << EOF
293 20 Puerto
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB+a-8 >> $ps << EOF
296 19.9 Rico
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,white+jLB+a-25 >> $ps << EOF
298 19.4 Trench
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,white+jLB >> $ps << EOF
282 13 Colombia
282 12 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,white+jLB >> $ps << EOF
292.5 15.1 Venezuela
292.5 14.1 Basin
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f7p,Helvetica,white+jLB >> $ps << EOF
275.5 20.6 Yucatan
275.5 19.6 Basin
EOF

# Add geological lines and points
#gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,purple -Gpurple -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
# tectonic slab contours
gmt psxy -R -J SC_caribbean.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_samerica.txt -Wthinner,purple -O -K >> $ps
gmt psxy -R -J SC_camerica.txt -Wthinner,blue -O -K >> $ps
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
#gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,red -Gyellow -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Caribbean.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_North_Am.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_South_Am.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Nazca.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Cocos.txt -L -Wthickest,red -O -K >> $ps
#
gmt psmeca -R CMT.txt -J -Sd0.4/10/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/8/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/8/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Add legend -3.0
gmt pslegend -R -J -Dx2.0/-1.8+w14.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 1.2c - 0.5p,pink 1.0c Faults on seafloor fabric
S 0.3c - 1.2c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,blue 1.0c Tectonic slab
S 0.3c - 0.8c - 1.0p,red 1.0c Ridge
S 0.3c f+l+t 0.7c purple 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add GMT logo
gmt logo -Dx6.2/-2.9+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.7c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
2.8 4.2 GEBCO global terrain model, 15 arc sec resolution grid
EOF

# Convert to image file using GhostScript
gmt psconvert GMT_geol_CS.ps -A3.5c -E720 -Tj -Z
