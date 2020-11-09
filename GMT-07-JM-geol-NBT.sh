#!/bin/sh
# Purpose: Map of geological settings (here: New Britain - San Cristobal trenches).
# Mercator prj. GMT modules: gmtset, gmtdefaults, makecpt, grdcut, grdinfo, pscoast, psbasemap, grdcontour, project, psxy, pslegend, pstext, logo, psconvert
# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN dimgray \
    MAP_FRAME_WIDTH 0.1c \
    MAP_TITLE_OFFSET 1.0c \
    MAP_ANNOT_OFFSET 0.1c \
    MAP_TICK_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_PRIMARY thinner,dimgray \
    MAP_GRID_PEN_SECONDARY thinnest,dimgray \
    FONT_TITLE 12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY 7p,Helvetica,dimgray \
    FONT_LABEL 7p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

# Generate a file
ps=Geol_NBT.ps

# Cut off the relief map from SRTM
gmt grdimage topo15.grd -Cglobe -R140/162/-15/0 -JM16c -P -I+a15+ne0.75 -Xc -K > $ps

# Add elemens of basemap: title, grids, rose, scale, time stamp
gmt psbasemap -R -J \
    --MAP_FRAME_AXES=wESN \
    --MAP_TITLE_OFFSET=1.0c \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    --FONT_LABEL=7p,Helvetica,dimgray \
    -B+t"Geological and tectonic setting of the New Britain - San Cristobal trenches" \
    -Bpxg8f2a4 -Bpyg6f3a3 -Bsxg4 -Bsyg3 \
    -Lx12.6c/-2.8c+c50+w400k+l"Mercator projection. Scale (km)"+f \
    -UBL/-0.2c/-2.9c -O -K >> $ps
    
# Add bathymetric contours
gmt grdcontour @nbt_relief.nc -R -J -C2000 \
    -A2000+f7p,Times-Roman -S4 -T+d15p/3p \
    -W0.5p,blue -O -K >> $ps
    
# Add geological lines and points
gmt makecpt -Crainbow -T0/700/50 -Z > rain.cpt
gmt psxy -R -J volcanoes.gmt -St0.35c -Gred -Wthinnest -O -K >> $ps
gmt psxy -R -J ridge.gmt -Sf0.5c/0.2c+l+t -Wthinnest,green -Ggreen -O -K >> $ps
#gmt psxy -R -J LIPS.2011.gmt -L -G0.1c+bred+f-+r300 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink@50 -Wthinnest,red -O -K >> $ps
gmt psxy -R -J LIPS.2001.points.gmt -Sc0.2c -Gyellow -O -K >> $ps
gmt psxy -R -J hotspots.gmt -Sc0.3c -Gred -O -K >> $ps
gmt psxy -R -J transform.gmt -Sf0.5c/0.15c+l+t -Wthin,olivedrab1 -Golivedrab1 -O -K >> $ps
# Add fracture zones and magnetic anomalies
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,violet -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,orange -O -K >> $ps
# Add slab contours
gmt psxy -R -J SC_solomons.txt -W0.6p,red,- -O -K >> $ps
gmt psxy -R -J SC_nbritain.txt -W0.6p,red,- -O -K >> $ps
# tectonic plates
gmt psxy -R -J TP_Australian.txt -L -Wthickest,sienna2 -O -K >> $ps
gmt psxy -R -J TP_Pacific.txt -L -Wthickest,sienna2 -O -K >> $ps
gmt makecpt -Crainbow -T0/100/1 -Z > steps.cpt
#gmt psxy -R -J PB2002_steps.dat.txt -i3,2,6 -Sc0.1c -Wthickest,red -O -K >> $ps
gmt psxy -R -J PB2002_steps.dat.txt -i3,2,6 -Sc0.1c -Csteps.cpt -Wthinnest -O -K >> $ps
# Add magnetic lineation picks
gmt psxy -R -J GSFML.global.picks.gmt -Sc0.2c -Wthinnest,yellow -O -K >> $ps
gmt psxy -R -J trench.gmt -Sf1.5c/0.2c+l+t -Wthick,yellow -Gyellow -O -K >> $ps
gmt psxy -R -J @tut_quakes.ngdc -Wfaint -i4,3,5,6s0.1 -h3 -Scc -Cquakes.cpt -O -K >> $ps
gmt psxy -R -J ophiolites.gmt -Sc0.1c -Wthinnest,magenta -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K -F+f9p,Palatino-Roman,black+jLB -Gwhite@30 >> $ps << EOF
145.0 -1.5 North Bismark Sea Microplate
146.5 -4.3 South Bismark Sea Microplate
151.2 -7.8 SOLOMON SEA
151.7 -8.3 PLATE
157 -2.7 PACIFIC PLATE
157 -5.0 Ontong Java Plateu
141 -1.0 CAROLINE PLATE
154.1 -10 Woodlark Basin
156.0 -12.9 Louisiade
156.0 -13.3  Plateau
EOF
gmt pstext -R -J -N -O -K \
    -F+f9p,Palatino-Roman,red+jLB+a-338 -Gwhite@30 -C10% >> $ps << EOF
