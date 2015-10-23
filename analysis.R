###This script runs the data extraction and summary for all stages of the PIT & Devaluation task


##Before you run this have you:
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