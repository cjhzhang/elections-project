library(readr)
library(dplyr)
library(lubridate)
library(tidyverse)
library(fastDummies)

elec_data <- read.csv('/Users/cathyzhang/Downloads/anes_timeseries_cdf_csv_20220916.csv')

subset <- elec_data[, c("VCF0004", "VCF0114", "VCF0110", "VCF0104", "VCF0105a", "VCF0102","VCF0705")]
subset <- na.omit(subset)
colnames(subset)[1]<-'year_of_study' #was VCF0004
colnames(subset)[2]<-'income_group' #was VCF0114
colnames(subset)[3]<-'education_4_cat' #was VCF0110
colnames(subset)[4]<-'gender' #was VCF0104
colnames(subset)[5]<-'race_ethnicity_seven' #was VCF0105a
colnames(subset)[6]<-'age_group' #was VCF0102
colnames(subset)[7]<-'vote_pres' #was VCF0705

#filtering for after 1980, not including 1980
post_1980 <- filter(subset, year_of_study > 1980)

#if we want to filter out all missing, i have included the code to rename
#the missing levels as comments
post_180_nomissing <- filter(post_1980, 
                       income_group != 0, 
                       education_4_cat != 0, 
                       gender != 0,
                       race_ethnicity_seven != 9,
                       age_group != 0,
                       vote_pres != 0)

#turning qualitative into dummies
post_1980_dummies <- dummy_cols(post_180_nomissing,
                                select_columns = c('income_group',
                                                   'education_4_cat',
                                                   'gender',
                                                   'race_ethnicity_seven',
                                                   'age_group',
                                                   'vote_pres'))

#renaming dummies for clarity 
post_1980_dummies <- post_1980_dummies %>%
  rename(income_group_0_16_percentile = income_group_1,
         income_group_17_33_percentile = income_group_2,
         income_group_34_67_percentile = income_group_3,
         income_group_68_95_percentile = income_group_4,
         income_group_96_100_percentile = income_group_5,
        # income_group_missing = income_group_0,
         
        # education_missing = education_4_cat_0,
         education_1_less_than_hs = education_4_cat_1,
         education_2_high_school = education_4_cat_2,
         education_3_some_college = education_4_cat_3,
         education_4_college_or_adv_degree = education_4_cat_4,
         
        # gender_missing = gender_0,
         gender_male = gender_1,
         gender_female = gender_2,
         gender_other = gender_3,
         
         race_eth_white_nonhispanic = race_ethnicity_seven_1,
         race_eth_black_nonhispanic = race_ethnicity_seven_2,
         race_eth_asian_or_pi_nonhispanic = race_ethnicity_seven_3,
         race_eth_american_indian_alaska_native_nonhispanic = race_ethnicity_seven_4,
         race_eth_hispanic = race_ethnicity_seven_5,
         race_eth_other_or_multiple_nonhispanic = race_ethnicity_seven_6,
         #level 7 excluded because it was only before 1980
        # race_eth_missing = race_ethnicity_seven_9,
         
        # age_group_missing = age_group_0,
         age_group_17_24 = age_group_1,
         age_group_25_34 = age_group_2,
         age_group_35_44 = age_group_3,
         age_group_45_54 = age_group_4,
         age_group_55_64 = age_group_5,
         age_group_64_74 = age_group_6,
         age_group_75_99_andover = age_group_7,
         
         #votepres_missing = vote_pres_0,
         votepres_democrat = vote_pres_1,
         votepres_republican = vote_pres_2,
         votepres_thirdparty = vote_pres_3,
         )







