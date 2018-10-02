## install packages (skip this part once installed!)
install.packages("sp")
install.packages("spdep")
install.packages("rgdal")
install.packages("units", type='binary')
install.packages("gdalUtils")
install.packages("tmap")

## import packages
library(sp)
library(spdep)
library(rgdal)
library(tmap)
library(RColorBrewer)
library(dplyr)
library(ggplot2)
library(data.table)
library(stringr)

## load districts, neighbourhoods and tweets data
file1 = "bcn_districts.RData"
load(file1, envir = parent.frame(), verbose = FALSE)

file2 = "tweets.RData"
load(file2)

file3 = "bcn_neighbourhoods.RData"
load(file3)

## save data in dataframes to view and inspect the data
df_districts <- bcn.di@data
df_neighbourhoods <- bcn.nb@data 

## count tweets per district
tweets_count <- tweets[, .(count = .N), by = .(id_distrito)]
# remove first characters of district column
tweets_count$id_distrito <- str_sub(tweets_count$id_distrito,-2,-1)

# join district map and tweet count data on district level for plot
districts <- bcn.di
districts@data <- merge(districts@data, tweets_count, by.x="C_Distri", by.y="id_distrito")
# check results
districts@data
# create plot
qtm(districts, fill=colnames(districts@data)[12], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Number of Tweets")
# save plot as file
dev.print(jpeg, filename="number_of_tweets_per_district.jpg", width=1000)

# load csv file that contains the results of the topic analysis
results = read.csv("districts.csv", header = TRUE)
# inspect the dataframe
results
# add leading zeros for merge
results$district = list("01","02","03","04","05","06","07","08","09","10")

# join district map and topic analysis results
districts@data <- merge(districts@data, results, by.x="C_Distri", by.y="district")
# check dataframe
districts@data

# plot results for topic0
qtm(districts, fill=colnames(districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 0: Sightseeing")
# save plot as file
dev.print(jpeg, filename="topic0_per_district.jpg", width=1000)

# plot results for topic1
qtm(districts, fill=colnames(districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 1: Summer, Sun & Friends")
# save plot as file
dev.print(jpeg, filename="topic1_per_district.jpg", width=1000)

# plot results for topic2
qtm(districts, fill=colnames(districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 2: Streetart")
# save plot as file
dev.print(jpeg, filename="topic2_per_district.jpg", width=1000)

# plot results for topic3
qtm(districts, fill=colnames(districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 3: Everyday Life")
# save plot as file
dev.print(jpeg, filename="topic3_per_district.jpg", width=1000)

# plot results for topic4
qtm(districts, fill=colnames(districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 4: Lifestyle & Culture")
# save plot as file
dev.print(jpeg, filename="topic4_per_district.jpg", width=1000)

# plot results for topic5
qtm(districts, fill=colnames(districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 5: Nightlife")
# save plot as file
dev.print(jpeg, filename="topic5_per_district.jpg", width=1000)

# plot results for topic6
qtm(districts, fill=colnames(districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), title="Topic 6: Sports, Health & Image")
# save plot as file
dev.print(jpeg, filename="topic6_per_district.jpg", width=1000)


