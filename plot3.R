## Kitoogo Fredrick
## Project for the Exploratory Data Analysis Course
## Goal: to examine how household energy usage varies over a 2-day period in February, 2007 
## Task: to reconstruct the plots which were constructed using the base plotting system.
## Dataset: This assignment uses data from the UC Irvine Machine Learning Repository, 
## a popular repository for machine learning datasets. ## In particular, we will be using the
## "Individual household electric power consumption Data Set
##  https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip


## Load the RCurl Package for ease of reading from https
library("RCurl", lib.loc="C:/Program Files/R/R-3.2.3/library")

## Load the Libridate Package to manipulate dates
library("lubridate", lib.loc="\\\\Rsv-nita-01/USER$/Fredrick.Kitoogo/R/win-library/3.2")

## Load the ggplot2 package for plotting
library("ggplot2", lib.loc="\\\\Rsv-nita-01/USER$/Fredrick.Kitoogo/R/win-library/3.2")

## Set the date and time format
setClass("dateFormat")
setAs("character","dateFormat", function(from) as.Date(strptime(from, "%d/%m/%Y"))) 

## Check for and create folder to save the plots
if(!file.exists("./plots")){
  message("Creating data directory")
  dir.create("./plots")}


## Function for downloading, unzipping and reading the data
read_data <- function() {
  
  ## Create a temporary file
  temp <- tempfile() 
  
  ## Assign the fileURL to an R Object
  fileUrl = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  
  ## Download the file and save into a the temporary file
  message("Downloading data.........")
  download.file(fileUrl,destfile=temp, method="libcurl")
  
  ## Assign column Names
  col_Names = c("Date", "Time", "Global_active_power", "Global_reactive_power", 
    "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3")
  
  col_Classes = c("Date" = "dateFormat", "Time" = "character",
                  "Global_active_power" = "numeric", "Global_reactive_power" = "numeric",
                  "Voltage" = "numeric", "Global_intensity" =  "numeric", 
                  "Sub_metering_1" =  "numeric", "Sub_metering_2" =  "numeric", 
                  "Sub_metering_3" =  "numeric")
  
  # Read from the temporary zip file into an R Object data 
  ## data from the dates 2007-02-01 and 2007-02-02 for computer memory's sake
  data <- suppressWarnings(read.table(text = grep("^[1,2]/2/2007", 
                     readLines(unz(temp, "household_power_consumption.txt")), value = TRUE), 
                     col.names = col_Names, colClasses = col_Classes, header=F, sep=";",
                     stringsAsFactors = F))

  unlink(temp) ## Remove the temporary file
  return(data)
}

plot_data <- function(data) {
  
 ## In order to plot date and time, the data and time columns are combined to form a new column 
 ## DateTime
 datetime <- paste(data$Date, data$Time, sep = " ")
 data$DateTime <- as.POSIXct(strptime(datetime, format="%Y-%m-%d %H:%M:%S")) 

 ## initiate the plotting device to a png file
 png(filename = "./plots/plot3.png", width = 480, height = 480)
 
 
 with(data, {
   
   ## Set the X & Y axis variables for plotting
   x_axis_Vars <- c(rep(DateTime, 3))
   y_axis_Vars <- c(Sub_metering_1, Sub_metering_2, Sub_metering_3)
   
   ## Create a blank plot with axis labels and limits
   plot(x_axis_Vars, y_axis_Vars, type="n", 
        xlab=" ", ylab="Energy sub metering")
   
   
   ## Fill the plot with the different sub metering plots 
   lines(DateTime, Sub_metering_1, col="black")
   lines(DateTime, Sub_metering_2, col="red")
   lines(DateTime, Sub_metering_3, col="blue")
   
   ## Fill the polt with a Legend
   legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
          lty = 1, lwd = 1, col=c("black", "red", "blue"))
})
## shut down the current device 
dev.off() 
  
}

data <- read_data()
plot_data(data)


