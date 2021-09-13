#!/usr/bin/env Rscript
# info {{{
# report the weekly Covid growth rate for Oregon
# Joe Shields, 2020-09-14
# vim: set foldmethod=marker:

# This script is mainly used to show the average COVID-19 growth rate for the last 7 days.
# I use it to generate a little widget that stays on my XFCE panel.
# I've also extended it to create some nice plots that summarize the way in which the pandemic is growing.
# (These are viewed by clicking on the widget.)
# This helps me gauge how safe it might be to go outside, 
# so I can avoid contact when there are lots of active cases 
# or when the virus is more likely to spread due to people's changing behavior. 

# Check out these links for info on SODA/Socrata queries:
# https://dev.socrata.com/docs/queries/
# https://data.cdc.gov/Case-Surveillance/United-States-COVID-19-Cases-and-Deaths-by-State-o/9mfq-cb36

# The "simple files" output is meant to immitate things like `/sys/class/power_supply/BAT0`,
# and is intended for consumption by things like i3status.

# The XML output is meant for consumption by the xfce4-genmon-plugin.
# https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin
# <txt>Text to display</txt>
# <img>Path to the image to display</img>
# <tool>Tooltip text</tool>
# <bar>Pourcentage to display in the bar</bar>
# <click>The command to be executed when clicking on the image</click>
# <txtclick>The command to be executed when clicking on the text</txtclick>

# TODO:
# - either refactor things to either *convert* the data into a one-record-per-day format,  
#   or tolerate time-series inconsistencies.
# - get everything into oldest-data-first
# - introduce variables for misc stuff like week length
# info }}}

# script configuration {{{
dateFormat <- '%Y-%m-%d\n' # format to use when printing dates
dateRetrieved <- as.POSIXct(Sys.time()) # time the script was started
outputDir <- paste(Sys.getenv('HOME'), '.local/status/covid/', sep='/') # path for the output files
avgWindow <- 7 # days; window over which the growth rate is averaged; does not necessarily need to be a week
interestWindow <- 300 # days; period over which you want to know the number of active cases; must be greater than avgWindow
contagiousDays <- 20 # days; how long a case is considered "active" after reporting
daysToPredict_forwards <- 14 # days; window over which to predict the growth rate and active cases
daysToPredict_backwards <- ceiling(1.5*contagiousDays)
#plotWindow <- Sys.Date()+as.difftime(c(-5*contagiousDays,daysToPredict_forwards), units='days') # what time range to show
plotWindow <- c(as.Date('2020-04-01'), Sys.Date()+as.difftime(daysToPredict_forwards, units='days')) # what time range to show
plotElbowroom <- 1.2 # factor by which plot windows are scaled beyond their data (only in cases where sensible)
dashboardLink <- 'https://multco.us/novel-coronavirus-covid-19/regional-covid-19-data-dashboard' # website to reference for further information
pdfViewer <- 'zathura' # command to open a PDF
# }}}

# ensure the outputDir exists {{{
cat('outputDir is:', outputDir, '\n')
if (!dir.exists(outputDir)) {
    cat(outputDir, 'does not exist. Creating it...\n')
    dir.create(outputDir, recursive=T)
}
# }}}

# retrieve and process data {{{
cat( # if the script silently fails when refreshed through the GUI, this error will at least be left behind
    "error in covid.R<tool>error in covid.R</tool>", 
    file=paste(outputDir, 'genmon.xml', sep=''),
    sep=''
)
url <- paste("http://data.cdc.gov/resource/9mfq-cb36.csv?$limit=", interestWindow+contagiousDays, "&$order=submission_date%20DESC&state=OR&$where=submission_date%20>=%20'2020-01-01'", sep='') # Socrata query URL 
dat <- read.csv(url) # get the latest chunk of data
nDays <- dim(dat)[1] # number of records returned (I'm assuming there's one record per day.)
dataDate <- as.POSIXct(dat$submission_date[1]) # date of latest record
stale <- format(dateRetrieved - dataDate, digits=2) # time between the latest record and the time of retrieval 
oldestCaseDate <- as.Date(dat$submission_date[contagiousDays]) # date of the oldest active case
dat$submission_date <- as.Date(dat$submission_date)
if ( min(dat$submission_date) > min(plotWindow) )
    plotWindow[1] <- min(dat$submission_date)
