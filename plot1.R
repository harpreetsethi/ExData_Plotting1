cwd<-getwd()
#Download the file if already not present in the current working directory
if(!(file.exists(paste(cwd,"/household_power_consumption.txt", sep = "")))){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile=paste(cwd,"/EPC.zip", sep = ""), quiet = TRUE, method="curl")
  unzip(paste(cwd,"/EPC.zip", sep = ""))
}

if(!(file.exists(paste(cwd,"/household_power_consumption.txt", sep = ""))))
  stop("Cannot find data")

#################Load useful libraries, install if the library doesn't exists
var_package1<-"dplyr"
if (!require(var_package1,quietly = TRUE, character.only = TRUE))
{
  install.packages(var_package1, quiet=TRUE, dep=TRUE)
  if(!require(var_package1,character.only = TRUE)) stop("Package dplyr not found")
}

var_package2<-"sqldf"
if (!require(var_package2,quietly = TRUE, character.only = TRUE))
{
  install.packages(var_package2, quiet=TRUE, dep=TRUE)
  if(!require(var_package2,character.only = TRUE)) stop("Package sqldf not found")
}

#Use the read.csv.sql to load in data for the two required dates
var_dataTbl<-tbl_df(read.csv.sql(paste(cwd,"/household_power_consumption.txt", sep = ""), 
                                 sql="select * from file where Date in ('1/2/2007', '2/2/2007')", 
                                 sep=";", header=TRUE))

#########Open Device
png(filename=paste(cwd,"/plot1.png", sep = ""), width = 480, height = 480, units = "px", bg = "white")

#Plot the histogram, use pretty function to figure out the best breakdown of the histogram cells
hist(var_dataTbl$Global_active_power, main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "red",
     breaks=length(pretty(var_dataTbl$Global_active_power)))

#Quietly close the device
invisible(dev.off())