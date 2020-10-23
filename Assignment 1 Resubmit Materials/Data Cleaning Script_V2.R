#changed the degree symbol to a % manually because it was doing very weird and unpredictable things

#first, read in the data from the CSV files
audubon_data <- read.csv("audubon_data.csv", row.names = 1) #actually I don't need readr
gw_data <- read.csv("gw_data.csv", row.names = 1)
nat_geo_data <- read.csv("nat_geo_data.csv", row.names = 1)

#clean audubon data
audubon_data = na.omit(audubon_data) #get rid of incomplete observations
#dates
audubon_data$Date = as.Date(audubon_data$Date, format = "%m/%d/%y") #put it into date format
audubon_data = audubon_data[(audubon_data$Date > "2009-12-31"),] #filter dates to after 2010
#longitude - just delete the W
audubon_data$Longitude = as.numeric(gsub("W","-",audubon_data$Longitude)) #west = negative, in decimal degrees
#latitude - just delete the N
audubon_data$Latitude = as.numeric(gsub("N","",audubon_data$Latitude)) #north = positive, in decimal degrees
#keep only transects
audubon_data = audubon_data[(grep("transect",audubon_data$Survey_Type,ignore.case = TRUE)),] #keep only things with transect in it
audubon_data <- audubon_data[!grepl("nontransect", audubon_data$Survey_Type),] #get rid of "nontransect"
audubon_data$Survey_Type = "transect" #make it uniform
#check if all the points are in the same range
summary(audubon_data$Longitude) #yep it's fine
#add a column for remembering it's from audubon
audubon_data$DataID = "audubon_data"

#clean gw data
gw_data = na.omit(gw_data) #get rid of incomplete observations
#dates
gw_data$Date = as.Date(gw_data$Date, format = "%d-%b-%y") #the correct date format 
gw_data = gw_data[(gw_data$Date > "2009-12-31"),] #filter to after 2010
#longitude - get rid of the W, then add first two char + (4 to end)/60 * -1
gw_data$Longitude = gsub("'W","",gw_data$Longitude) #get rid of the 'W
gw_data$Longitude = as.numeric(substr(gw_data$Longitude, 1, 2)) + #the first two numbers, as numbers
                          (as.numeric(substr(gw_data$Longitude, 4, nchar(gw_data$Longitude)))/60) #the minutes and seconds, /60
gw_data$Longitude = gw_data$Longitude*-1 #because W is negative
#latitude - get rid of the N, then add first two char + (4 to end)/60 * -1
gw_data$Latitude = gsub("'N","",gw_data$Latitude) #get rid of the 'N
gw_data$Latitude = as.numeric(substr(gw_data$Latitude, 1, 2)) + #the first two numbers, as numbers
  (as.numeric(substr(gw_data$Latitude, 4, nchar(gw_data$Latitude)))/60) #the minutes and seconds, /60
#keep only transects
gw_data = gw_data[(grep("transect",gw_data$Survey_Type,ignore.case = TRUE)),] #keep only things with transect in it
gw_data <- gw_data[!grepl("nontransect", gw_data$Survey_Type),] #get rid of "nontransect"
gw_data$Survey_Type = "transect" #make it uniform
#check if all the points are in the same range
summary(gw_data$Longitude) #yep it's fine
#add a column for remembering it's from gw
gw_data$DataID = "gw_data"

#clean nat geo data
nat_geo_data = na.omit(nat_geo_data) #get rid of incomplete observations
#dates
nat_geo_data$Date = as.Date(nat_geo_data$Date, format = "%Y-%m-%d") #the correct date format 
nat_geo_data = nat_geo_data[(nat_geo_data$Date > "2009-12-31"),] #filter to after 2010
#latitude and longitude appear to be okay already
#keep only transects
nat_geo_data = nat_geo_data[(grep("transect",nat_geo_data$Survey_Type,ignore.case = TRUE)),] #keep only things with transect in it
nat_geo_data <- nat_geo_data[!grepl("nontransect", nat_geo_data$Survey_Type),] #get rid of "nontransect"
nat_geo_data$Survey_Type = "transect" #make it uniform
#check if all the points are in the same range
summary(nat_geo_data$Longitude) #nope, max is 38.93 which means there are some incorrect points!
nat_geo_data[which(nat_geo_data$Longitude >= 0), ] #looks like the longitude and latitude are swapped
to_swap = nat_geo_data[which(nat_geo_data$Longitude >= 0), ] #the points that are swapped
nat_geo_data$Latitude[which(nat_geo_data$Longitude >= 0)] = to_swap$Longitude #swapped back!
nat_geo_data$Longitude[which(nat_geo_data$Longitude >= 0)] = to_swap$Latitude #swapped back!
#add a column for remembering it's from nat geo
nat_geo_data$DataID = "nat_geo_data"


#now put it all together
all_data = rbind(audubon_data, gw_data, nat_geo_data)
write.csv(all_data, "~/Desktop/Ellen/Georgetown courses/BIO-442/Assignment 1/my_clean_data.csv")
