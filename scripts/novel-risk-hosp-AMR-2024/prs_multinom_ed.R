#R scripts
#Novel risk loci for COVID-19 hospitalization among admixed American populations
#May 2024

rm(list = ls())

#Load libraries
require(data.table)
require(reshape2)
require(readxl)
require(dplyr)
library(nnet)

#Load phenotypes
pheno <- "FENO_LATINOS23.TXT"
feno_lat <- read.delim(pheno, header = T, sep = "\t")

#Load PRS profile
prs <- "PRS_HITS_HOSP_LAT23.profile"
prs_l <- read.table(prs, header = T)


#Prepare a phenotype matrix
feno_lat2 <- merge(prs_l[c("IID","CNT","SCORE")], feno_lat)
feno_lat2$st.prs <- (feno_lat2$SCORE-mean(feno_lat2$SCORE))/sd(feno_lat2$SCORE)

feno3$gravedad <- as.factor(feno3$gravedad)
feno3$gravedad2 <- relevel(feno3$gravedad, ref="0")

#Model
mod <- multinom(gravedad2~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+st.prs+POP_HOSP, data = feno3)
summary(mod)

#Create a date frame
ors <- data.frame("beta"=summary(mod)$coefficients[,14], "se" = summary(mod)$standard.errors[,14], "or" = exp(summary(mod)$coefficients[,14]))
ors$ic.low <- exp(ors$beta-1.96*ors$se)
ors$ic.up <- exp(ors$beta+1.96*ors$se)
ors$cat <- c("1","2","3","4")

#Plot
ggplot(ors, aes(x = cat, y = or)) +
	geom_errorbar(aes(ymax = ic.low, ymin = ic.up), size = 1, color = "purple") +
	geom_point(size = 3.5, color = "orange") +
	theme_minimal() +
	xlab("PGS decile") +
	ylab("Odds ratio (95% CI)") +
	theme(axis.text = element_text(size = 10), axis.title = element_text(size = 15))

ors$z <- ors$beta/ors$se
ors$p <- (1 - pnorm(abs(ors$z), 0, 1)) * 2

write.table(ors,"results_multinom.txt", quote = F, row.names = F)

##End Of Script
