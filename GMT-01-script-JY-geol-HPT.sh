#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO from 15 arc sec global data set
# here: Hikurangi, Puysegur and Hjort trenches
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# Step-1. Extract a subset of GEBCO for the Hikurangi, Puysegur and Hjort trenches  -JS170/-20/16c -JM16c
grdcut GEBCO_2019.nc -R145/186/-70/-30 -Ghpt_relief.nc
#grdcut earth_relief_01m.grd -R145/186/-70/-30 -Ghpt_relief.nc
# Step-2. Make color palette
gmt makecpt -Cetopo1.cpt -V -T-8000/3000 > myocean.cpt
#
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thinner,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    FONT_LABEL=8p,Helvetica,black \
    OBLIQUE_ANNOTATION 0 \
# Step-3. Overwrite defaults of GMTs
gmtdefaults -D > .gmtdefaults
#
# START
# Step-1. Generate a file
ps=Geol_HPT.ps
# Step-6. Make raster image
gmt grdimage hpt_relief.nc -Cmyocean.cpt -R145/186/-70/-30 \
    -JM16c -P -I+a15+ne0.75 -Xc -K > $ps
# Step-7. Add color legend
gmt psscale -Dg138.0/-70+w26.0c/0.4c+v+o0.3/0i+ml -Rhpt_relief.nc -J -Cmyocean.cpt \
	--FONT_LABEL=8p,Helvetica,dimgray \
	--FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    --MAP_TITLE_OFFSET=0.1c \
    -Baf+l"Topographic color scale. CPT 'etopo1' Colormap used in the ETOPO1 global relief map [R=-11000/8500, H=0, C=RGB]" \
	-I0.2 -By+lm -O -K >> $ps
# Step-8. Add shorelines
gmt grdcontour hpt_relief.nc -R -J -C2000 -W0.1p -O -K >> $ps
# Step-9. Add grid
gmt psbasemap -R -J \
    -Bpxg4f2a4 -Bpyg4f2a4 -Bsxg4 -Bsyg2 \
    -B+t"Map of the geologic settings in New Zealand, Hikurangi, Puysegur and Hjort trenches" -O -K >> $ps
# Step-10. Add projection scale
gmt psbasemap -R -J \
    --FONT=9p,Palatino-Roman,dimgray \
    --MAP_TITLE_OFFSET=0.3c \
    -Lx14c/-3.0c+c50+w800k+l"Mercator projection. Scale (km)"+f \
    -UBL/-5p/-90p -O -K >> $ps