if (length(dat$submission_date) < interestWindow)
    interestWindow <- length(dat$submission_date)
# I could get the daily growth by simply subtracting the new cases on day i-contagiousDays from the new cases on day i.
# However, it's still nice to know the active cases on a given day, since that can be compared to the plot on the 
# Multnomah county website.
active <- integer()
for (i in 1:min(interestWindow, length(dat$new_case)-contagiousDays)) {
    active[i] <- sum(dat$new_case[i:(i+contagiousDays)]) # sum over the preceeding contagious period
}
dailyGrowth <- -diff(active)/active[1:(length(active)-1)] # how much the pool of active cases grows or shrinks per day; the sign flip is because the records are in reverse chronological order
for (i in 1:length(dailyGrowth))
    if (is.nan(dailyGrowth[i])) # handle divide-by-zero 
        dailyGrowth[i] <- 0
filterVector <- rep(1/avgWindow, length.out=avgWindow)
dailyGrowth_avg <- filter(dailyGrowth, filter= filterVector)
weeklyPercent <- mean(dailyGrowth[1:7])*100*7 # the average percent growth over the past week
# processing }}}

# predictions {{{
predict_indices <- 1:daysToPredict_backwards
mdat <- data.frame( # data to use for the predictive model
                   date= as.Date(dat$submission_date[predict_indices]), 
                   active= active[predict_indices], 
                   growth=dailyGrowth[predict_indices]
)
mdat$date_ct <- as.numeric(as.POSIXct(mdat$date))
m_growth <- lm(growth ~ poly(date_ct,2), mdat)
m_active <- lm(active ~ poly(date_ct,2), mdat)
predictDays_past <- mdat$date
predictDays_future <- rev(predictDays_past[1] + as.difftime(1:daysToPredict_forwards, units='days')) # predict a week into the future
predictDays <- c(predictDays_future, predictDays_past)
predictDays <- unique(predictDays)
pactive <- predict(m_active, data.frame(date_ct= as.numeric(as.POSIXct(predictDays)) ))
pred_growth <- predict(m_growth, data.frame(date_ct= as.numeric(as.POSIXct(predictDays)) ))
# growth rate *today*, based on the quadratic fit of the growth rate:
pred_growth_today <- pred_growth[match(Sys.Date(), predictDays)]
# weekly percent growth rate based on the above daily growth rate:
weeklyPercent_pgt <- pred_growth_today*100*7
pg_active <- numeric()
pg_active[daysToPredict_forwards+1] <- active[1] # last known active cases 
for (i in daysToPredict_forwards:1){ # Euler method forwards in time
    pg_active[i] <- (1+pred_growth[i+1])*pg_active[i+1]
}
for (i in (daysToPredict_forwards+2):length(pred_growth)){ # Euler method backwards in time
    pg_active[i] <- pg_active[i-1]/(1+pred_growth[i])
}
# }}}

# output results to simple files {{{
write.csv(dat, file= paste(outputDir, 'covid.csv', sep='')) # so I can review stuff without requesting the data again
cat(
    format(weeklyPercent_pgt, digits=2), "\n", sep='', 
    file=paste(outputDir, 'weeklyPercent', sep='')
)
cat(
    'Oregon\n', 
    file=paste(outputDir, 'state', sep='')
)
cat(
    strftime(dateRetrieved, format=dateFormat), 
    file=paste(outputDir, 'retrieved', sep='')
)
cat(
    strftime(dataDate, format=dateFormat), 
    file=paste(outputDir, 'updated', sep='')
)
cat(
    paste(stale, '\n', sep=''), 
    file=paste(outputDir, 'stale', sep='')
)
# simple files }}}

