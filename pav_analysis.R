##This script extracts and summarises the data from the Pavlovian training stage of the exciatory PIT task. 
##Before you run this you need:
#The log files for each participant in the 'R/data/pav' folder
#Participant log files all named '(whateveryouridsis).log'

#-if you try to run this without the appropriate packages installed it wont work
#-you can use install.packages() to download these
#-this may take a bit of fiddling if your uni's firewall doesn't like you doing this
#You will need to create individual participant ID vectors in the 'R/functions.R' script 

source("R/functions.R") #this loads the functions that will be needed for analysis

ID <- list(OCD031_p, OCD032_p)

#create empty vectors to be filled with data extracted from each participant

participant <- character(length = length(ID))  # creates a vector that will be filled with participant IDs

pavlovian_answers <- createDF(y=ID, z=12)
colnames(pavlovian_answers) <- c(1:12)

for(i in ID){
  data <- read.delim(i[[1]]) #uses the path in the participant ID vector to read the log file
  
  #give the data column headings
  colnames(data) <- c("time", "type", "text")
  
  mcq_answers <- c(data$text[data$text == "correct" | data$text == "incorrect"])
  
  participant[as.numeric(i[3])] <- i[[2]] # insert participant ID code into vector
  pavlovian_answers[as.numeric(i[3]),] <- mcq_answers
}

#create a data frame of the grouped data 
# 12 MCQs (trials 1-12)
# Answer
#   1 = Correct
#   0 = Incorrect
answerIDs <- c("ID", 1:12)
groupPavAnswers <- addID(pavlovian_answers, id=participant, cols=answerIDs)

#Set directory for output
dir.output <- 'R/output/data'

#Export group data
write.csv(groupPavAnswers, file = file.path(dir.output, "group_pavData.csv"), row.names = FALSE)