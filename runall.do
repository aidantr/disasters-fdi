/********************************************************************************
Runall for "Natural Disasters, Intra-National FDI Spillovers, and Economic
Divergence: Evidence from India" by Friedt and Toner-Rodgers (2022)

Date: 04/12/2022

********************************************************************************/

clear all

cd "/Users/aidan/Dropbox/India_FDI/friedt_toner-rodgers_replication/"

log using replication, replace

* ------------------------------------------------------------
* BUILD DATASET
* ------------------------------------------------------------

do _2code/_1build_data/build_census_data
do _2code/_1build_data/build_state_indicators
do _2code/_1build_data/build_disaster_risk
do _2code/_1build_data/merge_main

* ------------------------------------------------------------
* ANALYSIS
* ------------------------------------------------------------

*tables


do _2code/_2analysis/table1
do _2code/_2analysis/table2_baseline
*do _2code/_2analysis/table2_spatial
do _2code/_2analysis/table3



do _2code/_2analysis/table4
do _2code/_2analysis/tableB1

*figures

do _2code/_2analysis/figure2
do _2code/_2analysis/figure4
do _2code/_2analysis/figure5
do _2code/_2analysis/figureB1
do _2code/_2analysis/figureB2


translate replication.smcl replication.pdf
