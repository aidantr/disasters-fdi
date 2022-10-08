# Replication Package for Friedt and Toner-Rodgers (2022) 

This repository contains all the code to replicate the results of [Natural Disasters, Intra-National FDI Spillovers, and Economic Divergence: Evidence from India,](https://www.sciencedirect.com/science/article/abs/pii/S0304387822000438) published in the _Journal of Development Economics._ The code is written in Stata and R.

## How to run
  1. `run_all.do` executes all Stata code
  2. `figure1.R` generates maps in figure 1

## Repository structure
  - `_1data/raw/` contains raw data files
 -  `_1data/clean/` contains data files used in the analysis 
  - `_2codes/_1build` contains codes to build main panel from raw data
  - `_2codes/_analysis` contains codes to replicate all tables and figures 
  - `_3results` stores outputs for all tables and figures in the main text and appendix

## Raw data
  - FDI data from Reserve Bank of India regional branches
  - Natural disaster data from the Dartmouth Flood Observatory (DFO)  and Geocoded Disasters (GDIS)  Dataset
  - State-level principal economic indicators from the Indian Census
  - Regional controls from the the Indian Ministry of Statistics 
  - Spatial data on Indian geography

## Required Stata packages
  - blindschemes
  - boottest
  - distinct
  - esttout
  - gtools
  - geodist
  - outtable
  - xmlse

## Required R packages
  - Cairo
  - dplyr  
  - ggplot2 
  - ggmap 
  - gpclib
  - gridExtra   
  - maps 
  - maptools 
  - mapproj
  - RColorBrewer 
  - rgdal 
  - rgeos 
  - scales 
  - sp 
  - viridis 

## Computation time: 
The code takes ~4-6 hours to run, start to finish. The main bottleneck is the iterations of the wild cluster bootstrapped standard errors.
