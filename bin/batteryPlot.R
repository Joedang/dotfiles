#!/usr/bin/env Rscript
logFile <- "~/log/batteryMonitor.csv"
pdfFile <- "~/log/batteryPlot.pdf"
dat <- read.csv(logFile)
dat$time <- as.POSIXct(dat$EPOCHSECONDS, origin="1970-01-01")
dat$urgency[is.na(dat$urgency)] <- -1
dat$sign[is.na(dat$sign)] <- -1
#dat$status <- as.factor(dat$status)
pdf(pdfFile, width=10.66, height=6)
par.old <- par()
par(
    bg= 'black', fg= 'white',
    col.axis= 'white',
    col.lab= 'white',
    col.main= 'white',
    col.sub= 'white'
)
#x11() # always plot to a window rather than a PDF file
pastDay_range <- Sys.time()+as.difftime(c(-1, 0), units='days')
xmin <- max(c(min(dat$time), pastDay_range[1]))
xmax <- min(c(max(dat$time), pastDay_range[2]))
#signCol <- character()
#signCol[dat$sign ==  1] <- rgb(0,1,0)
#signCol[dat$sign ==  0] <- rgb(0,0,0, alpha=0)
#signCol[dat$sign == -1] <- rgb(1,0,0)
#urgencyCol <- character()
#urgencyCol[dat$urgency == 0] <- rgb(0,0,0.5)
#urgencyCol[dat$urgency == 1] <- rgb(0,0.5,0.5)
#urgencyCol[dat$urgency == 2] <- rgb(1,0,1)
#stateCol <- character()
#stateCol[dat$urg == 0 & dat$sign == -1] <- rgb(0,0,1) # decreasing while good = blue
#stateCol[dat$urg == 1 & dat$sign == -1] <- rgb(1,0.5,0) # decreasing while low = orange
#stateCol[dat$urg == 2 & dat$sign == -1] <- rgb(1,0,0) # decreasing while critical =red
#stateCol[dat$sign == 0] <- rgb(0,0,0, alpha=0) # no change = hidden
#stateCol[dat$urg == 2 & dat$sign ==  1] <- rgb(1,0,1) # increasing while critical = magenta
#stateCol[dat$urg == 1 & dat$sign ==  1] <- rgb(1,1,0) # increasing while low = yellow
#stateCol[dat$urg == 0 & dat$sign ==  1] <- rgb(0,1,0) # increasing while good = green
statusCol <- rep(rgb(0.5,0.5,0.5), length.out=length(dat$status))
statusCol[dat$status == "Full"] <- rgb(0,1,0)
statusCol[dat$status == "Charging"] <- rgb(0,1,1)
statusCol[dat$status == "Discharging"] <- rgb(1,0,0)
statusCol[dat$status == "Unknown"] <- rgb(1,0,1)
plot(
     rev(dat$time), rev(dat$capacity),
     main="Battery History",
     type="l", col=rgb(0.1,0.1,0.1), xaxt="n",
     #col=rev(statusCol), #col=rev(stateCol), #col=rev(signCol),
     ylim=c(0,100), xlim=c(xmin, xmax),
     ylab="Battery Charge %", xlab="time (HH:MM)"
)
hours_ticks=as.POSIXct(Sys.Date())+as.difftime(seq(-24, 24, by=4), units="hours")
axis(1, at=hours_ticks, labels=strftime(hours_ticks, format="%H:%M"))
abline(h=seq(0, 100, by=10), lty="dotted", col="darkgray")
abline(v=as.POSIXct(Sys.Date())+as.difftime(seq(-24, 24), units="hours"), lty="dotted", col="darkgray")
#points(dat$time, dat$urgency*10, col=urgencyCol)
#points(dat$time, dat$sign*10+50, col=3-dat$dec)
points(dat$time, dat$capacity, col=statusCol, pch='.')
suppressWarnings(par(par.old))
dev.off()
system(paste("zathura", pdfFile))
