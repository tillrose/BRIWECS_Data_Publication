
<!-- README.md is generated from README.Rmd. Please edit that file -->

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

## A collaborative work on a data publication for the seasons 2015–2019 of the BRIWECS consortium

<!-- [![License: GPL-3](https://img.shields.io/badge/License-GPL3-orange)](https://www.r-project.org/Licenses/) -->

## insturctution

1.  open `BRIWECS_Data_Publication.RProject`
2.  open `scripts/run.R`
3.  run all `Ctrl + Alt + R` <img
    src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/Instruction.PNG"
    data-fig-align="center" />

## directory tree

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## trait table

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
trait name in data descriptor
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
biomass 50 cm cut
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
harvest index
</td>
<td style="text-align:left;">
biomass 50 cm cut
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
kernels per spike
</td>
<td style="text-align:left;">
biomass 50 cm cut
</td>
<td style="text-align:left;">
KperSpike_bio
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
plant height
</td>
<td style="text-align:left;">
biomass 50 cm cut
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
biomass 50 cm cut
</td>
<td style="text-align:left;">
Seedyield_bio
</td>
<td style="text-align:left;">
28.3~1815
</td>
<td style="text-align:left;">
g/m^2
</td>
</tr>
<tr>
<td style="text-align:left;">
spike number
</td>
<td style="text-align:left;">
biomass 50 cm cut
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
thousand kernel weight
</td>
<td style="text-align:left;">
biomass 50 cm cut
</td>
<td style="text-align:left;">
TKW_bio
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
14.2~856
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
number of kernels per unit area
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
Kernel
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
0~22.2
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
0~141.6
</td>
<td style="text-align:left;">
dt/ha
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
8.9~729.7
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
thousand kernel weight
</td>
<td style="text-align:left;">
whole plot
</td>
<td style="text-align:left;">
TKW
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

## previous publications

<div id="fig-papers" layout-nrow="2">

[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Kai2019.PNG"
id="fig-kai" class="lightbox" width="230" height="300"
alt="Voss-Fels 2019" />](https://www.nature.com/articles/s41477-019-0445-5)

[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Rose_2019.png"
id="fig-till" width="230" height="300" alt="Rose 2019" />](https://www.frontiersin.org/journals/plant-science/articles/10.3389/fpls.2019.01521/full)

[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Carolin_2020.png"
id="fig-carolin" width="230" height="300" alt="Lichthardt 2020" />](https://www.frontiersin.org/journals/plant-science/articles/10.3389/fpls.2019.01771/full)

[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Zetzsche_2020.png"
id="fig-holger" width="230" height="300" alt="Zetzsche 2020" />](https://www.nature.com/articles/s41598-020-77200-0)

[<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/previous_paper/Sabir_2023.png"
id="fig-kahdija" width="230" height="300" alt="Sabir 2023" />](https://www.nature.com/articles/s41477-023-01516-8)

</div>

## overview visualizations

<figure>
<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/fig0.png"
data-fig-align="center"
alt="Fig0. Experiments location and soil properties." />
<figcaption aria-hidden="true">Fig0. Experiments location and soil
properties.</figcaption>
</figure>

<figure>
<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/fig1.png"
data-fig-align="center"
alt="Fig1. An overview of MET data descriptor of winter wheat containing 24 traits collected across six locations in Germany (GGE, HAN, KAL, KIE, QLB, RHH) with nine managements (HN_WF_RO, LN_NF_IR, HN_NF_IR, HN_WF_IR, HN_WF_RF, LN_WF_IR, HN_NF_RF, LN_NF_RF and LN_WF_RF) during six years (2015-2020)." />
<figcaption aria-hidden="true">Fig1. An overview of MET data descriptor
of winter wheat containing 24 traits collected across six locations in
Germany (GGE, HAN, KAL, KIE, QLB, RHH) with nine managements (HN_WF_RO,
LN_NF_IR, HN_NF_IR, HN_WF_IR, HN_WF_RF, LN_WF_IR, HN_NF_RF, LN_NF_RF and
LN_WF_RF) during six years (2015-2020).</figcaption>
</figure>

<figure>
<img
src="https://github.com/tillrose/BRIWECS_Data_Publication/blob/main/figure/data_point.png"
data-fig-align="center"
alt="Fig2.Scatter plot of 29 combinations of location by year by management (LxYxM) versus 228 genotypes for 24 traits." />
<figcaption aria-hidden="true">Fig2.Scatter plot of 29 combinations of
location by year by management (LxYxM) versus 228 genotypes for 24
traits.</figcaption>
</figure>
