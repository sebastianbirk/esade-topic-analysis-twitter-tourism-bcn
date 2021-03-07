## Install packages (skip this part once installed!)
install.packages("sp")
install.packages("spdep")
install.packages("rgdal")
install.packages("units", type='binary')
install.packages("gdalUtils")
install.packages("tmap")

## Import packages
library(sp)
library(spdep)
library(rgdal)
library(tmap)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(data.table)
library(stringr)

## Load districts, neighbourhoods and tweets data
file1 = "../data/bcn_districts.RData"
load(file1, envir = parent.frame(), verbose = FALSE)

file2 = "../data/tweets.RData"
load(file2)

file3 = "../data/bcn_neighbourhoods.RData"
load(file3)

## Save data in dataframes to view and inspect the data
df_districts <- bcn.di@data
df_neighbourhoods <- bcn.nb@data 

# Filter tweets by English language
english_tweets <- subset(tweets, language3=="ENGLISH")

## Count tweets per district
tweets_count <- english_tweets[, .(count = .N), by = .(id_distrito)]

# Remove first characters of district column
tweets_count$id_distrito <- str_sub(tweets_count$id_distrito,-2,-1)

# Join district map and tweet count data on district level for plot
districts <- bcn.di
districts@data <- merge(districts@data, tweets_count, by.x="C_Distri", by.y="id_distrito")

# Check results
districts@data

# Remove special characters from district name
districts@data$N_Distri <- c("Ciutat Vella", "Eixample", "Sants-Montjuic", "Les Corts", "Sarria-Sant Gervasi", "Gracia", "Horta-Guinardo", "Nou Barris", "Sant Andreu", "Sant Marti")

# Create plot
qtm(districts, fill=colnames(districts@data)[12], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Number of Tweets")

# Save plot as file
dev.print(jpeg, filename="../outputs/number_of_tweets_per_district.jpg", width=1000)

## Plot map of Barcelona districts
# Create plot
qtm(districts, fill=colnames(districts@data)[2], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="Spectral"), title="Districts of Barcelona")

# Save plot as file
dev.print(jpeg, filename="../outputs/districts_of_bcn.jpg", width=1000)

# Load csv file that contains the results of the topic analysis
results = read.csv("../data/districts.csv", header = TRUE)

# Inspect the dataframe
results

# Display mean topic scores
mean(results$topic0)
mean(results$topic1)
mean(results$topic2)
mean(results$topic3)
mean(results$topic4)
mean(results$topic5)
mean(results$topic6)

# Add leading zeros for merge
results$district = list("01","02","03","04","05","06","07","08","09","10")

# Join district map and topic analysis results
districts@data <- merge(districts@data, results, by.x="C_Distri", by.y="district")

# Check dataframe
districts@data

# Plot results for topic0
qtm(districts, fill=colnames(districts@data)[14], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 0: Sightseeing")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic0_per_district.jpg", width=1000)

# Plot results for topic1
qtm(districts, fill=colnames(districts@data)[15], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 1: Summer, Sun & Friends")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic1_per_district.jpg", width=1000)

# Plot results for topic2
qtm(districts, fill=colnames(districts@data)[16], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 2: Streetart")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic2_per_district.jpg", width=1000)

# Plot results for topic3
qtm(districts, fill=colnames(districts@data)[17], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 3: Everyday Life")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic3_per_district.jpg", width=1000)

# Plot results for topic4
qtm(districts, fill=colnames(districts@data)[18], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 4: Lifestyle & Culture")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic4_per_district.jpg", width=1000)

# Plot results for topic5
qtm(districts, fill=colnames(districts@data)[19], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 5: Nightlife")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic5_per_district.jpg", width=1000)

# Plot results for topic6
qtm(districts, fill=colnames(districts@data)[20], borders="black", fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 6: Sports, Health & Image")

# Save plot as file
dev.print(jpeg, filename="../outputs/topic6_per_district.jpg", width=1000)


