#!/usr/bin/env bash
# Report the AQI in your specified area.
# Output XML meant for consumption by the xfce4-genmon-plugin.
# https://docs.xfce.org/panel-plugins/xfce4-genmon-plugin
# You can get feeds for other areas here: https://docs.airnowapi.org/feeds
# Info on interpreting AQI can be found here: https://docs.airnowapi.org/docs/AirNowAPIFactSheet.pdf
# This isn't super relevant now that the fires are going out.
# Joe Shields, 2020-09-14
function getAQI() {
    curl -sS $1 | grep -oPe '[[:digit:]]*(?= AQI - Particle Pollution \(2.5 microns\))|unavailable'
}
aqi=$(getAQI http://feeds.airnowapi.org/rss/realtime/737.xml)
updated=$(date -Iseconds)
if [ -z "$aqi" ]; then
    echo no AQI retrieved
    status='empty AQI'
elif [ "$aqi" = 'unavailable' ]; then
    aqi='??'
    fg='black'
    bg='darkgray'
    status='AQI unavailable'
elif [ "$aqi" -le 50 ]; then
    fg=black
    bg=green
    status='Good'
elif [ "$aqi" -le 100 ]; then
    fg=black
    bg=yellow
    status='Moderate'
elif [ "$aqi" -le 150 ]; then
    fg=black
    bg=orange
    status='Unhealthy for Sensitive Groups'
elif [ "$aqi" -le 200 ]; then
    fg=white
    bg=red
    status='Unhealthy'
elif [ "$aqi" -le 300 ]; then
    fg=black
    bg=purple
    status='Very Unhealthy'
else
    fg=white
    bg=maroon
    status='Hazardous'
fi
echo -en "<txt>AQI\n<span weight='Bold' foreground='$fg' background='$bg'> $aqi </span></txt>"
echo -en "<tool>current AQI in Beaverton for 2.5 µm particle pollution\nstatus: $status\nupdated $updated</tool>"
echo -en '<txtclick>firefox https://s3-us-west-1.amazonaws.com//files.airnowtech.org/airnow/today/cur_aqi_portland_or.jpg</txtclick>'
