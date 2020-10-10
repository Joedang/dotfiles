#!/usr/bin/Rscript

#print('This is ~/.Rprofile')
# A good resource for .Rprofile tips can be found here:
# https://www.r-bloggers.com/fun-with-rprofile-and-customizing-r-startup/

# when on the Chromebook, change the default device to CairoPNG:
if (Sys.info()['nodename']=='localhost')
	options(device= Cairo::CairoPNG)

# set the default mirror
options(repos=c(CRAN="https://ftp.osuosl.org/pub/cran"))

# fancy prompt
#options(prompt='[32mR➔ [39m') # doesn't count characters correctly
#options(prompt='[32mR➔1234567890 [39m') # counts correctly for some reason
#options(prompt='\033[32mR➔ \033[39m') # doesn't count characters correctly
#options(prompt='\033[32m╭── R\033[39m\n ') # it knows how to handle newlines, which lets me sidestep the issue, lol...
options(prompt='\001\033[32m\002R➔ \001\033[39m\002') # \001 and \002 delimit zero-width characters per readline.h

options(width='120') # wider terminal output
options(pdfviewer='zathura') # wider terminal output

source('~/.Renviron')
