Sys.setlocale("LC_CTYPE", "German")

require(jsonlite)

setwd("c:/Projects/Carsharing/datasets/car2go-muc")

files <- list.files(pattern = ".json")

all_vehicles_df <- data.frame(
  filename = character(0),
  name = character(0),
  fuelLevel = numeric(0), 
  address = character(0),
  engineType = character(0),
  exterior = character(0),
  interior = character(0),
  vin = character(0),
  smartphoneRequired = character(0),
  lat = numeric(0),
  lng = numeric(0)
)

write.table(all_vehicles_df, "all_vehicles_df.csv", col.names=TRUE, row.names = FALSE, sep=",")

for (fileCount in seq_along(files)) {

  filename <- files[fileCount]
  
  #print progress
  print(paste(fileCount," -- ",filename))
  
  json_data <- fromJSON(filename)
  
  available_vehicles_df <- json_data$placemarks
  
  if (length(available_vehicles_df) > 0) {
    vehicles_df <- data.frame(
      #datetime = strptime(substr(filename, 1, 18), "%Y-%m-%dT%H_%M_%S", tz="Europe/Berlin"),
      filename = substr(filename, 14, 32),
      name = available_vehicles_df$name,
      fuelLevel = available_vehicles_df$fuel, 
      address = available_vehicles_df$address,
      #coordinates = c(available_vehicles_df$coordinates)[1],
      engineType = available_vehicles_df$engineType,
      exterior = available_vehicles_df$exterior,
      interior = available_vehicles_df$interior,
      vin = available_vehicles_df$vin,
      smartphoneRequired = available_vehicles_df$smartPhoneRequired   
    )
    
    coordinates <- as.data.frame(available_vehicles_df$coordinates)
    coordinates <- t(coordinates)
    colnames(coordinates)<-c("lng", "lat", "Column3")
    coordinates <- as.data.frame(coordinates)
    
    vehicles_df$lat <- coordinates$lat
    vehicles_df$lng <- coordinates$lng
    
    write.table(vehicles_df, "all_vehicles_df.csv", col.names=FALSE, row.names = FALSE, sep=",",append = TRUE)
  }
}



