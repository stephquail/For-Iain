###This script runs the data extraction and summary for all stages of the PIT & Devaluation task

## This runs the data extraction scripts for the instrumental, transfer and devaluation parts of the PIT and Deval task. 
## Extraction of PAVLOVIAN TRAINING to come.

## If this is the first time you are running this, check that the appropriate packages have all been installed.
## Uncomment this if you need to install these packages

##install.packages("ggplot2") # installs ggplot for graphing
##install.packages("reshape2")
##install.packages("stringr")

## Installing packages through the install.packages function might not work depending on Uni firewall stuff. So may take a bit of fiddling/downloading the packages directly. 

## Structure of this project (make sure these folders exist before running this script)
##  analysis.R
##  instru_analysis.R
##  pav_analysis.R
##  transfer_analysis.R
##  deval_analysis.R
##
##  /R
##    functions.R #sets up participant data IDs, and functions to be used by analysis scripts
##    /data # this is read only. no changes are made to data in these folders. Keep the raw data raw!
##      /instru
##      /pav
##      /transfer
##      /deval
##    /output
##      /data # all extracted group data written to here
##      /figures

## Before you run this have you:
##  - Put all appropriate raw data files into the R/data folder?
##  - Are all raw data files named appropriately?
##  - Have you given all participants the appropriate ID vectors in the 'R/functions.R' script?

# Make sure that participant IDs have the correct data file path
# AND correct version for Pavlovian training/Transfer test given
# AND correct version for deval (whether R1 or R2 was devalued)

source("instru_analysis.R")
source("transfer_analysis.R")
source("deval_analysis.R")

#All data and figure output is in the R/output/ folder.

# R/output/data contains:
# - Instrumental training group data
# - Transfer test group data
# - Devaluation test group data