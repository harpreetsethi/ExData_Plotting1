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
png(filename=paste(cwd,"/plot3.png", sep = ""), width = 480, height = 480, units = "px", bg = "white")

#As multiple data sets are getting plotted on the y axis we need to determine the min. and max. values
#so that axis intervals are set up properly and we don't have lines that are cut off
minY<-min(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)
maxY<-max(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)

#Plot the labels and overall grid without plotting the points
plot((1:nrow(var_dataTbl)), var_dataTbl$Sub_metering_1, xlim=c(1,nrow(var_dataTbl)),
  ylim=c(minY,maxY+10), pch=NA_integer_,axes = FALSE,ylab="Energy Sub metering", xlab="")

#Plot the 3 lines (using the same color coding as that of the sample course figure)
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_1)
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_2, col="red")
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Sub_metering_3, col="blue")

axis(1, 1, c("Thurs"))
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"))
axis(2, at=pretty(c(var_dataTbl$Sub_metering_1, var_dataTbl$Sub_metering_2, var_dataTbl$Sub_metering_3)))
box()
legend("topright", pch="-", col=c("black", "red", "blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
invisible(dev.off())