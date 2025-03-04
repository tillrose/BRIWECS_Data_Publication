
<!-- README.md is generated from README.Rmd. Please edit that file -->

[![Paper-publication](https://img.shields.io/badge/Scientific-Data-darkred)](https://www.nature.com/articles/s41597-024-04332-7)
[![Figshare-repository](https://img.shields.io/badge/Figshare-10.6084/m9.figshare.27910269-yellow)](https://figshare.com/s/6182dd7384bef2dbd9d5)
[![Analysis-workflow](https://img.shields.io/badge/Analysis-workflow-darkorange)](https://github.com/Illustratien/Scientific_Data_Analyis)
[![Website -
pkgdown](https://img.shields.io/badge/data-visulaization-blue)](https://tillrose.github.io/BRIWECS_Data_Publication/data_overview.html)
[![Project-website](https://img.shields.io/badge/Project-website-darkgreen)](https://www.igps.uni-hannover.de/de/forschung/forschungsprojekte/detailansicht/projects/forschungsverbund-briwecs)

<figure>
<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/BRIWECS_logo.png"
data-fig-align="right"
alt="Breeding Innovations in Wheat for Efficient Cropping Systems (BRIWECS)." />
<figcaption aria-hidden="true">Breeding Innovations in Wheat for
Efficient Cropping Systems (BRIWECS).</figcaption>
</figure>

# [Multi-environment field trials for wheat yield, stability and breeding progress in Germany](https://www.nature.com/articles/s41597-024-04332-7)

<!-- [![License: GPL-3](https://img.shields.io/badge/License-GPL3-orange)](https://www.r-project.org/Licenses/) -->

## previous publications

[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Kai2019.PNG"
id="fig-kai" class="lightbox" width="160" height="220"
alt="Voss-Fels 2019" />](https://www.nature.com/articles/s41477-019-0445-5)
[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Rose_2019.png"
id="fig-till" width="160" height="220" alt="Rose 2019" />](https://www.frontiersin.org/journals/plant-science/articles/10.3389/fpls.2019.01521/full)
[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Carolin_2020.png"
id="fig-carolin" width="160" height="220" alt="Lichthardt 2020" />](https://www.frontiersin.org/journals/plant-science/articles/10.3389/fpls.2019.01771/full)
[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Zetzsche_2020.png"
id="fig-holger" width="160" height="220" alt="Zetzsche 2020" />](https://www.nature.com/articles/s41598-020-77200-0)
[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Sabir_2023.png"
id="fig-kahdija" width="160" height="220" alt="Sabir 2023" />](https://www.nature.com/articles/s41477-023-01516-8)

## instruction for pre-processing scripts

1.  open `BRIWECS_Data_Publication.RProject`
2.  open `scripts/run.R`
3.  run all the lines `Ctrl + Alt + R`

***Note: Part of data the traits in Location KAL, Phase II (2018-2020)
is still under data-preparation, will be updated soon***

## directory tree

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## trait table

    ## Total 563,4K observations (removed outliers)

<table class=" lightable-classic-2" style="font-family: &quot;Arial Narrow&quot;, &quot;Source Sans Pro&quot;, sans-serif; width: auto !important; float: right; margin-left: 10px;">
<caption>
Table 1. Trait names, sources, ranges and units
</caption>
<thead>
<tr>
<th style="text-align:left;">
trait full name
</th>
<th style="text-align:left;">
trait source
</th>
<th style="text-align:left;">
column name
</th>
<th style="text-align:left;">
trait range
</th>
<th style="text-align:left;">
unit
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
above-ground dry biomass
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
Biomass_bio
</td>
<td style="text-align:left;">
0~3495
</td>
<td style="text-align:left;">
g/m^2
</td>
</tr>
<tr>
<td style="text-align:left;">
grains per spike
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
Grain_per_spike_bio
</td>
<td style="text-align:left;">
3.6~146.7
</td>
<td style="text-align:left;">
Nbr
</td>
</tr>
<tr>
<td style="text-align:left;">
harvest index
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
Harvest_Index_bio
</td>
<td style="text-align:left;">
0.1~0.8
</td>
<td style="text-align:left;">
</td>
</tr>
<tr>
<td style="text-align:left;">
plant height
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
Plantheight_bio
</td>
<td style="text-align:left;">
40~145
</td>
<td style="text-align:left;">
cm
</td>
</tr>
<tr>
<td style="text-align:left;">
grain yield
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
Seedyield_bio
</td>
<td style="text-align:left;">
28.3~1815
</td>
<td style="text-align:left;">
g/m^2 @100% dry mass
</td>
</tr>
<tr>
<td style="text-align:left;">
spike number
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
Spike_number_bio
</td>
<td style="text-align:left;">
48~1390
</td>
<td style="text-align:left;">
Nbr /m^2
</td>
</tr>
<tr>
<td style="text-align:left;">
thousand grain weight
</td>
<td style="text-align:left;">
50 cm cut
</td>
<td style="text-align:left;">
TGW_bio
</td>
<td style="text-align:left;">
4.7~77.8
</td>
<td style="text-align:left;">
g
</td>
</tr>
<tr>
<td style="text-align:left;">
day when 75% of the ears are visible
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
BBCH59
</td>
<td style="text-align:left;">
123~181
</td>
<td style="text-align:left;">
days of year
</td>
</tr>
<tr>
<td style="text-align:left;">
day when 75% hard dough
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
BBCH87
</td>
<td style="text-align:left;">
175~213
</td>
<td style="text-align:left;">
days of year
</td>
</tr>
<tr>
<td style="text-align:left;">
above-ground dry biomass
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Biomass
</td>
<td style="text-align:left;">
14.2~732.8
</td>
<td style="text-align:left;">
dt/ha
</td>
</tr>
<tr>
<td style="text-align:left;">
crude protein percentage per grain dry mass
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Crude_protein
</td>
<td style="text-align:left;">
6.2~21.3
</td>
<td style="text-align:left;">
%
</td>
</tr>
<tr>
<td style="text-align:left;">
leaf tan spot
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
DTR
</td>
<td style="text-align:left;">
0~100
</td>
<td style="text-align:left;">
% leaf area
</td>
</tr>
<tr>
<td style="text-align:left;">
falling number
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Falling_number
</td>
<td style="text-align:left;">
60~700
</td>
<td style="text-align:left;">
s
</td>
</tr>
<tr>
<td style="text-align:left;">
fusarium head blight
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Fusarium
</td>
<td style="text-align:left;">
0~27
</td>
<td style="text-align:left;">
% spike
</td>
</tr>
<tr>
<td style="text-align:left;">
number of grains per unit area
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Grain
</td>
<td style="text-align:left;">
19.2~5851.5
</td>
<td style="text-align:left;">
Nbr x 10^5/ha
</td>
</tr>
<tr>
<td style="text-align:left;">
leaf rust
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Leaf_rust
</td>
<td style="text-align:left;">
0~90
</td>
<td style="text-align:left;">
% leaf area
</td>
</tr>
<tr>
<td style="text-align:left;">
leaf powdery mildew
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Powdery_mildew
</td>
<td style="text-align:left;">
0~100
</td>
<td style="text-align:left;">
% leaf area
</td>
</tr>
<tr>
<td style="text-align:left;">
grain protein yield
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Protein_yield
</td>
<td style="text-align:left;">
0.005~22.2
</td>
<td style="text-align:left;">
dt/ha
</td>
</tr>
<tr>
<td style="text-align:left;">
sedimentation
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Sedimentation
</td>
<td style="text-align:left;">
2.1~95.4
</td>
<td style="text-align:left;">
ml
</td>
</tr>
<tr>
<td style="text-align:left;">
grain yield
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Seedyield
</td>
<td style="text-align:left;">
0.05~141.6
</td>
<td style="text-align:left;">
dt/ha @100% dry mass
</td>
</tr>
<tr>
<td style="text-align:left;">
leaf spot
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Septoria
</td>
<td style="text-align:left;">
0~80
</td>
<td style="text-align:left;">
% leaf area
</td>
</tr>
<tr>
<td style="text-align:left;">
above ground biomass substracted by grain yield
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Straw
</td>
<td style="text-align:left;">
8.9~625.4
</td>
<td style="text-align:left;">
dt/ha
</td>
</tr>
<tr>
<td style="text-align:left;">
stripe rust
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Stripe_rust
</td>
<td style="text-align:left;">
0~100
</td>
<td style="text-align:left;">
% leaf area
</td>
</tr>
<tr>
<td style="text-align:left;">
thousand grain weight
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
TGW
</td>
<td style="text-align:left;">
2.6~69.5
</td>
<td style="text-align:left;">
g
</td>
</tr>
</tbody>
</table>
