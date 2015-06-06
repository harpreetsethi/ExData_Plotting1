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
var_dataTbl<-tbl_df(mutate(var_dataTbl, dayofweek=wday(dmy(var_dataTbl$Date), label=TRUE, abbr=TRUE)))
nrow(var_dataTbl)
#Open Device (specs are based on the requirements in the course submission)
png(filename=paste(cwd,"/plot2.png", sep = ""), width = 480, height = 480, units = "px", bg = "white")

#Plot the labels and overall grid without plotting the points
plot((1:nrow(var_dataTbl)), var_dataTbl$Global_active_power, pch=NA_integer_,axes = FALSE,
     ylab="Global Active Power (kilowatts)", xlab="")

#Plot the line for global active power
lines(x=(1:nrow(var_dataTbl)), y=var_dataTbl$Global_active_power)

#plot the label for Thursday on the X axis for the data that correspsonds to Saturday 
#(which is the first 1440 data points)
axis(1, 1, c("Thurs"))

#plot the label for Sunday on the X axis for the data that correspsonds to Sunday
#this is done via searching for sunday in the day of the week column that was added above
#and the label is added to the first tick corresponding to the sunday data
axis(1, head(which(grepl("Fri", var_dataTbl$dayofweek)),1), c("Fri"))

#Draw the Y axis with intervals defined by the pretty function
axis(2, at=pretty(var_dataTbl$Global_active_power))

#Plot the box around axis
box()

#Quietly close the device
invisible(dev.off())