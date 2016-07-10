#
# sensor-9.R
#
# AEC hackathon,  9 Jul 16

library("colorspace")
library("jsonlite")

plot_info=function(info_j, col_str="black")
{
info_j$time=as.POSIXct(info_j$readings[, 1], format=time_format)
info_j$secs=info_j$time-as.POSIXct(info_j$from, format=time_format)
info_j$data=as.numeric(info_j$readings[, 2])
info_j$norm_data=info_j$data-min(info_j$data)
info_j$norm_data=info_j$norm_data/max(info_j$norm_data)

plot(as.numeric(info_j$secs), info_j$norm_data, type="l", col=col_str,
	xlab="Seconds")
}


add_info=function(info_j, col_str="black")
{
info_j$time=as.POSIXct(info_j$readings[, 1], format=time_format)
info_j$secs=info_j$time-as.POSIXct(info_j$from, format=time_format)
info_j$data=as.numeric(info_j$readings[, 2])
info_j$norm_data=info_j$data-min(info_j$data)
info_j$norm_data=info_j$norm_data/max(info_j$norm_data)

lines(as.numeric(info_j$secs), info_j$norm_data, col=col_str)
}

time_format="%Y-%m-%dT%H:%M:%S"

get_info=function(device_id)
{
api_str=paste0("https://api.smartcitizen.me/v0/devices/", device_id, "/readings?sensor_id=")
date_str="&rollup=1m&from=2016-07-08&to=2016-07-10"

t=list(
	lux_info=fromJSON(paste0(api_str, 14, date_str)),
	hum_info=fromJSON(paste0(api_str, 13, date_str)),
	NO2_info=fromJSON(paste0(api_str, 15, date_str)),
	CO_info=fromJSON(paste0(api_str, 16, date_str)),
	snd_info=fromJSON(paste0(api_str, 7, date_str))
	)

return(t)
}


plot_dev_info=function(d_info)
{
pal_col=rainbow(5)

plot_info(d_info$lux_info, pal_col[1])
add_info(d_info$hum_info, pal_col[5])
add_info(d_info$NO2_info, pal_col[3])
add_info(d_info$CO_info, pal_col[4])
add_info(d_info$snd_info, pal_col[2])
}

dev_3591=get_info(3591) # 9
plot_dev_info(dev_3591)

dev_3599=get_info(3599) # 0
plot_dev_info(dev_3599)

dev_3594=get_info(3594) # 12
plot_dev_info(dev_3594)

dev_3588=get_info(3588) # 6
plot_dev_info(dev_3588)

dev_3585=get_info(3585) # 3
plot_dev_info(dev_3585)

dev_3589=get_info(3589) # 7
plot_dev_info(dev_3589)

dev_3590=get_info(3590) # 8
plot_dev_info(dev_3590)

dev_3592=get_info(3592) # 10
plot_dev_info(dev_3592)

plot(0, xlim=c(0, 2), ylim=c(-1, 5), type="n")
text(1, 0, "lux_info", col=pal_col[1])
text(1, 1, "hum_info", col=pal_col[5])
text(1, 2, "NO2_info", col=pal_col[3])
text(1, 3, "CO_info", col=pal_col[4])
text(1, 4, "snd_info", col=pal_col[2])

library(shiny)
runExample("01_hello")

