# GMT Geology — Regional Geological and Tectonic Setting Maps

A collection of over 35 GMT (Generic Mapping Tools) shell scripts producing detailed regional geological and tectonic setting maps of ocean trenches, seas and margins. Each map combines a relief basemap with multiple geological and tectonic vector overlays, richly annotated with structural features, plate names and a legend. The scripts have been used to generate figures across the author's marine-geological and geophysical publications.

## What the scripts do

Each script builds a complete geological / tectonic map, typically chaining:

- clipping a relief subset (grdcut) and drawing coastlines with land/sea colouring (pscoast)
- bathymetric contours with annotated index contours (grdcontour)
- geological and tectonic vector overlays (psxy): subduction trenches, mid-ocean ridges and transform faults with front symbols, ophiolites, volcanoes, Large Igneous Provinces (LIPs)
- seafloor fabric and magnetic lineation picks from GSFML, and subducting-slab depth contours
- tectonic plate-motion vectors (psxy -Sv)
- structural and geographic annotations: plate names, blocks, faults, ridges, gulfs, trenches (pstext)
- a legend of the mapped features (pslegend), scale bar, grid, directional rose (psbasemap) and GMT logo (logo)
- export to raster (psconvert) at high resolution

Regional map projections are chosen per area (Lambert conformal conic, oblique/transverse Mercator, polyconic, etc.).

## Data sources

- Relief / bathymetry: ETOPO (1 and 5 arc-minute), GEBCO
- Seafloor fabric and magnetic lineation picks: GSFML (SOEST, University of Hawaii)
- Tectonic vectors: trench / ridge / transform lines, ophiolites, volcanoes, LIPs compilations, subducting-slab contours
- Earthquakes (where used): IRIS / NGDC catalogues (quakes_*.gmt / .ngdc)
- Coastlines: GSHHG via GMT

## File naming

Scripts follow GMT-...-geol-XX.sh, where XX is an ocean-trench, sea or country tag (e.g. MAT = Middle America Trench, KKT = Kuril-Kamchatka Trench, IBT = Izu-Bonin Trench, PSB = Philippine Sea Basin, RS = Red Sea, AS = Arabian Sea, YE = Yemen, Pakistan). A JL / JM / JY / JT prefix denotes the map projection variant used.

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash/sh)
- The relevant relief grid and geological / tectonic vector data files available locally

## Usage

Place the required grid and vector files in the working directory, adjust the -R region and -J projection at the top of the chosen script, then run:

    bash GMT-07-script-JL-geol-MAT.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's marine-geological and geophysical papers; please cite the specific article a given map appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
