cwd<-getwd()
if(!(file.exists(paste(cwd,"/household_power_consumption.txt", sep = "")))){
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile=paste(cwd,"/EPC.zip", sep = ""), quiet = TRUE, method="curl")
  unzip(paste(cwd,"/EPC.zip", sep = ""))
}

if(!(file.exists(paste(cwd,"/household_power_consumption.txt", sep = ""))))
  stop("Cannot find data")

#################Load Library
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

var_package3<-"lubridate"
if (!require(var_package3,quietly = TRUE, character.only = TRUE))
{
  install.packages(var_package3, quiet=TRUE, dep=TRUE)
  if(!require(var_package3,character.only = TRUE)) stop("Package lubridate not found")
}

var_dataTbl<-tbl_df(read.csv.sql(paste(cwd,"/household_power_consumption.txt", sep = ""), 
                                 sql="select * from file where Date in ('1/1/2007', '2/1/2007')", 
                                 sep=";", header=TRUE))
var_dataTbl<-tbl_df(mutate(var_dataTbl, dayofweek=wday(var_dataTbl$Date, label=TRUE)))

png(filename=paste(cwd,"/plot2.png", sep = ""), width = 480, height = 480, units = "px", bg = "white")
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_active_power, pch=NA_integer_,axes = FALSE,
     ylab="Global Active Power (kilowatts)", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_active_power)
axis(1, 1, c("Sat"))
axis(1, 1441, c("Sun"))
axis(2, at=pretty(var_dataTbl$Global_active_power))
box()

dev.off()