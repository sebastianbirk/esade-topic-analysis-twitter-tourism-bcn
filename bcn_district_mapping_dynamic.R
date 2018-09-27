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
library(grid)

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

# load csv file that contains the results of the dynamic topic analysis
res = read.csv("month_districts.csv", header = TRUE)
# inspect the dataframe
res
# add leading zeros for merge
res$district = rep(list("01","02","03","04","05","06","07","08","09","10"),6)

# find max values for each topic
max0 <- max(res$topic0)
max1 <- max(res$topic1)
max2 <- max(res$topic2)
max3 <- max(res$topic3)
max4 <- max(res$topic4)
max5 <- max(res$topic5)
max6 <- max(res$topic6)

# extract months
jun <- res[1:10,]
jul <- res[11:20,]
aug <- res[21:30,]
sep <- res[31:40,]
oct <- res[41:50,]
nov <- res[51:60,]

# join district map and topic analysis results for june
june_districts <- bcn.di
june_districts@data <- merge(june_districts@data, jun, by.x="C_Distri", by.y="district")
# check dataframe
june_districts@data

# join district map and topic analysis results for july
july_districts <- bcn.di
july_districts@data <- merge(july_districts@data, jul, by.x="C_Distri", by.y="district")
# check dataframe
july_districts@data

# join district map and topic analysis results for august
august_districts <- bcn.di
august_districts@data <- merge(august_districts@data, aug, by.x="C_Distri", by.y="district")
# check dataframe
august_districts@data

# join district map and topic analysis results for september
september_districts <- bcn.di
september_districts@data <- merge(september_districts@data, sep, by.x="C_Distri", by.y="district")
# check dataframe
september_districts@data

# join district map and topic analysis results for october
october_districts <- bcn.di
october_districts@data <- merge(october_districts@data, oct, by.x="C_Distri", by.y="district")
# check dataframe
october_districts@data

# join district map and topic analysis results for november
november_districts <- bcn.di
november_districts@data <- merge(november_districts@data, nov, by.x="C_Distri", by.y="district")
# check dataframe
november_districts@data

## plot results for topic 0
current_topic_max = max0
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[14], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic0_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[14], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic0_per_month_per_district.jpg", width=1000)

## plot results for topic 1
current_topic_max = max0
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[15], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic1_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[15], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic1_per_month_per_district.jpg", width=1000)

## plot results for topic 2
current_topic_max = max2
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[16], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic2_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[16], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic2_per_month_per_district.jpg", width=1000)

## plot results for topic 3
current_topic_max = max3
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[17], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic3_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[17], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic3_per_month_per_district.jpg", width=1000)

## plot results for topic 4
current_topic_max = max4
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[18], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic4_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[18], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic4_per_month_per_district.jpg", width=1000)

## plot results for topic 4
current_topic_max = max5
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[19], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic5_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[19], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic5_per_month_per_district.jpg", width=1000)

## plot results for topic 4
current_topic_max = max6
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[20], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic6_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[20], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic6_per_month_per_district.jpg", width=1000)

## plot results for topic 7
current_topic_max = max7
manual_scale = c(0, current_topic_max*0.1, current_topic_max*0.2, current_topic_max*0.3, current_topic_max*0.4, current_topic_max*0.5, current_topic_max*0.6, current_topic_max*0.7, current_topic_max*0.8, current_topic_max*0.9, current_topic_max)

plot0 <- qtm(june_districts, fill=colnames(june_districts@data)[21], borders='black', 
             fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=2, title="June", fill.style="fixed", fill.breaks=manual_scale, legend.only=TRUE) 

grid.newpage()
print(plot0, vp = vplayout(1, 1))

# save plot as file
dev.print(jpeg, filename="topic7_per_month_per_district_legend.jpg", width=1000)

plot1 <- qtm(june_districts, fill=colnames(june_districts@data)[21], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="June", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot2 <- qtm(july_districts, fill=colnames(july_districts@data)[21], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="July", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot3 <- qtm(august_districts, fill=colnames(august_districts@data)[21], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="August", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot4 <- qtm(september_districts, fill=colnames(september_districts@data)[21], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="September", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot5 <- qtm(october_districts, fill=colnames(october_districts@data)[21], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="October", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)
plot6 <- qtm(november_districts, fill=colnames(november_districts@data)[21], borders='black', fill.n=10, fill.palette=brewer.pal(n=10, name="YlOrRd"), scale=1, title="November", fill.style="fixed", fill.breaks=manual_scale) + tm_legend(show=FALSE)

# prepare multiple plots
grid.newpage()
pushViewport(viewport(layout=grid.layout(2,3)))
print(plot1, vp = vplayout(1, 1))
print(plot2, vp = vplayout(1, 2))
print(plot3, vp = vplayout(1, 3))
print(plot4, vp = vplayout(2, 1))
print(plot5, vp = vplayout(2, 2))
print(plot6, vp = vplayout(2, 3))

# save plot as file
dev.print(jpeg, filename="topic7_per_month_per_district.jpg", width=1000)