#!/bin/sh
# Purpose: geologic map from the GEBCO dataset (here: Indian Ocean, Sunda Trench)
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
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

#gmt grdcut GEBCO_2019.nc -R90/130/-20/10 -Gst_relief.nc
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R90/130/-20/10 -Gst_relief.nc

gdalinfo st_relief.nc -stats
#  Minimum=-9848.000, Maximum=3816.000
# Make color palette
# gmt makecpt --help
gmt makecpt -Cgeo.cpt -V -T-9848/3816 > myocean.cpt

# Generate a file
ps=GMT_geol_ST.ps
# Make raster image
#gmt grdimage st_relief.nc -Cmyocean.cpt -R90/130/-20/10 -JPoly/6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage st_relief.nc -Cmyocean.cpt -R90/130/-20/10 -JA110/-5/15/6.5i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --MAP_FRAME_AXES=WESN \
    -B+t"Tectonic and geologic map of the Indonesian Archipelago" -O -K >> $ps
    
# Add shorelines
gmt grdcontour st_relief.nc -R -J -C1000 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_TITLE_OFFSET=0.3c \
    -UBL/-5p/-40p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -W0.1p -Df -O -K >> $ps

# Add legend
gmt psscale -Dg90.0/-20+w15.0c/0.4c+v+o0.3/0i+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=7p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -Ba2000g1000f100+l"Color scale: geo global bathymetry/topography relief [R=-5119/3505, H=0, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
gmt psxy -R -J transform.gmt -Sc0.05c -Ggreen -Wthick,green -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Philippine_Sea.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Indian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Australian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Eurasian.txt -L -Wthickest,red -O -K >> $ps
#
gmt psmeca -R CMT.txt -J -Sd0.4/2/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

#Add geological lines and points
gmt psxy -R -J volcanoes.gmt -St0.17c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J SC_sulawesi.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J SC_mindanao.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J SC_luzon.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J SC_indonesia.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
112 1 Kalimantan
109 -7.8 Java
119 -2 Sulavesi
104 0.5 Singapore
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,black+jLB+a-46 -Gwhite@30 >> $ps << EOF
101.5 -0.5 Sumatra
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica-Oblique,yellow+jLB >> $ps << EOF
97 -9.5 I N D I A N
97 -11.0 O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
106 7.0 South China
108 6.0 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
120.0 4.0 Celebes
120.4 3.2 Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
108 -4.8 Java Sea
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f8p,Helvetica,blue+jLB -Gwhite@30 >> $ps << EOF
123.4 -4.8 Banda
124.0 -5.8 Sea
EOF

# Add legend -3.0
gmt pslegend -R -J -Dx1.5/-2.0+w14.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 0.9c - 0.5p,pink 1.0c Faults on seafloor fabric
S 0.3c - 0.9c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,red 1.0c Ridge
S 0.3c - 0.9c - 1.0p,red 1.0c Tectonic plate boundary
S 0.3c - 0.9c - 1.0p,green 1.0c Transform fault
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Trench
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add GMT logo
gmt logo -Dx1.0/-0.5+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y9.9c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 11.0 GEBCO 15 arc sec resolution global terrain model grid
3.5 10.4 Lambert Azimuthal Equal-Area projection
EOF

# Convert to image file using GhostScript
gmt psconvert GMT_geol_ST.ps -A2.5c -E720 -Tj -Z
