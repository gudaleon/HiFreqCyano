#Goal: download high frequency (daily?) phycocyanin monitoring data and test for autocorrelation
#following example r script here: http://gleon.org/sites/default/files/pdf/meetings/G16/dataoneDataAccess.pdf

library(dataone)
library(reshape2)

mn_nodeid <- "urn:node:mnTestGLEON"
cli <- D1Client("STAGING")
setMNodeId(cli, mn_nodeid)

#Working with Texoma Data ####
library(dplyr)
library(tidyr)
oldPcy <- read.csv("Phycocyanin.csv", header=TRUE)
str(oldPcy)
#remove irrelevant columns (makes combining easier)
oldPcy <- subset(oldPcy, select=c(Date, Blue.greens.ug.l, Sample.Site))
#convert pcy to numeric
oldPcy$Blue.greens.ug.l <- as.integer(as.character(oldPcy$Blue.greens.ug.l))
#convert date to date
oldPcy$Date <- as.Date(as.character(oldPcy$Date), format="%m/%d/%Y")



newPcy <- read.csv("TCH littoral data .csv", header=TRUE)
str(newPcy)

#remove irrelevant columns (makes combining easier)
newPcy <- subset(newPcy, select=c(Date, Blue.greens.ug.l, Sample.Site))
#convert date to date
newPcy$Date <- as.Date(as.character(newPcy$Date), format="%m/%d/%Y")

#join the two dataframes
fullPcy <- full_join(oldPcy, newPcy)
names(fullPcy)

#there's inconsistency in naming of sites between databases
#remove all spaces in names to standardize
fullPcy$Sample.Site <- gsub(" ", "", fullPcy$Sample.Site, fixed = TRUE)

#now convert to factor for easier subsetting
fullPcy$Sample.Site <- as.factor(fullPcy$Sample.Site)
levels(fullPcy$Sample.Site)



brierPcy <- filter(fullPcy, Sample.Site=="L3-BrierCreek")

with(brierPcy, plot(Date, Blue.greens.ug.l), xlim=c())
