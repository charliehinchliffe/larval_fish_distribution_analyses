###manyglm univariate tests for HadISST

##loading required package
library(mgcv)
library(vegan)
library(car)
library(lubridate)
library(ggplot2)
library(pracma)
library(mvabund)

#read in data
nimo.data<-read.csv("allNIMO_dist.csv", header=TRUE)
head(nimo.data)
str(nimo.data)


### make bathymetry absolute values in km units
nimo.data$Bathy <- (abs(nimo.data$Bathy)/1000)   


#creating date variables#

nimo.data$DateCaught <- as.Date(nimo.data$Date, "%d/%m/%Y")
nimo.data$Month <- month(nimo.data$Date)
summary(nimo.data$Month)
nimo.data$Year <- year(nimo.data$DateCaught)
nimo.data$Day <- day(nimo.data$DateCaught)
summary(nimo.data$Day)

nimo.data$dayofyear <- yday(nimo.data$DateCaught)



#creating Season variables


nimo.data$Month <- as.factor(nimo.data$Month) #month as factor

nimo.data$Season <- "0" #make season variable

nimo.data$Season[nimo.data$Month  == "12"] <- "summer"
nimo.data$Season[nimo.data$Month  == "1"] <- "summer"
nimo.data$Season[nimo.data$Month  == "2"] <- "summer"

nimo.data$Season[nimo.data$Month  == "3"] <- "autumn"
nimo.data$Season[nimo.data$Month  == "4"] <- "autumn"
nimo.data$Season[nimo.data$Month  == "5"] <- "autumn"

nimo.data$Season[nimo.data$Month  == "6"] <- "winter"
nimo.data$Season[nimo.data$Month  == "7"] <- "winter"
nimo.data$Season[nimo.data$Month  == "8"] <- "winter"

nimo.data$Season[nimo.data$Month  == "9"] <- "spring"
nimo.data$Season[nimo.data$Month  == "10"] <- "spring"
nimo.data$Season[nimo.data$Month  == "11"] <- "spring"

nimo.data$Season <- as.factor(nimo.data$Season)
nimo.data$Month <- as.numeric(nimo.data$Month) 





nimo.data$Season <- as.factor(nimo.data$Season)
nimo.data$Season <- factor(nimo.data$Season, ordered = TRUE, levels = c("summer", "autumn", "winter","spring"))


#creatingtime period levels



nimo.data$Decade[nimo.data$Year  <= 1999] <- "1990s"
nimo.data$Decade[nimo.data$Year  <= 2009 & nimo.data$Year > 1999] <- "2000s"
nimo.data$Decade[nimo.data$Year  <= 2020 & nimo.data$Year > 2009] <- "2010s"

nimo.data$Period[nimo.data$Year  <= 1998] <- "pre1998"
nimo.data$Period[nimo.data$Year  >= 1999] <- "post1998"

nimo.data$Decade <- as.factor(nimo.data$Decade)
summary(nimo.data$Decade)

nimo.data$Period <- as.factor(nimo.data$Period)





#create Region variable



nimo.data$Region[nimo.data$Latitude  <= -40] <- "South"

nimo.data$Region[nimo.data$Latitude  <= -35 & nimo.data$Latitude > -40] <- "Mid-South"

nimo.data$Region[nimo.data$Latitude  <= -30 & nimo.data$Latitude > -35] <- "Mid-North"

nimo.data$Region[nimo.data$Latitude  > -30] <- "North"

nimo.data$Region <- as.factor(nimo.data$Region)


nimo.data$Region <- as.factor(nimo.data$Region)
nimo.data$Region <- factor(nimo.data$Region, ordered = TRUE, levels = c("North", "Mid-North", "Mid-South","South"))





#### Standardizing depth variable.

nimo.data$stand_depth <- as.character(nimo.data$Gear_depth_m)


nimo.data$stand_depth <- as.character(nimo.data$Gear_depth_m)



nimo.data$stand_depth[nimo.data$stand_depth  == "0-25"] <- "25" #double mid point

nimo.data$stand_depth[nimo.data$stand_depth  == "0-30"] <- "30"

