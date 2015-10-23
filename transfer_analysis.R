##This script extracts and analyses specific and general transfer data from the Pavlovian-Instrumental Transfer task
##Before you run this you need:
#The log files for each participant in the 'R/data/transfer' folder
#Participant log files all named '(whateveryouridis).log'
#The packages that R uses installed
#-if you try to run this without the appropriate packages installed it wont work
#-you can use install.packages() to download these
#-this may take a bit of fiddling if your uni's firewall doesn't like you doing this
#You will need to create individual participant ID vectors in the 'R/functions.R' script 

library(ggplot2)
library(reshape2)
source("R/functions.R") #this loads the functions that will be needed for analysis

#Create a list of all of the participant ID vectors that are created in the 'functions.R' script

#Example of this from a similar task
#ID <- list(iPIT401, iPIT402, iPIT403, iPIT404)

ID <- list(OCD031, OCD032, OCD033)

#cs list
cs <- list("s1", "s2", "s3", "s4")

#Create empty vectors that will be filled with participant data as the analysis loops through each indiviudal data set
participant <- character(length = length(ID))  # creates a vector that will be filled with participant IDs

type <- character(length = length(ID))

#specific transfer: same, diff
#general transfer: cs_plus, cs_minus
#baseline: preCS
cuenames <- c("same", "diff", "cs_plus", "cs_minus", "preCS") #names of the different cue conditions
emptycues <- vector("list", length(cuenames)) # create a list for each cue condition
names(emptycues) <- cuenames #give each item in the list cue names

emptycues <- lapply(emptycues, createVector, y=ID) #for each cue condition, create an empty vector the length of the # of participants 

#loop through the data extraction for each participant
for(i in ID){
  #read participant data
  data <- read.delim(i[[1]], header = FALSE) #uses the path in the participant ID vector to read the log file
  version <- i[[2]] #looks for the version in the second item of the participant vector
  
  #give the data column headings
  colnames(data) <- c("time", "type", "text")
  
  #find the time that each left and right response was made
  #this subsets the time column for each row where a left or right keypress is made
  #IF YOU CHANGE KEYS FOR LEFT AND RIGHT YOU WILL NEED TO CHANGE THIS 
  
  r1times <- data$time[data$text == "press L"] #left is always R1
  r2times <- data$time[data$text == "press R"] #right is always R2
  
  #S1 <- cue that is paired with same outcome as R1
  #S2 <- cue that is paired with same outcome as R2
  #S3 <- cue that is paired with non-instrumentally available outcome
  #S4 <- yellow cue always associated with no outcome delivered

  #Pulls out row numbers of the text signalling the onset of the different cues
  s1.text <- grep("Condition': u'red.png", data$text)
  s2.text <- grep("Condition': u'green.png", data$text)
  s3.text <- grep("Condition': u'blue.png", data$text)
  s4.text <- grep("Condition': u'yellow.png", data$text)
  
  #Find response data for each CS
  for(j in cs){
    assign(paste0(j, ".points"), csPoints(j)) #finds pre, start and end time for each cs
    assign(paste0(j, ".responses"), csMeans(j)) # finds mean responses during each cs
  }
  
  #Find mean responses by cue type
  i.same <- mean(c(s1.responses[2], s2.responses[4])) #R1 CS responses 2nd value in vector, R2 CS responses 4th
  i.diff <- mean(c(s2.responses[2], s1.responses[4])) 
  i.cs_plus <- mean(c(s3.responses[2], s3.responses[4]))
  i.cs_minus <- mean(c(s4.responses[2], s4.responses[4]))
  i.preCS <- mean(c(s1.responses[c(1,3)], s2.responses[c(1,3)], s3.responses[c(1,3)], s4.responses[c(1,3)]))
  
  #Insert individual participant values into the empty vectors created
  #for each cue type, inset the value of the participant into the row that corresponses with their participant number
  participant[as.numeric(i[4])] <- i[[3]] # insert participant ID code into vector
  type[as.numeric(i[4])] <- i[[5]]
  for(j in cuenames){
    emptycues[[j]][[as.numeric(i[4])]] <- get(paste0("i.", j))
  }
}

group.df <- as.data.frame(emptycues) #creates a dataframe from list
wide.group.df <- data.frame(participant, type, group.df) # group data frame w/ participant IDs

#Set directory for output
dir.output <- 'R/output/data'

#Export group data
write.csv(wide.group.df, file = file.path(dir.output, "group_transferSummary.csv"), row.names = FALSE)