# output to XML for xfce4 {{{
bg <- if (weeklyPercent_pgt < 0) 'Green' else 'Red'
# if (weeklyPercent < 0) 
#     bg <- 'Green'
# else 
#     bg <- 'Red'
cat(
    "<txt>",
    " 😷📈 \n<span background='", bg, "' foreground='Black'>",
    sprintf(' %0.1f%%', weeklyPercent_pgt),
    '</span></txt>\n', 
    "<tool>", 
    "weekly growth rate for COVID cases in Oregon\n", 
    'data from: ', strftime(dataDate, format=dateFormat), 
    'stale: ', stale, 
    "</tool>\n", 
    '<txtclick>',
    # 'firefox --new-tab https://multco.us/novel-coronavirus-covid-19/regional-covid-19-data-dashboard ', paste(outputDir, 'active.pdf', sep=''),
    pdfViewer, ' ', paste(outputDir, 'active.pdf', sep=''),
    '</txtclick>', 
    file=paste(outputDir, 'genmon.xml', sep=''),
    sep=''
)
# xfce4 }}}

# plotting {{{
# The Multnomah county site is probably more reliable, 
# but it's also a little more like reading tea leaves / stock performance.
# It can be hard to tell what's noise on their ultra-coarse plot.
# setup {{{
drawGrids <- function() {
    abline(v=months, col='darkgray', lty='dashed') # monthly grid
    abline(v=weeks, col='darkgray', lty='dotted') # weekly grid
    abline(v=today, col='blue', lty='solid') # weekly grid
    grid(nx=0, ny=NULL, col='darkgray', lty='solid', lwd=0.5)
}
pdf(paste(outputDir, 'active.pdf', sep=''), bg= 'black', fg= 'white')
layout(matrix(c(1,2,3), nrow=3), heights=c(1,1,1))
par.old <- par()
par(
    bg= 'black', fg= 'white',
    col.axis= 'white',
    col.lab= 'white',
    col.main= 'white',
    col.sub= 'white',
    mar= c(2,7,3,1) # bottom, left, top, right
)
legendBG <- rgb(0,0,0,0.85)
plotInds <- which( (plotWindow[1] <= dat$submission_date) & (dat$submission_date <= plotWindow[2]) )
today <- Sys.Date()
today_str <- paste('today (', today, ')', sep='')
thisYear <- as.integer(format(today, "%Y"))
minYear <- as.integer(format(plotWindow[1], "%Y"))-1
maxYear <- as.integer(format(plotWindow[2], "%Y"))+1
months <- c()
weeks <- c()
for (Y in minYear:maxYear) { # loops are gross, but work well here.
    for (m in 1:12) {
        # %Y-%m-%d; the first dayj of every month of the year (see ?strftime)
        months <- c(months, paste(Y, sprintf("%02d", m), '01', sep='-'))
    }
    for (W in 1:52) {
        # %Y-%W-%w; every monday of every week of the year (see ?strftime)
        weeks <- c(weeks, paste(Y, sprintf("%02d", W), '1', sep='-')) 
    }
}
months <- as.Date(months, format="%Y-%m-%d")
weeks <- as.Date(weeks, format="%Y-%W-%w")
# }}}

