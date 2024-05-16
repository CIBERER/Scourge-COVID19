#R scripts
#Novel risk loci for COVID-19 hospitalization among admixed American populations
#May 2024

rm(list = ls())

#Load libraries
library(rms)
library(dplyr)
library(tools)
library(boot)

#Set seed
set.seed(1234)

#Load phenotypes
pheno <- "FENO_LATINOS23.TXT"
feno_lat <- read.delim(pheno, header = T, sep = "\t")

#Load PRS profile
prs <- "PRS_HITS_HOSP_LAT23.profile"
prs_l <- read.table(prs, header = T)

#Prepare a phenotype matrix
feno_lat2 <- merge(prs_l[c("IID","CNT","SCORE")], feno_lat)
feno_lat2$st.prs <- (feno_lat2$SCORE-mean(feno_lat2$SCORE))/sd(feno_lat2$SCORE)

dif_rsq <- function(formula1, formula2, data, index) {
  bt <- data[index,] # allows boot to select sample
  mod1 <- lrm(formula1, bt)
  mod2 <- lrm(formula2, bt)
  dif <- mod2$stats["R2"]-mod1$stats["R2"]
  zs <- mod2$coefficients/sqrt(diag(mod2$var))
  zprs <-zs["st.score"]
  rsq <- cbind(mod1$stats["R2"], mod2$stats["R2"], dif, zprs)
  names(rsq) <- c("R2_base","R2_prs","Dif_R2","z")
  return(rsq)}

divido_percentil <- function(data,var,n){
  step <- 1/n
  data["prs"] <- data[var]
  cut(data$prs, breaks = quantile(data$prs, probs = seq(0, 1, by = step)), labels = paste(seq(1, n, by = 1)))}

f1B <- as.formula("R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP")
f2B <- as.formula("R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+st.prs+POP_HOSP")
mod_lat_nam <- boot(data = feno_lat2,
		  statistic = dif_rsq,
                  R = 500,
                  formula1 = f1B,
                  formula2 = f2B)
colMeans(mod_lat_nam$t) # 0.011

summary(glm(f2B, feno_lat2, family = binomial(link = "logit")))

#Division in tiles
feno_lat2$decil <- divido_percentil(feno_lat2, "st.prs", 10)
feno_lat2$pcntil <- divido_percentil(feno_lat2, "st.prs", 100)
feno_lat2$quintil <- divido_percentil(feno_lat2, "st.prs", 5)

#Compute average risk
feno_lat2$dc10_vs_60 <- ifelse(feno_lat2$decil == 10, 1, ifelse(feno_lat2$decil == 4 | feno_lat2$decil == 5 | feno_lat2$decil == 6, 0, NA))

summary(glm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+dc10_vs_60,
		feno_lat2,
		family=binomial(link="logit")))

#Adjust by comorb
summary(glm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+dc10_vs_60*AV,
		fenof,
		family=binomial(link="logit")))
summary(glm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+dc10_vs_60*AC,
		fenof, 
	    	family=binomial(link="logit")))
summary(glm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+dc10_vs_60*AOH,
		fenof, 
		family=binomial(link="logit")))
summary(glm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+dc10_vs_60*AN,
		fenof, 
	    	family=binomial(link="logit")))
summary(glm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+dc10_vs_60*AR,
		fenof, 
	    	family=binomial(link="logit")))

# Median in each CHOSP category
aggregate(as.numeric(feno_lat2$pcntil), by = list(feno_lat2$R_HOSP), median, na.rm = T)
aggregate(as.numeric(feno_lat2$st.prs), by = list(feno_lat2$R_HOSP), median, na.rm = T)


#Binarized PRS and ICS
calculo_ics_beta_avg <- function(data,pcntil_var){
  vec<-NULL
  
  for (i in c(1:3,7:10)){
    data["pcntil"] <- as.numeric(data[[pcntil_var]])
    data$divido <- ifelse(data$pcntil == 4 | data$pcntil == 5 | data$pcntil == 6, 0, ifelse(data$pcntil == i, 1, NA))
    mod_decil <- lrm(R_HOSP~REDAD+RSEX+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP+divido, data)
    coef <- mod_decil$coefficients["divido"]
    or <- exp(coef)
    se <- sqrt(diag(vcov(mod_decil)))["divido"]
    l <- exp(coef-1.96*se)
    u <- exp(coef+1.96*se)
    mod_df <- data.frame("mod" = i, "or" = or, "lower" = l, "upper" = u)
    vec <- rbind(vec,mod_df)}
  return(vec)}

or_ic_cuantil_avg <- calculo_ics_beta_avg(fenof,"decil")
ggplot(or_ic_cuantil_avg, aes(x = mod, y = or)) +
	geom_errorbar(aes(ymax = upper, ymin = lower), size = 1, color = "purple") +
	geom_point(size = 3.5, color = "orange") +
	theme_minimal() +
	xlab("PGS decile") +
	ylab("Odds ratio (95% CI)") +
	theme(axis.text = element_text(size = 10), axis.title = element_text(size = 15))
 
  
#Build Violin plot
feno_lat2$gravedad <- as.factor(feno_lat2$gravedad)
library(ggplot2)
library(ggridges)
a2 <- ggplot(feno_lat2, aes(y = st.prs, x = gravedad, fill = gravedad)) +
		geom_violin(position = position_dodge(width = 0.9)) +
		geom_boxplot(width = 0.1, color = "black", alpha = 0.8) +
		theme_minimal() +
		theme(legend.position = "none", plot.title = element_text(size = 11)) +
		xlab("Severity scale") +
		ylab("Score") + 
		scale_fill_brewer(palette = "Dark2")

##End Of Script