nimo.data$stand_depth[nimo.data$stand_depth  == "0-35"] <- "35"

nimo.data$stand_depth[nimo.data$stand_depth  == "0-40"] <- "40"

nimo.data$stand_depth[nimo.data$stand_depth  == "0-50"] <- "50"

nimo.data$stand_depth[nimo.data$stand_depth  == "0-80"] <- "80"

nimo.data$stand_depth[nimo.data$stand_depth  == "25-50"] <- "75"

nimo.data$stand_depth[nimo.data$stand_depth  == "50-75"] <- "125"

nimo.data$stand_depth[nimo.data$stand_depth  == "75-100"] <- "175"



nimo.data$stand_depth <- as.factor(nimo.data$stand_depth)

nimo.data$stand_depth <- as.numeric(nimo.data$stand_depth)

nimo.data$stand_depth <- (nimo.data$stand_depth/2)




## create depth factors




nimo.data$depth_sect[nimo.data$stand_depth  >= 0 & nimo.data$stand_depth < 11] <- "a) 0-10"

nimo.data$depth_sect[nimo.data$stand_depth  >= 11 & nimo.data$stand_depth < 50] <- "b) 11-50"

nimo.data$depth_sect[nimo.data$stand_depth  >= 51 & nimo.data$stand_depth < 100] <- "c) 51-100"

nimo.data$depth_sect[nimo.data$stand_depth  >= 101 & nimo.data$stand_depth < 150] <- "d) 101-150"

nimo.data$depth_sect[nimo.data$stand_depth  >= 151] <- "e) 151+"

nimo.data$depth_sect <- as.factor(nimo.data$depth_sect)






### Creating diversity variables



larval.spp<-nimo.data[1:3193,22:241]




abundance <- rowSums(larval.spp)
richness <- specnumber(larval.spp) # richness
shannon <- diversity(larval.spp) #shannon wevaer index from vegan package
J <- shannon/log(specnumber(larval.spp)) # Evenness
shannon_effective <- exp(diversity(larval.spp))


nimo.data$shannon <- shannon
nimo.data$evenness <- J
nimo.data$richness <- richness
nimo.data$abundance <- abundance
nimo.data$shannon_effective <- shannon_effective


###seperate WA and east

eastcoast <- subset(nimo.data, nimo.data$Longitude >= 130)
westcoast <- subset(nimo.data, nimo.data$Longitude <= 130)



##seperate Inshore and offshore

inshore <- subset(eastcoast, eastcoast$Bathy <= .200)
offshore <- subset(eastcoast, eastcoast$Bathy >= .200)

### Inshore species matrix

elements <- inshore[1:2428,22:239]



myvars <- names(elements) %in% c("Acropomatidae_Synagrops.spp_37311949", 
                                 "Aploactinidae_other_37290000",
                                 "Bothidae_Crossorhombus.spp_37460907",
                                 "Bovichtidae_Pseudaphritis.urvilli_37403003",
                                 "Callanthiidae_other_37311957",
                                 "Cepolidae_Acanthocepola.spp_37380901",
                                 "Cepolidae_Owstonia.spp_37380903",
                                 "Cepolidae_other_37380000",
                                 "Cetomimidae_37132000",
                                 "Chandidae_other_37310900",
                                 "Engraulidae_other_37086000",
                                 "Ipnopidae_37123000",
                                 "Latridae_other_37378000",
                                 "Leptobramidae_37357905",
                                 "Microcanthidae_other_37361900",
                                 "Ophidiidae_Brotula.spp_37228912",
                                 "Plesiopidae_37316000",
                                 "Terapontidae_other_37321000",
                                 "Xiphiidae_Xiphias.gladius_37442001") 


elements <- elements[!myvars]


elements <- mvabund(elements[,])


fit <- manyglm(elements ~ HadISST, family = "negative.binomial", offset = log(Volume_m3),data=inshore)
saveRDS(fit, "manyglm_HaDISST_model.rds") 

Uni_test_manyglm <- anova(fit, nBoot=9999, p.uni = "adjusted")
saveRDS(Uni_test_manyglm, "Uni_test_manyglm_output.rds")

