---
title       : Storm Data Explorer 
subtitle    : Developing Data Products Course Project 
author      : Ajit Nambissan
job         : 
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : []            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides

--- .class #id 

## Storm Data Explorer



- Created as part of Developing Data Products Course Project

- The application is built using shiny

- The presentation is created using slidify


--- 

## The Application



- Application provides a user friendly way to explore the Storm Data

- The Storm data from 1995 to 2011 is cleaned and grouped into 11 broad event types

- The user can filter the data on year range and/or event types

- The filtered data is presented by state on the map and by year as plots

- Facility to download the data into csv form is also provided


---

## The Data


- Application is based on the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database

- A subset of the NCOA data between 1995 and 2011 is cleaned and grouped into 
11 broad event types

(The cleanup and grouping were done earlier as part of the Reproducible Research project)


```r
dt <- read.csv('../data/aggStormData.csv')
head(dt)
```

```
##   X YEAR  STATE          EVENT COUNT FATALITIES INJURIES  PROPDMG CROPDMG
## 1 1 1995 alaska   Cold Weather    16          0        0  0.00000       0
## 2 2 1995 alaska Excessive Heat    12          0        0  0.00000       0
## 3 3 1995 alaska          Flood     3          0        0 10.00002       0
## 4 4 1995 alaska      High Seas     2          7        5  0.00000       0
## 5 5 1995 alaska      Landslide     1          0        0  0.00500       0
## 6 6 1995 alaska     Rain & Fog     1          0        0  0.00000       0
```

---

## Where to find the application? 




- The appliction is deployed on Shiny server at this [link](https://ajitpn.shinyapps.io/Data-Products-Course-Project/)

- The source and this presentation is available on this Github [link](https://github.com/ajitpn/Data-Products-Course-Project.git)
 

###                  THANK YOU

---
