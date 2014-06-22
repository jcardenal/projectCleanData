run_analysis <- function() {
  ## controller
  
  message(paste("Working on folder:",getwd()))
  datadir <- paste(".","UCI\ HAR\ Dataset",sep=.Platform$file.sep)
  file.exists(datadir)
  
  message("Preparing Column Names")
  colNames <- prepareColNames(datadir)
  #print(length(colNames))
  #print(head(colNames))
  
  ## Process Test data
  message("Building TEST dataset")
  test <- buildSet(datadir, "test")
  #print(dim(test))
  #print(head(test[,1:5]))  
  
  
  ## Process Train data
  message("Building TRAIN dataset")
  train <- buildSet(datadir,"train")
  #print(dim(train))
  #print(head(train[,1:5]))
  
  ## Combine both datasets
  message("Combine TEST and TRAIN datasets")
  total <- rbind(test,train)
  ##print(dim(total))
  ## Assing descriptive names
  message("Assigning descriptive names")
  #print(head(colNames))
  names(total) <- colNames
  #print(head(total[1:5]))
  
  ##Filter variables
  message("Filtering variables")
  variables <- filterMeanStd(colNames)
  filtered<-total[,variables]
  ##print(head(filtered,3))
  ##print(length(variables))
  
  ##Use meaningful names in activities
  message("Using meaningful names in activities")
  ac <- readActivityLabels(datadir)
  filtered$activity <- ac[filtered$activity,2]
  ##print(head(filtered[,1:5],3))
  ##print(dim(filtered))
  
  ## Calculates mean by subject and activity
  message("Mean by subject and activity calculation")
  tidydata <- NULL
  
  for(subject in 1:30) {
    for(activity in ac[,2]) {
      ##message(paste("Subject: ",subject," Activity: ",activity))
      mtx <- filtered[(filtered$subject==subject & filtered$activity==activity),3:length(variables)]
      ##message("DIM:")
      ##print(dim(mtx))
      #print(head(mtx,5))
      #message("ColMeans:")
      tidydata <- rbind(tidydata, c(subject,activity,colMeans(mtx,na.rm=T)))
    }
  } 
  ## Seting the column names
  ## it must be considered that the resulting object 'tidydata' is a matrix
  ## and not a data.frame
  ## message("Seting names for tidydata. Before")
  ##print(head(tidydata[,1:5],3))
  ##names(tidydata) <- names(filtered)
  ##message("... and after")
  ##print(head(tidydata[,1:5],3))
  ##message("Tidydata class")
  ##print(class(tidydata))
  ##message("Tididata dim")
  ##print(dim(tidydata))
  #print(head(tidydata,5))
  tidyDF <- data.frame(tidydata);
  ##message("2.Seting names for tidyDF. Before")
  ##print(head(tidyDF[,1:5],3))
  names(tidyDF) <- names(filtered)
  ##message("... and after")
  ##print(head(tidyDF[,1:5],3))
  ##message("TidyDF class")
  ##print(class(tidyDF))
  ##message("TidyDF dim")
  ##print(dim(tidyDF))
  
  ##Re-name mean-derived variables
  message("Renaming finally selected variables")
  for(i in 3:length(names(tidyDF))) {
    names(tidyDF)[i] <- paste("Mean(",names(tidyDF)[i],")",sep="")
  }
  #print(head(tidyDF[,1:5],3))
  
  message("Writing tidy dataset to file TidyDataSet.txt")
  write.table(tidyDF,file="TidyDataSet.txt",row.names=F,quote=F,eol="\r\n")
}


prepareColNames <- function(folder=""){
  f <- paste(folder,"features.txt",sep=.Platform$file.sep)
  df<-read.table(f,header=F)
  ccn <- c("subject","activity",as.character(df[,2]))
  ccn
}


readActivityLabels <- function(folder=""){
  f <- paste(folder,"activity_labels.txt",sep=.Platform$file.sep)
  df<-read.table(f,header=F)
  df
}

buildSet <- function(datadir="", set="") {
  folder <- paste(datadir,set,sep=.Platform$file.sep)
  f <- paste(folder,.Platform$file.sep,"subject_",set,".txt",sep="")
  dat <- buildPart(f)
  #print(head(dat))
  f <- paste(folder,.Platform$file.sep,"y_",set,".txt",sep="")
  dat <-cbind(dat,buildPart(f))
  #print(head(dat))
  f <- paste(folder,.Platform$file.sep,"X_",set,".txt",sep="")
  dat <- cbind(dat,buildPart(f))
  #print(length(names(dat)))
  #print(class(dat))
  dat
}

buildPart<-function(file="") {
  message(paste("     Reading file:",file))
  data <- read.table(file,header=F)
  data  
}

filterMeanStd <- function(target) {
  filter <- c("subject","activity")
  for (i in target) {
    v <- grep("[.]*mean\\(\\)|std\\(\\)[.]*", i)
    if (length(v) != 0)
      filter <- c(filter,i)
  }
  filter
}

## Check function
## Loads generated file as data.frame and shows some info about the 
## object built from the file

checkFile<-function(folder=".") {
  f <- paste(folder,"TidyDataSet.txt",sep=.Platform$file.sep)
  df<-read.table(f,header=T,check.names=F)
  message("Object class")
  print(class(df))
  message("DIM")
  print(dim(df))
  message("Names")
  print(names(df))
  message("HEAD")
  print(head(df[,1:5],4))
}
  