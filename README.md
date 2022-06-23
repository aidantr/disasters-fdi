# REPLICATION INSTRUCTIONS FOR FRIEDT AND TONER-RODGERS (2022) 

REPOSITORY STRUCTURE:
  - _1data/raw/: contains raw data files
 -  _1data/clean/: contains data files used in the analysis 
  - _2codes/_1build: contains codes to build main panel from raw data
  - _2codes/_analysis: contains codes to replicate all tables and figures 
  - _3results: stores outputs for all tables and figures in the main text and appendix

MAIN CODE FILES TO RUN:
  1. run_all.do to execute all Stata code
  2. figure1.R to generate maps in figure 1

RAW DATA:
  - FDI data from Reserve Bank of India regional branches
  - Natural disaster data from the Dartmouth Flood Observatory (DFO)  and Geocoded Disasters (GDIS)  Dataset
  - State-level principal economic indicators from the Indian Census
  - Regional controls from the the Indian Ministry of Statistics 
  - Spatial data on India geography

REQUIRED STATA PACKAGES:
  - blindschemes
  - boottest
  - distinct
  - esttout
  - gtools
  - geodist
  - outtable
  - xmlse
  
REQUIRED R PACKAGES:
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

TIME: 
  - The code takes ~1-2 hours to run, start to finish. The main bottleneck is the iterations of the wild cluster bootstrapped standard errors.
