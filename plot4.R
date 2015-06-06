cwd<-getwd()
#Donwload the file if already not present in the current working directory
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

var_package3<-"lubridate"
if (!require(var_package3,quietly = TRUE, character.only = TRUE))
{
  install.packages(var_package3, quiet=TRUE, dep=TRUE)
  if(!require(var_package3,character.only = TRUE)) stop("Package lubridate not found")
}

#Use the read.csv.sql to load in data for the two required dates
var_dataTbl<-tbl_df(read.csv.sql(paste(cwd,"/household_power_consumption.txt", sep = ""), 
                                 sql="select * from file where Date in ('1/2/2007', '2/2/2007')", 
                                 sep=";", header=TRUE))
#Add column for day of the week
var_dataTbl<-tbl_df(mutate(var_dataTbl, dayofweek=wday(dmy(var_dataTbl$Date), label=TRUE)))

#Open Device (specs are based on the requirements in the course submission)
png(filename=paste(cwd,"/plot4.png", sep = ""), width = 480, height = 480, units = "px", bg = "white")

#Setting the plot matrix (as we are drawing 4 graphs)
#As we are using mfrow, the graphs will get plotted row wise
par(mfrow=c(2,2))

#################First graph
#1. Plot the graph without any data points (scaled down size of y axis label)
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_active_power, pch=NA_integer_,axes = FALSE,
     ylab="", xlab="")
mtext("Global Active Power", side=2, line=3, cex=0.9)

#2. Plot the line
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_active_power)

#3. Plot the label for the first 1440 values
axis(1, 1, c("Thu"), cex.axis=0.9)

#4. Plot the label for the second 1440 values, use the grep command to find the exact location, finish off by adding the label for saturday
var_loc<-head(which(grepl("Fri", var_dataTbl$dayofweek)),1)
axis(1, var_loc, c("Fri"), cex.axis=0.9)
var_loc<-tail(which(grepl("Fri", var_dataTbl$dayofweek)),1)+1
axis(1, var_loc, c("Sat"), cex.axis=0.9)

#5. Define the ticks by using the pretty function
axis(2, at=pretty(var_dataTbl$Global_active_power), cex.axis=0.9)

#6. Draw the box
box()

#################Second Graph
#1. Plot the graph without any data points (scaled down size of y and x axis labels)
plot((1:nrow(var_dataTbl)), var_dataTbl$Voltage, pch=NA_integer_,axes = FALSE,
     ylab="", xlab="")
mtext("datetime", side=1, line=3, cex=0.9)
mtext("Voltage", side=2, line=3, cex=0.9)

#2. Plot the line
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Voltage)

#3. Plot the label for the first 1440 values
axis(1, 1, c("Thu"), cex.axis=0.9)

#4. Plot the label for the second 1440 values, use the grep command to find the exact location, finish off by adding the label for saturday
var_loc<-head(which(grepl("Fri", var_dataTbl$dayofweek)),1)
axis(1, var_loc, c("Fri"), cex.axis=0.9)
var_loc<-tail(which(grepl("Fri", var_dataTbl$dayofweek)),1)+1
axis(1, var_loc, c("Sat"), cex.axis=0.9)

#5. Define the ticks by using the pretty function
axis(2, at=pretty(var_dataTbl$Voltage), cex.axis=0.9)

#6. Draw the box
box()

#################Third Graph
#1. Define the min. and max. values for y axis so that all 3 lines are plotted correctly (without getting cut off)
minY<-min(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)
maxY<-max(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)

#2. Plot the graph without any data points (scaled down size of y axis label)
plot((1:nrow(var_dataTbl)), var_dataTbl$Sub_metering_1, xlim=c(1,nrow(var_dataTbl)),
     ylim=c(minY,maxY), pch=NA_integer_,axes = FALSE,ylab="", xlab="")
mtext("Energy sub metering", side=2, line=3, cex=0.9)

#3. Plot the 3 lines (using the same color coding as that of the sample course figure)
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_1)
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_2, col="red")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_3, col="blue")

#4. plot the label for Thursday on the X axis for the data that correspsonds to Thursday 
#(which is the first 1440 data points)
axis(1, 1, c("Thu"), cex.axis=0.9)

#5. plot the label for Friday on the X axis for the data that correspsonds to Friday
#this is done via searching for friday in the day of the week column that was added above
#and the label is added to the first tick corresponding to the Friday data
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"), cex.axis=0.9)

#We finish the labelling by adding saturday to the next tick after the friday data
var_loc<-tail(which(grepl("Fri", var_dataTbl$dayofweek)),1)+1
axis(1, var_loc, c("Sat"), cex.axis=0.9)

#5. Plot the y axis by using the specs provided in the course submission sample image
axis(2, at=c(0,10,20,30), cex.axis=0.9)

#6. Draw the box
box()

#7. Plot the legend at the top right corner, using the color specs as provided in the course submission sample image
legend("topright", pch=c(NA), col=c("black", "red", "blue"), lty=c(1), bty="n", cex=0.9, pt.cex=1,
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))



#################Fourth Graph
#1. Plot the graph without any data points (scaled down size of y and x axis labels)
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_reactive_power, pch=NA_integer_,axes = FALSE,ylab="", xlab="")
mtext("datetime", side=1, line=3, cex=0.9)
mtext("Global_reactive_power", side=2, line=3, cex=0.9)

#2. Plot the line
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_reactive_power)

#3. Plot the label for the first 1440 values
axis(1, 1, c("Thu"), cex.axis=0.9)

#4. plot the label for Friday on the X axis for the data that correspsonds to Friday
#this is done via searching for friday in the day of the week column that was added above
#and the label is added to the first tick corresponding to the Friday data
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"), cex.axis=0.9)

#We finish the labelling by adding saturday to the next tick after the friday data
var_loc<-tail(which(grepl("Fri", var_dataTbl$dayofweek)),1)+1
axis(1, var_loc, c("Sat"), cex.axis=0.9)

#5. Define the ticks by using the pretty function
axis(2, at=pretty(var_dataTbl$Global_reactive_power), cex.axis=0.9)

#6. Draw the box
box()

#Quietly close the device
invisible(dev.off())