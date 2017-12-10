##    course project 1 

## install and library necessary packages
## data.tables package fread() command can help us load data faster than
## read.table() function

 if (!suppressWarnings(require(data.table)))
 {
   install.packages("data.table")
   require(data.table)
 }
 
 if(!suppressWarnings(require(dplyr)))
 {
   install.packages("dplyr")
   require(dplyr)
 }
 
 
## download household_power_comsumption compressed dataset

data_url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if (!dir.exists("course_project1"))  dir.create("./course_project1")

## I don't why i can't use this url to download dataset as before!!
## if you can't download dataset like this,please download by yourself through web

download.file(data_url,destfile = "./course_project1/dataset.zip")
setwd("./course_project1")

## uncompressing and loading data to your R console
##when you use list.file() command in unzip() function , please check
## the work directory only have one file(your dataset: .zip file) 
## when you use fread() function to load dataset, you will get warning message
## this warning message is caused by missing data "?"

unzip(list.files(),exdir=".")
HPC <- fread("household_power_consumption.txt")


## subset specific data to new stored

HPC_sub <- subset(HPC, Date == "1/2/2007" | Date == "2/2/2007")
HPC_sub <- transform(HPC_sub,Date_Time = paste(Date,Time,sep=" "))
HPC_sub <- HPC_sub[,-c(1:2)]
HPC_sub <- select(HPC_sub,Date_Time,1:7)

## change date_Time variable format for plot2,3,4

date_time <-strptime(HPC_sub$Date_Time,format="%d/%m/%Y %H:%M:%S")
date_time <- as.data.frame(date_time)
HPC_sub$Date_Time <- date_time[,1]

## change the data format for plot1
HPC_sub$Global_active_power <- as.numeric(HPC_sub$Global_active_power)

## change the data format for plot3 
HPC_sub$Sub_metering_1 <- as.numeric(HPC_sub$Sub_metering_1)
HPC_sub$Sub_metering_2 <- as.numeric(HPC_sub$Sub_metering_2)
HPC_sub$Sub_metering_3 <- as.numeric(HPC_sub$Sub_metering_3)

## first, we create a blank graphic with x and y axis.
## then, using points() function add different dataset to blank graphic
## my graphic xlab is simplifed chinese,not english "Thu","Fri" and "Sat"
## And i don't how to change it 

png(file ="./plot3.png",width=480,height = 480)

##Sub_metering_1 has highest y-axis value, so we use this variable to
## create blank graphic
with(HPC_sub,plot(Date_Time,Sub_metering_1,type = "n",
     xlab="",ylab="Energy sub metering"))
points(HPC_sub$Sub_metering_1~HPC_sub$Date_Time,type="l")
points(HPC_sub$Sub_metering_2~HPC_sub$Date_Time,type="l",col="red")
points(HPC_sub$Sub_metering_3~HPC_sub$Date_Time,type="l",col="blue")
legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty= 1, col=c("black","red","blue"))
	 
## close the graphic device

dev.off()
			







