## Load packages
library(data.table)
library(tidyverse)

#####
# Functions
# we need to label repeat and switch trials

# given a string of numbers from pavlovia experiment, makes an array and ONLY RETURNS THE SECOND VALUE
online_string_to_array <- function(str_array){
  
  x <- str_sub(str_array, 2, str_length(str_array)-1) # subset string to get rid of beginning and end
  x <- simplify(lapply(str_split(x, ','), as.double)) # make this a list of doubles (simplify gets rid of unnecessary levels)
  
  x <- x[2] # we only need the second value
  return(x)
}


#####
# Do stuff

data_folder <- "misc"
data_path <- list.files(path = data_folder,
                        pattern = glob2rx(paste("*", ".csv", sep = "")),
                        full.names = TRUE)
# load in one data file using the above file path
df <- fread(file = data_path, header = TRUE)

# apply a function (see above for details) that outputs the y-value of the stimulus location for each trial from the pavlovia string
df$grid_loc_y <- apply(df[ , 'gridLocation'], 
                     1, FUN = online_string_to_array)

df <- df %>% 
  mutate(grid_diff = lag(grid_loc_y) + grid_loc_y) %>%
  mutate(switch = recode(grid_diff, 
                           "0" = "1",
                           .default = "0")) %>% # using the current and prev trial's y-locs to determine if a rule switch happened
  select(-grid_diff, # remove the grid_diff column since we don't need it any more
         -contains("phase")) # I got rid of those "phase" columns cause they don't seem to be well labeled for stats purposes

# you probably want to label a few other things for doing stats, like correct vs incorrect, or practice vs real trials



#####
# Testing



