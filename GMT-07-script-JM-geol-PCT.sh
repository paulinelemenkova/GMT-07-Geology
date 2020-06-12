#!/bin/sh
# Purpose: Map of geological settings (here: Peru-Chile trench).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Generate a file
ps=Geol_PCT.ps
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 0.5c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thin,white \
    MAP_GRID_PEN_SECONDARY thinner,white \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 7p,Helvetica,dimgray \
    FONT_LABEL 7p,Helvetica,dimgray
# Overwrite defaults of GMT
grdcut earth_relief_01m.grd -R270/300/-55/0 -Gpct_relief.nc
gmtdefaults -D > .gmtdefaults
# Cut off the relief map from ETOPO5
#gmt grdcut GEBCO_2019.nc -R177/193/-37/-13.5 -Gtkt_relief_GEBCO.nc -V
#gmt grdimage tkt_relief_GEBCO.nc -Cibcso -R177/193/-37/-13.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
#gmt grdimage earth_relief_01m.grd -Cibcso -R177/193/-37/-13.5 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps
gmt grdimage earth_relief_01m.grd -Cearth -R270/300/-55/0 -JM4.5i -P -I+a15+ne0.75 -Xc -K > $ps
# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological and tectonic setting of the Peru-Chile Trench region" \
    -Bpxg8f4a8 -Bpyg10f5a4 -Bsxg4 -Bsyg5 \
    -Lx9c/-3.0c+c50+w600k+l"Mercator Cylindrical Projection. Scale (km)"+f \
    -UBL/-0.2c/-2.9c -O -K >> $ps
# Add bathymetric contours
gmt grdcontour pct_relief.nc -R -J -C1000 -W0.2p -O -K >> $ps
# Add geological lines and points
#gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.2c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -St0.4c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,black -Ggreen -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2001.points.gmt -Sc0.1c -Gyellow -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,magenta -Gmagenta -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,violet -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,orange -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_samerica.txt -W0.6p,red,- -O -K >> $ps
# Add magnetic lineation picks
#gmt psxy -R -J GSFML.global.picks.gmt -Sc0.1c -Wthin,yellow -Gpurple -O -K >> $ps
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.1c -Wthin,yellow -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
# texts
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB+a-350 -Gwhite@40 -Wthinnest >> $ps << EOF
284.0 -25.0 Taltal Ridge
283.0 -26.5 Copiapo Ridge
276.0 -34.0 Juan Fernandez Ridge
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB+a-330 -Gwhite@40 -Wthinnest >> $ps << EOF
280.0 -21.0 Nazca FZ
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+f10p,Palatino-Roman,black+jTR+a-300 -Gwhite@40 -Wthinnest >> $ps << EOF
285.0 -33.5 O'Higgins Guyot
EOF
gmt pstext -R -J -X0.0c -Y0.0c -N -O -K \
-F+f12p,Palatino-Roman,black+jLB+a-70 -Gwhite@40 -Wthinnest >> $ps << EOF
277.0 -41.5 Chile Rise
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Times-Roman,black+jLB+a-310 -Gwhite@40 -Wthinnest >> $ps << EOF
278.0 -19.0 Nazca Ridge
283.0 -24.5 Iquique Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+f13p,Times-Roman,black+jLB+a-45 -Gwhite@40 -Wthinnest >> $ps << EOF
289.0 -15.0 Central
EOF
gmt pstext -R -J -N -O -K \
-F+f13p,Times-Roman,black+jLB+a-85 -Gwhite@40 -Wthinnest>> $ps << EOF
292.0 -19.0 Andes
EOF
gmt pstext -R -J -N -O -K \
-F+f12p,Times-Roman,black+jLB -Gwhite@40 -Wthinnest >> $ps << EOF
271.0 -25.0 Easter Seamount Chain
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,Times-Roman,black+jLB -Gwhite@30 -Wthinnest >> $ps << EOF
290.0 -6.0 South America
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,Times-Roman,red+jLB -Gwhite@40 >> $ps << EOF
275.0 -29.0 Nazca Plate
275.0 -49.0 Antarctic Plate
292.0 -36 South America
292.0 -37 Plate
EOF
gmt psxy -R -J TP_Nasca.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Antarctic.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_South_Am.txt -L -Wthick,red -O -K >> $ps
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Gvioletred1@30 -W1.0p -O -K << EOF >> $ps
275.0 -12 50 2c
282.5 -28 20 2c
279.0 -40 5 2c
EOF
# Step-7. Add color legend
gmt psscale -Dg263.0/-55+w9.7i/0.4c+v+o0.3/0i+ml \
    -Rpct_relief.nc -J -Cearth.cpt \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_ANNOT_OFFSET=0.1c \
    -Baf+l"Color scale legend: depth and height elevations (m)" \
    -I0.2 -By+lm -O -K >> $ps
# Add legend
gmt pslegend -R -J -Dx-2.5/-2.2+w12.5c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Peru-Chile Trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c t 0.3c red 0.01c 1.0c Volcanoes
S 0.3c v 0.9c violetred1 0.02c 1.0c Plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.8c - 1.0p,red 1.0c Tectonic plates bordes
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow 0.01c 1.0c Magnetic lineation picks
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous provinces
S 0.3c c 0.2c magenta 0.01c 1.0c Ophiolites
FIN
# Add subtitle
gmt pstext -R -J -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
266.5 17.7 Bathymetry: ETOPO 1 arc min Global Relief Model
EOF
# Add GMT logo
gmt logo -R -J -Dx4.0/-4.0+o0.1i/0.1i+w2c -O >> $ps
# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_PCT.ps -A1.5c -E720 -Tj -P -Z