149.4 -7.8 New Britain Trench
EOF
gmt pstext -R -J -N -O -K \
    -F+f9p,Palatino-Roman,red+jLB+a-30 -Gwhite@30 -C10% >> $ps << EOF
155.5 -8.3 S a n  C r i s t o b a l  T r e n c h
EOF
gmt pstext -R -J -N -O -K \
-F+f11p,Times-Roman,darkblue+jLB -Gwhite@30 >> $ps << EOF
148.2 -12.2 Coral Sea
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Times-Roman,black+jLB -Gwhite@30 -Wthinnest,darkbrown >> $ps << EOF
140.5 -6.5 PAPUA NEW GUINEA
140.5 -7.5 Fly Platform
142.2 -12.5 AUSTRALIAN PLATE
EOF
# Arrows of tectonic plates movements
gmt psxy -R -J -Sv0.5c+bt+ea -Gdarkred@30 -W1.0p -O -K << EOF >> $ps
159.0 -2.0 160 1.5c
145.0 -12.0 60 1.5c
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica,red+jLB >> $ps << EOF
159.3 -2.2 66-67 mm/yr
EOF
gmt pstext -R -J -N -O -K \
-F+f9p,Helvetica,yellow+jLB >> $ps << EOF
145.5 -12.0 63 mm/yr
EOF

# Add color legend
gmt psscale -Dg137.0/-15+w11.0c/0.4c+v+o0.3/0i+ml -R -J -Cglobe \
    --FONT_LABEL=8p,Helvetica,dimgray \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Ba2000g1000f100+l"Color scale 'globe': global bathymetry/topography relief [R=-10000/10000, H=0, C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps
    
# Add legend
gmt pslegend -R -J -Dx0.5/-2.2+w14.0c+o0.1/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT_ANNOT_PRIMARY=8p -O -K << FIN >> $ps
N 3
S 0.3c f+l+t 0.7c yellow 0.01c 1.0c Hadal trench
S 0.3c f+l+t 0.7c green 0.01c 1.0c Ridge
S 0.3c f+l+t 0.7c olivedrab1 0.01c 1.0c Transform lines
S 0.3c t 0.2c red 0.01c 1.0c Volcanoes
S 0.3c v 0.8c red 0.02c 1.0c Tectonic plates movements
S 0.3c - 0.8c - 0.5p,magenta 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,sienna2 1.0c Tectonic plates boundaries
S 0.3c - 0.7c - 0.5p,violet 1.0c Magnetic anomaliy lines
S 0.3c - 0.7c - 0.6p,red,- 1.0c Tectonic slabs
S 0.3c c 0.2c yellow 0.01c 1.0c Magnetic lineation picks
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous provinces
S 0.3c c 0.1c magenta 0.01c 1.0c Ophiolites
FIN

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y5.2c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
3.5 10.0 Base map: SRTM Global Relief Model 15 arc sec grid.
EOF

# Add GMT logo
gmt logo -R -J -Dx5.0/0.0c+o1.6c/-8.4c+w2c -O >> $ps

# Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert Geol_NBT.ps -A1.0c -E720 -Tj -P -Z
