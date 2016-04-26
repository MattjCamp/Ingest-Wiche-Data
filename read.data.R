# Reads in spreadsheets from WICHE

read.one.csv.file <- function(csv.file){

  # Read CSV file
  
  data <- read.csv2(file = csv.file, 
                    header = FALSE,
                    skip = 18,
                    colClasses = "character",
                    quote = "\"",
                    stringsAsFactors = FALSE,
                    sep = ",")
  
  # Keep only what we need
  
  data <- data[1:26, 1:7]
  
  # Add meaningful names
  
  names(data)[1] <- "Academic_Year"
  names(data)[2] <- "Total"
  names(data)[3] <- "Native_American"
  names(data)[4] <- "Asian"
  names(data)[5] <- "Black"
  names(data)[6] <- "Hispanic"
  names(data)[7] <- "White"
  
  # Only keep the academic year ending
  # (2014 - 2015 becomes 2015)
  
  data[,1] <- sprintf("%s%s",
                      substr(data[,1], 1, 2),
                      substr(data[,1], 6, 7))
  
  # Strip commas and convert to numbers
  
  for (i in 1:7)
    data[, i] <- as.numeric(gsub(",","", data[, i]))
  
  # Add metro based on filename
  
  data$Metro <- gsub(".csv", "", gsub("-Table 1", "", csv.file))
  
  data$Metro <- gsub(data.sources, "", data$Metro)
  
  # Re-arrange columns for appearance sake
  
  data <- data[, c(8, 1, 2:7)]
  
  # Remove NA
  
  data <- data[!is.na(data$Academic_Year), ]
  
  return(data)

}

read.data <- function(){

  d <- NULL

  files <- list.files(data.sources)

  for (csv.file in files)
    d <- rbind(d,
      read.one.csv.file(sprintf("%s%s",
                                data.sources,
                                csv.file)))

  return(d)

}