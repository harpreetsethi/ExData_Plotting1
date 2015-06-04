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

png(filename=paste(cwd,"/plot4.png", sep = ""), width = 480, height = 480, units = "px", bg = "white")
par(mfrow=c(2,2))

#First graph
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_active_power, pch=NA_integer_,axes = FALSE,
     ylab="Global Active Power (kilowatts)", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_active_power)
axis(1, 1, c("Sat"))
axis(1, head(which(grepl("Sun", var_dataTbl$dayofweek)),1), c("Sun"))
axis(2, at=pretty(var_dataTbl$Global_active_power))
box()

#Second Graph
plot((1:nrow(var_dataTbl)), var_dataTbl$Voltage, pch=NA_integer_,axes = FALSE,
     ylab="Voltage", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Voltage)
axis(1, 1, c("Sat"))
axis(1, head(which(grepl("Sun", var_dataTbl$dayofweek)),1), c("Sun"))
axis(2, at=pretty(var_dataTbl$Voltage))
box()

#Third Graph
minY<-min(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)
maxY<-max(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)

plot((1:nrow(var_dataTbl)), var_dataTbl$Sub_metering_1, xlim=c(1,nrow(var_dataTbl)),
     ylim=c(minY,maxY+10), pch=NA_integer_,axes = FALSE,ylab="Energy Sub metering", xlab="")

lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_1)
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_2, col="red")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_3, col="blue")
axis(1, 1, c("Sat"))
axis(1, head(which(grepl("Sun", var_dataTbl$dayofweek)),1), c("Sun"))
axis(2, at=c(0,5,10,15,20,25,30,35))
box()
legend("topright", pch="-", col=c("black", "red", "blue"), bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Fourth Graph
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_reactive_power, pch=NA_integer_,axes = FALSE,
     ylab="Global_reactive_power", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_reactive_power)
axis(1, 1, c("Sat"))
axis(1, head(which(grepl("Sun", var_dataTbl$dayofweek)),1), c("Sun"))
axis(2, at=pretty(var_dataTbl$Global_reactive_power))
box()

dev.off()