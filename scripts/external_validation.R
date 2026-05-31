# R script for external validation cohort analysis
library(tidyverse)
library(epiR)

# Load external cohort data
ext <- read.csv('data/external_cohort.csv')
main <- read.csv('data/main_cohort.csv')

# Compute sensitivity, specificity
sens <- epi.tests(table(ext$DDT_alert, ext$RECIST_progression))
print(sens)

# Lead time comparison (Wilcoxon)
lead_compare <- wilcox.test(ext$lead_time_days, main$lead_time_days)
print(lead_compare)

# Bootstrap CI for sensitivity
boot_sens <- function(data, indices) {
  d <- data[indices,]
  sens <- sum(d$DDT_alert == 1 & d$RECIST_progression == 1) / sum(d$RECIST_progression == 1)
  return(sens)
}
boot_out <- boot(ext, boot_sens, R=1000)
boot.ci(boot_out, type="perc")
