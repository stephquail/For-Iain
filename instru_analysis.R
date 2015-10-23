##This script extracts and summarises Instrumental training data from the excitatory PIT task. 
##Before you run this you need:
#The log files for each participant in the 'R/data/instru' folder
#Participant log files all named '(whateveryouridsis).log'

#-if you try to run this without the appropriate packages installed it wont work
#-you can use install.packages() to download these
#-this may take a bit of fiddling if your uni's firewall doesn't like you doing this
#You will need to create individual participant ID vectors in the 'R/functions.R' script 

library(ggplot2)
library(reshape2)
library(stringr)
source("R/functions.R") #this loads the functions that will be needed for analysis


#Create a list of all of the participant info vectors
ID <- list(OCD031_i, OCD032_i)

#Create the empty vectors that will be filled with the data extracted from each participant. 

participant <- character(length = length(ID))  # creates a vector that will be filled with participant IDs
type <- character(length = length(ID))
instru_measures <- c("r1total", "r2total", "o1won", "o2won", "totalWon")
emptymeasures <- vector("list", length(instru_measures)) #create a list for each training measure
names(emptymeasures) <- instru_measures #give each item in the list names

emptymeasures <- lapply(emptymeasures, createVector, y=ID) #for each measure, create an empty vector the length of the # of participants

#Loop through the data extraction for each particpant

#Loop through the data extraction for each particpant

for(i in ID){
  data <- read.delim(i[[1]], header = FALSE) #uses the path in the participant ID vector to read the log file
  version <- i[[2]] #looks for the version in the second item of the participant vector
  
  #give the data column headings
  colnames(data) <- c("time", "type", "text")
  
  #find the time that each left and right response was made
  #this subsets the time column for each row where a left or right keypress is made
  #IF YOU CHANGE KEYS FOR LEFT AND RIGHT YOU WILL NEED TO CHANGE THIS 
  
  i.r1times <- findTime("Keypress: t") #left is always R1
  i.r2times <- findTime("Keypress: v") #right is always R2
  
  #Count the number of responses on each action
  i.r1total <- length(i.r1times)
  i.r2total <- length(i.r2times)
  
  #find the times that each left and right outcome was made
  i.o1times <- findTime("win A")
  i.o2times <- findTime("win B")
  
  #Count the number of snacks won
  i.o1won <- length(i.o1times)
  i.o2won <- length(i.o2times)
  
  #Total number of snacks won
  i.totalWon <- i.o1won + i.o2won
  
  
  #Insert individual participant values into the empty vectors created
  #for each cue type, inset the value of the participant into the row that corresponses with their participant number
  participant[as.numeric(i[4])] <- i[[3]] # insert participant ID code into vector
  type[as.numeric(i[4])] <- i[[5]]
  for(j in instru_measures){
    emptymeasures[[j]][[as.numeric(i[4])]] <- get(paste0("i.", j))
  }
  
}

#Create a data frame of the group data from instrumental training
instru.df <- as.data.frame(emptymeasures) #dataframe from list
wide.instru.df <- data.frame(participant, type, emptymeasures) #group data frame with participant IDs

#Set directory for output
dir.output <- 'R/output/data'

#Export group data
write.csv(wide.instru.df, file = file.path(dir.output, "group_instruData.csv"), row.names = FALSE)

