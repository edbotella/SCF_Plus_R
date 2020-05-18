#setwd to wherever the data is 

library(tidyverse)
library(haven)
require(sqldf)
require(survey)
require("srvyr")
scf_plus<-read_dta(file="SCF_plus.dta")
scf_plus_no_nulls_weights<-scf_plus[!is.na(scf_plus$wgtI95W95),]
scf_plus_no_nulls_weights$yearmerge<-as.factor(scf_plus_no_nulls_weights$yearmerge)


scf_survey <- scf_plus_no_nulls_weights %>%
as_survey(weights = c(wgtI95W95))


#percent with credit card debt by income
out3_may18_cc<-mutate(scf_survey, ccdebt_yn=ifelse(ccdebt==0, 0, 1)) %>%
group_by(yearmerge, tincgroups) %>%
summarize_at(vars(pdebt, tdebt, ccdebt,
ffaass, house, hdebt, incws, ffafin,
ffanfin, ffabus, house, oest, vehi,
onfin, ccdebt_yn), survey_mean)
write.csv(out3_may18_cc, "ccdebt_yn_by_income.csv")



#percent with any credit card debt by year
out3_may18_cc_notsplit2<-mutate(scf_survey, ccdebt_yn=ifelse(ccdebt==0, 0, 1)) %>%
group_by(yearmerge) %>%
summarize_at(vars(pdebt, tdebt, ccdebt,
ffaass, house, hdebt, incws, ffafin,
ffanfin, ffabus, house, oest, vehi,
onfin, ccdebt_yn), survey_mean)


write.csv(out3_may18_cc_notsplit2, "ccdebt_yn_by_income_notsplit2.csv")