# Geology
# Add geological lines and points
gmt psxy -R -J LIPS.2001.points.gmt -Sc0.1c -Gyellow -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
# others
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.6c/0.2c+l+t -Wthinner,green -Ggreen -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow  -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthicker,gold1,- -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthicker,deeppink -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_tonga.txt -W0.6p,yellow3,- -O -K >> $ps
# Add magnetic lineation picks
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthinnest,mediumspringgreen -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.15c -Wthinnest,black -Gorange -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Pacific.txt -L -W3p,red -O -K >> $ps
gmt psxy -R -J TP_Australian.txt -L -W3p,red -O -K >> $ps
gmt psxy -R -J TP_Antarctic.txt -L -W3p,red -O -K >> $ps
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.4c+bt+ea -Gred@20 -W1.0p,black -O -K >> $ps << EOF
184.0 -38.0 200 1.2c
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica−Bold,black+jLB -Gwhite@30 >> $ps << EOF
183.0 -37.5 43 mm/yr
EOF
# texts
gmt pstext -R -J -N -O -K \
-F+f9p,Times-Roman,black+jLB -Gwhite@20 -Wthinnest,darkbrown >> $ps << EOF
146 -42 TASMAN
146 -32.0 AUSTRALIA
147.5 -69.5 ANTARCTICA
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,black+jLB -Gwhite@20 >> $ps << EOF
176.2 -36.3 North
176.2 -37.0 Island
171.7 -45 South
171.7 -45.7 Island
159.3 -55 Macquarie Is.
168 -47.5 Stewart Is.
182 -40.0 Hikurangi
182 -40.7 Plateau
175 -34.0 Raukumara
175 -34.7 Plain
178.8 -46 Bounty Trough
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,black+jLB -Gwhite@30 >> $ps << EOF
162 -58.0 Macquarie Ridge
162 -58.6 Complex
161 -57.0 Hjort
161 -57.5 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,black+jLB+a-310 -Gwhite@30 >> $ps << EOF
161.2 -53 Macquarie Arc
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,black+jLB+a-50 -Gwhite@30 >> $ps << EOF
162.0 -33 Lord Howe Rise
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,black+jLB+a-325 -Gwhite@30 >> $ps << EOF
167.5 -44 Alpine Fault
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,black+jLB -Gwhite@20 >> $ps << EOF
170 -50.0 CAMPBELL
170 -50.6 PLATEAU
175 -43.4 CHATHAM RISE
167 -39.0 CHALLENGER
167 -39.7 PLATEAU
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Helvetica−Bold,white+jLB >> $ps << EOF
152.5 -38.5 T A S M A N  S E A
174 -69 R O S S  S E A
178 -54 P A C I F I C
178 -55 O C E A N
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,black+jLB+a-40 -Gwhite@30 >> $ps << EOF
147 -45.4 South Tasman
147 -46.2 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,white+jLB+a-292 >> $ps << EOF
181.4 -36.2 Kermadec Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,red+jLB+a-301 -Gwhite@30>> $ps << EOF
177.9 -42.0 Hikurangi Trench
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,red+jLB+a-308 -Gwhite@30>> $ps << EOF
158.5 -53.0 P u y s e g u r  T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,red+jLB+a-110 -Gwhite@30>> $ps << EOF
159 -56.0 Hjort
EOF
gmt pstext -R -J -N -O -K \
-F+f10p,Helvetica−Bold,red+jLB+a-56 -Gwhite@30>> $ps << EOF
158.2 -58.0 Trench
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
159 -55 0.2c
EOF
gmt psxy -R -J -Sc -W0.5p -Gyellow -O -K << EOF >> $ps
161.0 -61.3 0.4c
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Helvetica−Bold,red+jLB -Gwhite@30 >> $ps << EOF
161.6 -60.9 Macquarie
161.6 -61.5 Triple Junction
EOF
#
# GEOL texts
gmt pstext -R -J -N -O -K \
-F+f13p,Helvetica−Bold,blueviolet+jLB -Gwhite@30>> $ps << EOF
172.0 -57.0 PACIFIC PLATE
152.2 -44.0 INDO -
152.2 -44.8 AUSTRALIAN PLATE
165.0 -65.0 ANTARCTIC
165.0 -65.5 PLATE
EOF
# Add legend
gmt pslegend -R -J -Dx0.5/-2.3+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Hadal trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c magenta 0.01c 1.0c Transform lines
S 0.3c t 0.3c red 0.01c 1.0c Volcanoes
S 0.5c v 0.8c red 0.02c 1.0c Plate movements, cm/yr
S 0.3c - 0.8c - 1.0p,deeppink 1.0c Fracture zones
S 0.3c - 0.8c - 3.0p,red 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 1.0p,gold1,- 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,yellow,- 1.0c Tectonic slabs
S 0.3c c 0.2c mediumspringgreen@90 0.01c,mediumspringgreen 1.0c Magnetic lineation picks
S 0.3c c 0.2c orange 0.01c 1.0c Ophiolites
S 0.3c r 0.7c pink1@50 0.01c 1.0c Large igneous provinces
FIN
# Step-11. Add GMT logo
gmt logo -Dx6.5/-3.6+o0.1i/0.1i+w2c -O -K >> $ps
# Step-12. Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.0 -Y20.0c -N -O \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.0 11.0 GEBCO DEM Global Relief Model 15 arc sec resolution grid
EOF
# Step-13. Convert to image file using GhostScript
gmt psconvert Geol_HPT.ps -A2.5c -E720 -Tj -Z
