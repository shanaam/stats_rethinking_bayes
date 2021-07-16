## Load packages
library(data.table)
library(tidyverse)

#####
# Functions
# we need to label repeat and switch trials
# input <- 
apply_rep_sw <- function(df_row){
  
}


# given a string of numbers from pavlovia experiment, makes an array and ONLY RETURNS THE FIRST VALUE
online_string_to_array <- function(str_array){
  
  x <- str_sub(str_array, 2, str_length(str_array)-1) # subset string to get rid of beginning and end
  x <- simplify(lapply(str_split(x, ','), as.double)) # make this a list of doubles (simplify gets rid of unnecessary levels)
  
  x <- x[1]
  return(x)
}

apply_switch <- function(grid_dff){
  recode(grid_diff, 0 = "0", 0.25 = "1", -0.25 = "1")
}

#####
# Do stuff

data_folder <- "misc"
data_path <- list.files(path = data_folder,
                        pattern = glob2rx(paste("*", ".csv", sep = "")),
                        full.names = TRUE)

df <- fread(file = data_path)


df$grid_loc_x <- apply(df[ , 'gridLocation'], 
                     1, FUN = online_string_to_array)

df <- mutate(df, grid_diff = lag(grid_loc_x) + grid_loc_x)

df <- mutate(df, switch = recode(grid_diff, 
                           "0" = "0",
                           .default = "1"))

#####
# Testing



