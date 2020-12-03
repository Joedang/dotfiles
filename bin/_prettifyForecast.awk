#!/sbin/awk -f
# take a NOAA forecast page and format it for a terminal
# Joe Shields, 2020-11-22

# initialize variables
BEGIN {
    intarget=0
    conditions=""
    i=0
    #while ("curl https://forecast.weather.gov/MapClick.php\?lat\=45.5\&lon\=-122.8" | getline){print}
}

# only look at stuff between these patterns
/<!-- 7-Day Forecast -->/{ intarget=1 } # beginning of target area
/text\/javascript/{ intarget=0 } # end of target area

# initialize the string of emojis
/<p class="period-name">/ { conditions = "" }

{ # perform a bunch of substitutions
    if (intarget==1){
        #sub(/$/, "\033[20;22;24;39m") # at end of each line, reset attributes, bold, underline, and fg color
        # reformat relevant tags
        gsub(/<p class="period-name">/, "\033[39;4;22m") # default fg; underline; reset bold
        gsub(/<p class="temp temp-high">/, "\033[91;22m") # light red; reset bold
        gsub(/<p class="temp temp-low">/, "\033[96;22m") # light cyan; reset bold
        # add on the emojis
        gsub(/<p class="short-desc">/, "\033[24mCONDITIONS\033[1m ") #  reset underline; placeholder for emojis; bold
        gsub(/<[^>]*>/, " ") # remove tags
        sub(/^\s*/, "") # remove leading whitespace
        gsub(/\s+/, " ") # contract whitespace
        sub(/\s$/, "") # remove trailing whitespace
        gsub(/&deg;/, "°") # literal degree sign
    }
    else { next }
}

# create a string of emojois based on weather conditions
/Fog/ { conditions = "🌁" conditions }
/Mist/ { conditions = "🌫" conditions }
/Snow/ { conditions = "❄" conditions }
/Ice/ { conditions = "🧊" conditions }
#/(Mostly|Partly) (Cloudy|Sun)/ { conditions = "⛅" conditions }
/Cloud/ { conditions = "☁" conditions }
/(Sun[^d]|Clear)/ { conditions = "🌞" conditions } # avoid matching "Sunday"
/Wind/ { conditions = "💨" conditions }
/Shower/ { conditions = "🚿" conditions }
/Rain/ { conditions = "💦" conditions }
/Warning/ { conditions = "❗" conditions }
/Alert/ { conditions = "❗" conditions }
/Advisory/ { conditions = "❗" conditions }
/CONDITIONS/ { 
    sub("CONDITIONS", conditions) # add in the emojis

    # color freezing temperatures
    if ($(NF-1) <= 32) { # if the temperature is freezing
        $(NF-2) = "\033[48;5;17m" $(NF-2) # blue bg for the temperature
        $(NF) = $(NF) "\033[49m" # turn off highlighting at the end of the line
    }
}

# join the "Extended Forecast" heading with the location name
/Extended Forecast/ { 
    heading=$0
    headingLine=NR
    sub(/^.*$/, "") # clear the line
}
(NR == headingLine+2){ sub(/^/, "\033[1m"heading": \033[32m") } # bold line; green location

!/^$/ { print } # only print non-empty lines
