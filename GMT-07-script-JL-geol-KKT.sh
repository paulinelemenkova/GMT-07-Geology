#!/bin/sh
# Purpose: Map of geological settings (here: Kuril-Kamchatka Trench).
# Lambert conic conformal prj.
# GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# Step-1. Generate a file
ps=GMT_JL_geol_KKT.ps
# Step-2. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_SECONDARY thinnest,dimgray \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 7p,Helvetica,dimgray \
    FONT_LABEL 7p,Helvetica,dimgray \
# Step-3. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-3. Color palette table
gmt makecpt -Cred,green,blue -T0,70,300,10000 > quakes.cpt
# Step-4. Cut off the relief map from ETOPO5
gmt grdcut earth_relief_05m.grd -R140/170/40/60 -Gkkt_relief.nc -V
gmt grdinfo @kkt_relief.nc
# Step-5. Add coastlines; color areas: land-green water-blue
gmt pscoast -R140/170/40/60 -JL155/50/45/55/6i -P \
    -W0.1p -Gpapayawhip -Slightcyan -Df -K > $ps
# Step-6. Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    -B+t"Geological settings in the Kuril-Kamchatka area" \
    -Bpxg4f2a5 -Bpyg2f1a2 -Bsxg4 -Bsyg4\
    -Lx5.1i/-0.8c+c50+w1000k+l"Lambert conic conformal projection. Scale at 50\232N, km"+f \
    -O -K >> $ps
# Step-10. Add directional rose
gmt psbasemap -R -J \
    --FONT=6p,Palatino-Roman,dimgray \
    --MAP_TITLE_OFFSET=0.3c \
    -Tdg142.5/57.5+w0.5c+f2+l \
    -UBR/15c/-54p -O -K >> $ps
#-UBR/-15p/-40p -O -K >> $ps
# Step-7. Add bathymetric contours
gmt grdcontour @kkt_relief.nc -R -J -C500 \
    -A2000+f7p,Times-Roman -S4 -T+d15p/3p \
    -O -K >> $ps
# Step-8. Add earthquake points
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
# Step-9. Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,red -Gred -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,darkcyan -Gpurple -O -K >> $ps
#gmt psxy -R -J LIPS.2011.gmt -L -G0.1c+bred+f-+r300 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.2c -Gmagenta -Wthinnest -O -K >> $ps
gmt psxy -R -J volcanoes.gmt -Sc0.2c -Gpurple -Wthinnest -O -K >> $ps
# Step-10. Add tectonic slab contours
gmt makecpt -Cplasma -T0/700/50 -Z > rain.cpt
#gmt psxy -R -J SC_marjapkur.txt -S-0.2cm -Crain.cpt -O -K >> $ps
gmt psxy -R -J SC_marjapkur.txt -Sp1p -Crain.cpt -W -O -K >> $ps
# Step-11.
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,yellowgreen -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,gold1 -O -K >> $ps
# Step-12. Add 1st legend
#gmt pslegend -R -J -Dx0.0/-2.6+w5.3c+o-1.0/0.5c
gmt pslegend -R0/10/0/15 -JX1/1 -X0.5c -Y0.2c \
    -F+pthick+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << EOF >> $psxa
S 0.3c c 0.3c red 0.01c 0.5c Shallow depth (0-100 km)
S 0.3c c 0.3c green 0.01c 0.5c Intermediate depth (100-300 km)
S 0.3c c 0.3c blue 0.01c 0.5c Very deep (> 300 km)
EOF
# Step-12. Add 2nd legend
gmt pslegend -R -J -Dx0.0/-2.6+w4.5c+o13.5/14.5c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
S 0.3c f+l+t 0.7c gold1 0.01c 1.0c Fracture zones
S 0.3c f+l+t 0.7c yellowgreen 0.01c 1.0c Magnetic anomalies
S 0.3c p 0.05c orange 0.01c 1.0c Tectonic slabs
S 0.3c f+l+t 0.7c red 0.01c 1.0c Trench
S 0.3c f+l+t 0.7c darkcyan 0.01c 1.0c Ridge
S 0.3c c 0.2c magenta 0.01c 1.0c Ophiolites
S 0.3c c 0.2c purple 0.01c 1.0c Volcanoes
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous provinces
FIN
# Step-13. Add text
gmt pstext -R -J -Dx0.0/0.0 -N -O -K \
    -F+f8p,Palatino-Roman,black+jLB >> $ps << FIN
139.0 37.9 Earthquakes magnitude and seismicity
FIN
# Step-14. Add text
gmt pstext -R -J -N -O -K \
    -F+f7p,Palatino-Roman,dimgray+jLB >> $ps << END
160.0 38.3 Standard paralles at 45 and 55 N
END
# Step-15. Add subtitle
gmt pstext -R -J -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
142.0 61.4 Bathymetry: ETOPO 5 arc min Global Relief Model
EOF
# Step-16. generate point and angle of great circle
gmt project -C151.6E/45.8N -A43 -G10 -L-3/7 > great_circle.txt
# Step-17. optional: plot a thick ribbon-like line of circle path
#gmt psxy -R -J -Wfattest,white -DjBL great_circle.txt -O -K  >> $ps
# Step-18. Add text along the curved path
gmt psxy -R -J -Wthick great_circle.txt \
    -Sqn1:+f10p,Palatino-Roman,red+l"Kuril-Kamchatka Trench"+gwhite+ap+v -O -K >> $ps
# Step-19. Add GMT logo
gmt logo -R -J -Dx5.0/0.0c+o1.8c/-2.0c+w2c -O >> $ps
# Step-20. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert GMT_JL_geol_KKT.ps -A0.2c -E720 -Tj -P -Z
