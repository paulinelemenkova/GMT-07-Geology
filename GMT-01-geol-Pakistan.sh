#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO 15 arc sec global data set (here: Pakistan)
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
    FONT_LABEL=7p,Helvetica,dimgray \
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Extract a subset of ETOPO1m for the Iceland area
gmt grdcut ETOPO1_Ice_g_gmt4.grd -R60.0/80.0/23.5/37.2 -Gpk_relief.nc
#gmt grdcut GEBCO_2019.nc -R60.0/80.0/23.5/37.2 -Gpk_relief.nc
gdalinfo -stats pk_relief.nc
# Minimum=-3549.000, Maximum=7966.000

# Make color palette
gmt makecpt -Ctopo.cpt -V -T-3549/7966 > myocean.cpt

ps=GeolPK.ps
# Make raster image
gmt grdimage pk_relief.nc -Cmyocean.cpt -R60/80/23.5/37.2 -JM6.5i -I+a15+ne0.75 -Xc -K > $ps

# Add legend
gmt psscale -Dg57.3/23.5+w13.2c/0.15i+v+o0.3/0i+ml -R -J -Cmyocean.cpt \
	--FONT_LABEL=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_TITLE=6p,Helvetica,black \
	-Bg500f50a500+l"Color scale: Sandwell/Anderson colors for topography [R=-3549/+7966, H, C=HSV]" \
	-I0.2 -By+lm -O -K >> $ps
    
# Add shorelines
gmt grdcontour pk_relief.nc -R -J -C500 -W0.1p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinner,blue -Na -N1/thicker,khaki1 -W0.1p -Df -O -K >> $ps
    
# Add grid
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=wEsN \
    --MAP_TITLE_OFFSET=1.0c \
    --FONT_TITLE=12p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    --FONT_LABEL=7p,Helvetica,black \
    -Bpxg2f1a2 -Bpyg2f1a2 -Bsxg2 -Bsyg1 \
    -B+t"Geologic and tectonic map of Pakistan" -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT=7p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --MAP_TITLE_OFFSET=0.1c \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_LABEL_OFFSET=0.1c \
    -Tdx15.0c/0.4c+w0.3i+f2+l+o0.15i \
    -Lx14.5c/-2.5c+c50+w300k+l"Mercator projection. Scale (km)"+f \
    -UBL/-15p/-75p -O -K >> $ps

# Add geological lines and points
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
# tectonic slab contours
gmt psxy -R -J SC_hindu1.txt -Wthicker,brown -O -K >> $ps
gmt psxy -R -J SC_hindu2.txt -Wthicker,blue -O -K >> $ps

# fabric and magnetic lineation picks fracture zones
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Gmagenta -Wthinnest -O -K >> $ps
#gmt psxy -R -J transform.gmt -Sc0.5c -Gblack -Wthickest,black -O -K >> $ps
gmt psxy -R -J transform.gmt -L -Wthicker,green1 -O -K >> $ps
#gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,red -Gyellow -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sc0.05c -Gred -Wthickest,red -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Arabian.txt -L -Wthicker,red -O -K >> $ps
gmt psxy -R -J TP_Indian.txt -L -Wthicker,red -O -K >> $ps
gmt psxy -R -J TP_Eurasian.txt -L -Wthicker,red -O -K >> $ps
#
gmt psmeca -R CMT.txt -J -Sd0.4/2/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps
#
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,pink -O -K >> $ps
#
# Step-8. Add earthquake points
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
67.3 24.6 Karachi
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
67.3 24.4 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,black+jLB -Gwhite@30 -Wthinnest >> $ps << EOF
70.8 30.5 P A K I S T A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30 -Wthinnest >> $ps << EOF
77.0 25.5 I N D I A
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30 -Wthinnest >> $ps << EOF
63.5 33.5 A F G H A N I S T A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30 -Wthinnest >> $ps << EOF
61.0 27.9 I R A N
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f10p,Helvetica,black+jLB -Gwhite@30 -Wthinnest >> $ps << EOF
77.0 36.5 C H I N A
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
60.6 24.3 A R A B I A N
61.0 23.7 P L A T E
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
72.5 28.2 I N D I A N  P L A T E
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
61.8 31.5 E U R A S I A N
62.4 31.0 P L A T E
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,Times−Italic,white+jLB+a-324 >> $ps << EOF
68.7 28.0 Indus River
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,2,yellow+jLB -Gdimgrey -Wthinnest >> $ps << EOF
68.0 31.6 Muslim Bagh
68.0 31.2 Ophiolite Complex
EOF
# Arrows
gmt psxy -R -J -Sv0.5c+bt+ea -Gdred@30 -W1.0p -O -K << EOF >> $ps
69.0 31.5 210 1.0c
EOF
#
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,2,yellow+jLB -Gdimgrey -Wthinnest >> $ps << EOF
68.6 30.5 Sulaiman
68.6 30.1 Fold Belt
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,2,yellow+jLB -Gdimgrey -Wthinnest >> $ps << EOF
63.5 33.1 Afghan Block
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,0,yellow+jLB >> $ps << EOF
72 31 Punjab
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f11p,0,yellow+jLB >> $ps << EOF
68.2 26.2 Sindh
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,0,yellow+jLB >> $ps << EOF
70.6 28.7 Cholistan
70.7 28.3 Desert
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f9p,0,yellow+jLB+a-312 >> $ps << EOF
70.3 25.0 T  h  a  r     D  e  s  e  r  t
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@30 >> $ps << EOF
74.2 31.2 Lahore
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
74 31 0.15c
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,0,black+jLB -Gwhite@30 >> $ps << EOF
71.5 33.7 Peshawar
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
71.3 34 0.15c
EOF

# Add legend -3.0
gmt pslegend -R -J -Dx1.5/-2.0+w16.5c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=8p,black -O -K << FIN >> $ps
H 10 Helvetica Legend
N 4
S 0.3c t 0.2c red 0.03c 1.0c Volcanoes
S 0.3c - 0.8c - 0.7p,brown 1.0c Tectonic slab Hindu (1)
S 0.3c - 0.8c - 0.7p,blue 1.0c Tectonic slab Hindu (2)
S 0.3c c 0.15c magenta 0.01c 1.0c Ophiolites
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Trenches, faults
S 0.3c - 0.9c - 0.5p,gold1 1.0c Fracture zones
S 0.3c - 0.9c - 1.0p,red 1.0c Tectonic plates
S 0.3c - 0.9c - 1.0p,khaki1 1.0c Country borders
S 0.3c - 0.9c - 1.0p,green1 1.0c Transform lines
FIN

# Add GMT logo
gmt logo -Dx7.0/-3.3+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y8.0c -N -O \
    -F+f10p,Helvetica,black+jLB >> $ps << EOF
3.0 8.9 Digital relief model: ETOPO1 1 arc-minute grid of Earth's surface
EOF

# Convert to image file using GhostScript
gmt psconvert GeolPK.ps -A1.0c -E720 -Tj -Z
