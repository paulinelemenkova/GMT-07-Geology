#!/bin/sh
# Purpose: geologic map (here: Ninety East Ridge, Indian Ocean)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddD \
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

gmt grdcut GEBCO_2019.nc -R65/107/-35/21 -Gner_relief.nc
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R65/107/-35/21 -Gner_relief.nc

gdalinfo ner_relief.nc -stats
# Minimum=-6857.000, Maximum=3206.000
# Make color palette
# makecpt --help
gmt makecpt -Ctopo.cpt -V -T-6857/3206 > myocean.cpt

# Generate a file
ps=Geol_NER.ps
# Make raster image
gmt grdimage ner_relief.nc -Cmyocean.cpt -R65/107/-35/21 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
#gmt grdimage ner_relief.nc -Cmyocean.cpt -R65/107/-35/21 -JA110/-5/15/6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=14p,Helvetica,black \
    -B+t"Geologic map of the Ninety East Ridge region, Indian Ocean" -O -K >> $ps
    
# Add shorelines
gmt grdcontour ner_relief.nc -R -J -C1000 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=8p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=9p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-4.0c+c50+w1000k+f \
    -UBL/-5p/-120p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -W0.1p -Df -O -K >> $ps
    
# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthinnest,red -O -K >> $ps
gmt psxy -R -J transform.gmt -Sc0.05c -Ggreen -Wthick,green -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Indian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_African.txt -L -Wthickest,red -O -K >> $ps
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
gmt psxy -R -J volcanoes.gmt -St0.2c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J SC_hindu2.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J SC_hindu1.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J SC_assam.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J SC_indonesia.txt -Wthinner,brown -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps

# Arrow of Rodrigues triple junction +bi
gmt psxy -R -J -Sv0.5c+ea -Gyellow@30 -W1.0p -O -K << EOF >> $ps
73.5 -23.5 210 1.3c
EOF

# Add color legend
gmt psscale -Dg65/-38+w15.2c/0.4c+h+o0.0/0i+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=6p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf \
    -I0.2 -By+lm -O -K >> $ps

# Add legend
gmt pslegend -R -J -Dx1.5/-3.5+w15.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=9p,Helvetica,black -O -K << FIN >> $ps
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
gmt logo -Dx6.2/-5.0+o0.1i/0.1i+w2c -O >> $ps

# Convert to image file using GhostScript
gmt psconvert Geol_NER.ps -A2.5c -E720 -Tj -Z
