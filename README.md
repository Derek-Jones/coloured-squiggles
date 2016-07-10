
Code is all in R and uses shiny for client/server browser interface

To run the system, at the R studio command line type (you probably need to modify the path):
runApp("/Users/plagchk/coloured-squiggles/sensor")

The following packages need to be installed: colorspace, lubridate, jsonlite and shiny.

The device mapping is from the 15 Intel Photon+sensors boards installed in the building used
for the AEC hackathon.

For other devices see: https://smartcitizen.me website

The API is here (all open data in json format, no key required)
https://api.smartcitizen.me

Here is one of the devices:
https://api.smartcitizen.me/v0/devices/3452

