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
#As we are using mfrow, the graphs get plotted row wise and then wrap to the new row
par(mfrow=c(2,2))

#First graph
#1. Plot the graph without any data points
#2. Plot the line
#3. Plot the label for the first 1440 values
#4. Plot the label for the second 1440 values, use the grep command to find the exact location
#5. Define the ticks by using the pretty function
#6. Draw the box
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_active_power, pch=NA_integer_,axes = FALSE,
     ylab="Global Active Power (kilowatts)", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_active_power)
axis(1, 1, c("Thurs"))
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"))
axis(2, at=pretty(var_dataTbl$Global_active_power))
box()

#Second Graph
#1. Plot the graph without any data points
#2. Plot the line
#3. Plot the label for the first 1440 values
#4. Plot the label for the second 1440 values, use the grep command to find the exact location
#5. Define the ticks by using the pretty function
#6. Draw the box
plot((1:nrow(var_dataTbl)), var_dataTbl$Voltage, pch=NA_integer_,axes = FALSE,
     ylab="Voltage", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Voltage)
axis(1, 1, c("Thurs"))
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"))
axis(2, at=pretty(var_dataTbl$Voltage))
box()

#Third Graph
#1. Define the min. and max. values for y axis so that all 3 lines are plotted correctly (without getting cut off)
#2. Plot the graph without any data points
#3. Plot the three lines
#3. Plot the label for the first 1440 values
#4. Plot the label for the second 1440 values, use the grep command to find the exact location
#5. Define the ticks by using the pretty function
#6. Draw the box

minY<-min(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)
maxY<-max(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)

plot((1:nrow(var_dataTbl)), var_dataTbl$Sub_metering_1, xlim=c(1,nrow(var_dataTbl)),
     ylim=c(minY,maxY+10), pch=NA_integer_,axes = FALSE,ylab="Energy Sub metering", xlab="")

lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_1)
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_2, col="red")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_3, col="blue")
axis(1, 1, c("Thurs"))
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"))
axis(2, at=pretty(c(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)))
box()
legend("topright", pch="-", col=c("black", "red", "blue"), bty="n",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#Fourth Graph
#1. Plot the graph without any data points
#2. Plot the line
#3. Plot the label for the first 1440 values
#4. Plot the label for the second 1440 values, use the grep command to find the exact location
#5. Define the ticks by using the pretty function
#6. Draw the box
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_reactive_power, pch=NA_integer_,axes = FALSE,
     ylab="Global_reactive_power", xlab="")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_reactive_power)
axis(1, 1, c("Thurs"))
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"))
axis(2, at=pretty(var_dataTbl$Global_reactive_power))
box()

invisible(dev.off())