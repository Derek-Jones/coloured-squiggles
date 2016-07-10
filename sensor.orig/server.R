# server.R
#
# AEC hackathon,  9 Jul 16

library("colorspace")
library(lubridate)
library("jsonlite")
library(shiny)


plot_info=function(info_j, col_str="black", start_date)
{
info_j$time=as.POSIXct(info_j$readings[, 1], format=time_format)
info_j$secs=info_j$time-as.POSIXct(start_date, format="%Y-%m-%d")
info_j$data=as.numeric(info_j$readings[, 2])
info_j$norm_data=info_j$data-min(info_j$data)
info_j$norm_data=info_j$norm_data/max(info_j$norm_data)

plot(as.numeric(info_j$secs), info_j$norm_data, type="l", col=col_str,
	xlab="Seconds", ylab="Normalised value")
}

add_info=function(info_j, col_str="black", start_date)
{
info_j$time=as.POSIXct(info_j$readings[, 1], format=time_format)
info_j$secs=info_j$time-as.POSIXct(start_date, format="%Y-%m-%d")
info_j$data=as.numeric(info_j$readings[, 2])
info_j$norm_data=info_j$data-min(info_j$data)
info_j$norm_data=info_j$norm_data/max(info_j$norm_data)

lines(as.numeric(info_j$secs), info_j$norm_data, col=col_str)
}

time_format="%Y-%m-%dT%H:%M:%S"

get_info=function(start_date="2016-07-09", end_date="2016-07-10", device_id)
{
# print(device_id)
api_str=paste0("https://api.smartcitizen.me/v0/devices/", device_id, "/readings?sensor_id=")
date_str=paste0("&rollup=1m&from=", start_date, "&to=", end_date)

t=list(
	lux_info=fromJSON(paste0(api_str, 14, date_str)),
	hum_info=fromJSON(paste0(api_str, 13, date_str)),
	NO2_info=fromJSON(paste0(api_str, 15, date_str)),
	CO_info=fromJSON(paste0(api_str, 16, date_str)),
	snd_info=fromJSON(paste0(api_str, 7, date_str))
	)

return(t)
}


plot_dev_info=function(d_info, start_date)
{
pal_col=rainbow(5)

plot_info(d_info$lux_info, pal_col[1], start_date)
add_info(d_info$hum_info, pal_col[5], start_date)
add_info(d_info$NO2_info, pal_col[3], start_date)
add_info(d_info$CO_info, pal_col[4], start_date)
add_info(d_info$snd_info, pal_col[2], start_date)
}


# dev_3591=get_info(device_id=3591) # 9
# plot_dev_info(dev_3591, start_date="2016-07-09")

# dev_3599=get_info(device_id=3599) # 0
# plot_dev_info(dev_3599)

# dev_3594=get_info(3594) # 12
# plot_dev_info(dev_3594)

# dev_3588=get_info(3588) # 6
# plot_dev_info(dev_3588)

# dev_3585=get_info(3585) # 3
# plot_dev_info(dev_3585)

# dev_3589=get_info(3589) # 7
# plot_dev_info(dev_3589)

# dev_3590=get_info(3590) # 8
# plot_dev_info(dev_3590)

# dev_3592=get_info(3592) # 10
# plot_dev_info(dev_3592)


plot_legend=function()
{
plot(0, xlim=c(0, 6), ylim=c(0, 1), type="n", bty="n", xaxt="n", yaxt="n", xlab="", ylab="")
text(1, 1, "Light level", col=pal_col[1], pos=2)
text(1.7, 1, "Humidity", col=pal_col[5], pos=2)
text(2.9, 1, "Nitrogen dioxide", col=pal_col[3], pos=2)
text(4.2, 1, "Carbon monoxide", col=pal_col[4], pos=2)
text(5, 1, "Noise level", col=pal_col[2], pos=2)
}


map_dev_id=c(3599, 3598, 3437, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3594, 3595, 3596)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  output$distPlot <- renderPlot({

	# print(input$dev_id)

    # print(input$dates)
# The API works forward from the beginning of start_date
	start_date=input$dates[1]
	end_date=input$dates[2]
# The API requires the end date to be the start of the day after
	end_date=as.character(as.Date(end_date)+days(1))
	# dev_info=get_info(start_date, end_date, 3599)
	dev_info=get_info(start_date, end_date,
			device_id=map_dev_id[1+as.numeric(input$dev_id)])
        plot_dev_info(dev_info, start_date)
  })

  output$distLegend <- renderPlot({
	plot_legend()
  })

})

