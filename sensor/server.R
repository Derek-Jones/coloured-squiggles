# server.R
#
# AEC hackathon, 10 Jul 16

library("colorspace")
library(lubridate)
library("jsonlite")
library(shiny)


mk_plot=function(start_date, end_date)
# Setup plotting outline
{
start_date=as.POSIXct(start_date, format="%Y-%m-%d")
end_date=as.POSIXct(end_date, format="%Y-%m-%d")
# For today's data we only want to display up until now, not the end of the day
# "2016-07-10 11:44:02 BST"
now_date=as.POSIXct(Sys.time(), format="%Y-%m-%d %H:%M:%S")

end_date=ifelse(end_date < now_date, end_date, now_date)

# print(c(as.numeric(start_date), as.numeric(end_date)))
# print(as.numeric(end_date)-as.numeric(start_date))

plot(0, type="n", las=1,
	xlim=c(0, (as.numeric(end_date)-as.numeric(start_date))/60), ylim=c(0, 1),
	xlab="Minutes", ylab="Normalised value")
}

add_info=function(info_j, col_str="black", start_date)
# Add a line of sensor data
{
info_j$time=as.POSIXct(info_j$readings[, 1], format=time_format)
# print(c(head(info_j$time), as.POSIXct(start_date, format="%Y-%m-%d")))
info_j$secs=info_j$time-as.POSIXct(start_date, format="%Y-%m-%d")
info_j$data=as.numeric(info_j$readings[, 2])
info_j$norm_data=info_j$data-min(info_j$data)
info_j$norm_data=info_j$norm_data/max(info_j$norm_data)

lines(as.numeric(info_j$secs)/60, info_j$norm_data, col=col_str)
}


get_info=function(start_date="2016-07-09", end_date="2016-07-10", device_id, sensor_id)
{
# print(c(device_id, sensor_id))
api_str=paste0("https://api.smartcitizen.me/v0/devices/", device_id, "/readings?sensor_id=")
date_str=paste0("&rollup=1m&from=", start_date, "&to=", end_date)

# print(paste0(api_str, sensor_id, date_str))
t=fromJSON(paste0(api_str, sensor_id, date_str))

# print(str(t))

# t=list(
# 	lux_info=fromJSON(paste0(api_str, 14, date_str)),
# 	hum_info=fromJSON(paste0(api_str, 13, date_str)),
# 	NO2_info=fromJSON(paste0(api_str, 15, date_str)),
# 	CO_info=fromJSON(paste0(api_str, 16, date_str)),
# 	snd_info=fromJSON(paste0(api_str, 7, date_str))
# 	)

return(t)
}


# plot_sen_info=function(s_info, start_date)
# {
# pal_col=rainbow(5)
# 
# plot_info(d_info$lux_info, pal_col[1], start_date)
# add_info(d_info$hum_info, pal_col[5], start_date)
# add_info(d_info$NO2_info, pal_col[3], start_date)
# add_info(d_info$CO_info, pal_col[4], start_date)
# add_info(d_info$snd_info, pal_col[2], start_date)
# }


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


plot_legend=function(sensor_list)
{
num_sensors=length(sensor_list)
pal_col=rainbow(num_sensors)

plot(0, xlim=c(0, 2), ylim=c(0, num_sensors), type="n", bty="n", xaxt="n", yaxt="n",
	xlab="", ylab="")

for (s_num in seq(1:num_sensors))
   text(1, s_num, map_sen_id[as.numeric(sensor_list[s_num])], col=pal_col[s_num], pos=4, cex=1.5)
}


time_format="%Y-%m-%dT%H:%M:%S"
# map from local device number to smart citizen device number
map_dev_id=c(3599, 3598, 3437, 3585, 3586, 3587, 3588, 3589, 3590, 3591, 3592, 3593, 3594, 3595, 3596)
map_sen_id=c(
		"", "", "", "", "", "",
		"Noise level", # 7
		"", "", "", "",
		"Temperature", # 12
		"Humidity", # 13
		"Light level", # 14
		"Nitrogen dioxide", # 15
		"Carbon monoxide", # 16
		"Battery", # 17
		"Solar panel", # 18
		"", "",
		"Networks" #21
		)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  #  1) It is "reactive" and therefore should re-execute automatically
  #     when inputs change
  #  2) Its output type is a plot

  output$distPlot <- renderPlot({

# print(input$dev_id)
# print(input$dates)
# print(input$sensor_list)

	num_sensors=length(input$sensor_list)
	pal_col=rainbow(num_sensors)
# The API works forward from the beginning of start_date
	start_date=input$dates[1]
	end_date=input$dates[2]
# The API requires the end date to be the start of the day after
	end_date=as.character(as.Date(end_date)+days(1))
	# dev_info=get_info(start_date, end_date, 3599)
	mk_plot(start_date, end_date)
	for (s_num in seq(1:num_sensors))
	   {
	   sen_info=get_info(start_date, end_date,
			device_id=map_dev_id[1+as.numeric(input$dev_id)],
	   		as.numeric(input$sensor_list[s_num]))
	   add_info(sen_info, pal_col[s_num], start_date)
	   }
  })

  output$distLegend <- renderPlot({
	plot_legend(input$sensor_list)
  })

})