# daily new cases {{{
print("Plotting daily new cases...")
plot(
     as.Date(dat$submission_date[1:length(dailyGrowth)]),
     dat$new_case[1:length(dailyGrowth)],
     #main= 'Daily New Cases',
     ylim= c(0, max(dat$new_case[plotInds])),
     xlim= plotWindow,
     #xlab= 'date',
     ylab= 'new cases'
)
title(main='Summary of COVID-19 Growth in Oregon')
abline(v=oldestCaseDate, col='blue', lty='dashed')
lines(
      as.Date(dat$submission_date), 
      filter(dat$new_case, filter= filterVector), 
      col='red'
)
drawGrids()
legend(
       'topleft',
       legend = c(
                  'daily', 'rolling weekly average', 
                  'oldest currently active', today_str, 'months', 'weeks'
                  ),
       col= c(par('fg'), 'red', 'blue', 'blue', 'gray', 'gray'),
       lty= c('solid', 'solid', 'dashed', 'solid', 'dashed', 'dotted'),
       bg= legendBG
)
# }}}
# active cases {{{
print("Plotting active cases...")
plot(
     as.Date(dat$submission_date[1:length(active)]), 
     active, 
     type='l', 
     xlim= plotWindow,
#      ylim= c(0, max(
#                     active[ min(c(
#                                   plotInds, 
#                                   length(active)
#                                   )) ]
#                     )*plotElbowroom),
     ylim= c(0, max(active[ 1:length(active) %in% plotInds ]*plotElbowroom)),
     #main='Active Cases',
     #xlab= 'date',
     ylab= c('number of active cases\n(a) (cases)')
)
drawGrids()
abline(v=oldestCaseDate, col='blue', lty='dashed') # oldest active case
# prediction calcs
lines( # quadratic prediction
     predictDays, 
     pactive,
     col='green',
     lty='dashed'
)
lines( # Euler method using growth rate
      predictDays,
      pg_active,
      col='magenta',
      lty='dashed'
)
lines( # rolling weekly average
      as.Date(dat$submission_date[1:length(active)]), 
      filter(active, filter= filterVector),
      col= 'red'
)
legend(
       'topleft',
       legend = c(
                  'daily', 'rolling weekly average', 
                  'quadratic fit', "Euler method from growth rate fit",
                  'oldest currently active', today_str, 'months', 'weeks'
                  ),
       col= c(par('fg'), 'red', 'green', 'magenta', 'blue', 'blue', 'gray', 'gray'),
       lty= c('solid', 'solid', 'dashed', 'dashed', 'dashed',  'solid', 'dashed', 'dotted'),
       bg= legendBG
)
# }}}
# growth rate {{{
#par(mar= c(2,4,1,1)) # bottom, left, top, right
print("Plotting growth rate...")
plot(
     as.Date(dat$submission_date[1:length(dailyGrowth)]), 
     dailyGrowth,
     xlim= plotWindow,
     #ylim= range(c(0, range(dailyGrowth[plotInds])*plotElbowroom)),
     ylim= range(c(0, dailyGrowth[
                                     1:length(dailyGrowth) %in% plotInds
                                 ]))*plotElbowroom,
     type='l',
     #main='Daily Growth Rate',
     #xlab= 'date',
     #ylab= expression(paste("daily growth rate of active cases \n", (dot(a)/a), " ", (days^-1) ))
     ylab= expression(
                      atop(
                           "daily growth rate of active cases", 
                           paste( (frac(da/dt,a)), " ", (days^-1) )
                           )
     )
)
drawGrids()
lines( # quadratic fit
      predictDays,
      pred_growth,
      col='green',
      lty='dashed'
)
abline(v=oldestCaseDate, col='blue', lty='dashed')
abline(h=0, lty='dashed')
lines(
      as.Date(dat$submission_date[1:length(dailyGrowth)]), 
      dailyGrowth_avg, 
      col='red', 
      lty='solid'
)
legend(
       'topleft',
       legend = c(
                  'daily', 'rolling weekly average', 
                  "quadratic fit", 
                  'oldest currently active', today_str, 'months', 'weeks'
                  ),
       col= c(par('fg'), 'red', 'green', 'blue', 'blue', 'gray', 'gray'),
       lty= c('solid', 'solid', 'dashed', 'dashed', 'solid', 'dashed', 'dotted'),
       bg= legendBG
)
# }}}

# text(x=0.5, y=0.5, labels= dashboardLink, col= par('col.lab'), adj=0.5, cex= 0.7)
#cat('some expected warnings:\n')
suppressWarnings(par(par.old))
dev.off()
# plotting }}}
