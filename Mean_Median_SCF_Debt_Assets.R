install.packages("tidyverse")
install.packages("haven")
install.packages("sqldf")
install.packages("survey")
install.packages("srvyr")

library(tidyverse)
library(haven)
require(sqldf)
require(survey)
require("srvyr")

setwd("/Users/elenabotella/Downloads/Replication_Files 2/data")
scf_plus<-read_dta(file="SCF_plus.dta")

#remove elements whose survey weight is "na" (required to use survey functions)
scf_plus_no_null_weights<-scf_plus[!is.na(scf_plus$wgtI95W95),]

#set year as factor to allow us to group by the year
scf_plus_no_null_weights$yearmerge<-as.factor(scf_plus_no_null_weights$yearmerge)

#turn into a survey
scf_survey <- scf_plus_no_null_weights %>%
as_survey(weights = c(wgtI95W95))

#Change working directory to desired folder output with another setwd()

#create a file with means of key varaibles
out2 <- scf_survey %>%
group_by(yearmerge, tincgroups) %>%
summarize_at(vars(pdebt, tdebt, ccdebt, ffaass, house, hdebt, incws), survey_mean)

#write.csv(out2, "SCFPlus_Survey_output_eb.csv")

#create a file with the medians of key variables 
out3 <- scf_survey %>%
group_by(yearmerge, tincgroups) %>%  summarize_at(vars(pdebt, tdebt, ccdebt, ffaass, house, hdebt, incws), survey_median)

#write.csv(out3, "SCFPlus_Survey_output_median_eb.csv")
