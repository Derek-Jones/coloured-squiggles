
Software created at a hackathon in London, July 2016:
http://aechackathon.com/london-2/

Code is all in R and uses Rstudio+shiny for the client/server browser interface.

To run the system, at the R studio command line type (you probably need to modify the path):

runApp("/Users/plagchk/coloured-squiggles/sensor")

The following packages need to be installed: colorspace, lubridate, jsonlite and shiny.

The device mapping is from the 15 Intel Photon+ Smartcitizen sensor kits installed in the
building used for the AEC hackathon.

For other devices see: https://smartcitizen.me website

The API is here (all open data in json format, no key required):
https://api.smartcitizen.me

Here is one of the devices:
https://api.smartcitizen.me/v0/devices/3452

