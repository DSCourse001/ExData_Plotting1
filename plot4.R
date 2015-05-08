# Load Required Libraries
require(data.table)
require(graphics)
require(grDevices)

# Setting Locale
Sys.setlocale(category = "LC_ALL", locale = "C")

# Download and Unzip file
url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
txt<-"household_power_consumption.txt"

# Uncompress Zip File
tmpZIPFile <- tempfile()
download.file(url=url,destfile=tmpZIPFile,method="wget",quiet=T,mode="wb",extra=c("--no-check-certificate"))
unzip(tmpZIPFile,files=c(txt),overwrite = TRUE)
unlink(tmpZIPFile)

# Load Data
data <- fread(input=txt
              ,sep=";"
              ,header=T
              ,na.strings="?"
              ,colClasses=c(rep("character",9))
)
unlink(txt)

# Filter Raw by Date
data <- data[data$Date == "2/2/2007" | data$Date == "1/2/2007", ]
# Convert Time
data<-transform(data,
                Time = as.POSIXct(
                  strptime(
                    paste(Date,Time,sep=" "),"%e/%m/%Y %H:%M:%S"
                  )
                )
                ,Date = NULL
)
# Change all Types except "Time" to Numeric
for (n in names(data)) {
  if (!(n %in% c("Time"))) {
    data[[n]] <- as.numeric(data[[n]])
  }
}

# Define Functions to Plot

# Plot 1
plot1 <- function() {
  with(data,
       plot(Time,Global_active_power
            ,type="l"
            ,xlab=""
            ,ylab="Global Active Power"
       )
  )  
}

# Plot 2
plot2 <- function() {
with(data,
     plot(Time,Sub_metering_1
          ,type="n"
          ,xlab=""
          ,ylab="Energy sub metering"
          ,main=""
     )
)
with(data,lines(Time,Sub_metering_1,col="black"))
with(data,lines(Time,Sub_metering_2,col="red"))
with(data,lines(Time,Sub_metering_3,col="blue"))
legend("topright"
       ,lty=1
       ,bty="n"
       ,col = c("black", "red","blue")
       ,legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3")
)
}

# Plot 3
plot3 <- function() {
  with(data,
       plot(Time,Voltage
            ,type="l"
            ,xlab="datetime"
       )
  )  
}

# Plot 4
plot4 <- function() {
  with(data,
       plot(Time,Global_reactive_power
            ,type="l"
            ,xlab="datetime"
       )
  )  
}

# Save to PNG
png("plot4.png",width=480,height=480,units="px")
par(mfcol=c(2,2))

# Plot
plot1()
plot2()
plot3()
plot4()

# Close PNG
dev.off()