#Create vectors with participant details
#These take the form:

#IDcode <- c("path to data file.log", counterbalancing version, "IDcode", participant number)

##Example from another similar task
# iPIT401 <- c("R/data/iPIT401.log", "A", "iPIT401", 1)
# iPIT402 <- c("R/data/iPIT402.log", "B", "iPIT402", 2)
# iPIT403 <- c("R/data/iPIT403.log", "A", "iPIT403", 3, "CONTROL)
# iPIT404 <- c("R/data/iPIT404.log", "B", "iPIT404", 4, "CASE") 

OCD031 <- c("R/data/transfer/OCD031.log", "A", "OCD031", 1, "CASE")
OCD032 <- c("R/data/transfer/OCD032.log", "C", "OCD032", 2, "CONTROL")
OCD033 <- c("R/data/transfer/OCD033.log", "B", "OCD033", 3, "CASE")


#ID codes for analysis of the instrumental training data
OCD031_i <- c("R/data/instru/OCD031.log", "A", "OCD031", 1, "CASE")
OCD032_i <- c("R/data/instru/OCD032.log", "C", "OCD032", 2, "CONTROL")

#ID vectors for analysis of the pavlovian training data
OCD031_p <- c("R/data/pav/OCD031.log", "OCD031", 1, "CASE")
OCD032_p <- c("R/data/pav/OCD032.log", "OCD032", 2, "CONTROL")

#ID vectors for analysis of the devaluation test data
#Devaluation Version in these vectors
#Deval version 1: O1 devalued
#Deval version 2: O2 devalued
OCD031_d <- c("R/data/deval/OCD031.log", "O1", "OCD031", 1, "CASE")
OCD032_d <- c("R/data/deval/OCD032.log", "O2", "OCD032", 2, "CONTROL")


#calculates CS end time (6s after CSonset)
endTime <- function(x){
  x + 6
}

#calculates preCS start time (6s before CSonset)
preTime <- function(x){
  x - 6
}

#find times of text strings
findTime <- function(x){
  data$time[data$text == x]
}

#find position of an element in a vector
findPos <- function(x){
  which(data$text == x)
}

#count responses
countResp <- function(x, y){
  c(sum(y > x[1] & y < x[2]), sum(y > x[2] & y < x[3]))
}

#timepoints for each CStrial
csPoints <- function(x){
  assign(paste0(x, ".times"), list()) #create empty list for cs start times
  for(i in get(paste0(x, ".text"))){
    i.time <- data$time[i]
    assign(paste0(x,".times"), c(get(paste0(x, ".times")), i.time)) #insert times of start text from each cs trial
  }
  assign(paste0(x,".ends"), lapply(get(paste0(x,".times")), endTime)) #get end times of each cs(6s after onset)
  assign(paste0(x, ".pres"), lapply(get(paste0(x, ".times")), preTime)) #get precs start times (6s before onset)
  assign(paste0(x, ".points"), mapply(get(paste0(x, ".pres")), get(paste0(x, ".times")), get(paste0(x, ".ends")), FUN = list, SIMPLIFY=FALSE))
}

#mean precs and cs responses for each trials
csMeans <- function(x){
  assign(paste0(x,".r1s"), lapply(get(paste0(x, ".points")), countResp, y=r1times)) # count r1 responses
  assign(paste0(x,".r2s"), lapply(get(paste0(x, ".points")), countResp, y=r2times)) # count r2 responses
  #average responses over trials
  assign(paste0(x, ".mean.r1sCS"), mean(sapply(get(paste0(x, ".r1s")), '[[', 2)))
  assign(paste0(x, ".mean.r1sPre"), mean(sapply(get(paste0(x, ".r1s")), '[[', 1)))
  assign(paste0(x, ".mean.r2sCS"), mean(sapply(get(paste0(x, ".r2s")), '[[', 2)))
  assign(paste0(x, ".mean.r2sPre"), mean(sapply(get(paste0(x, ".r2s")), '[[', 1)))
  
  assign(paste0(x, ".means"), c(get(paste0(x, ".mean.r1sPre")), get(paste0(x, ".mean.r1sCS")), get(paste0(x, ".mean.r2sPre")), get(paste0(x, ".mean.r2sCS")))) # returns vector of four values. R1 PRECS, R1 CS, R2 PRECS, R2 CS
} 

#assigns an empty vector to a variable
#y = length of the empty vector
createVector <- function(x, y){
  x <- numeric(length=length(y))
}


#assigns an empty matrix to a variable
#y = number of rows of the empty matrix
#z = number of columns of the empty matrix
createDF <- function(x,y,z){
  x <- matrix(nrow = length(y), ncol = z)
}


addID <- function(id, x, cols){
  df <- data.frame(id, x)
  colnames(df) <- cols
  df
}
