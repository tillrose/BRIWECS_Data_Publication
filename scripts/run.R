# install necessary packages
source(file.path("scripts/pre-processing","set_up.R"))
# combined raw data and remove outlier
source(file.path("scripts/pre-processing","data_cleaning.R"))
# combined management files
source(file.path("scripts/pre-processing","extract_management.R"))