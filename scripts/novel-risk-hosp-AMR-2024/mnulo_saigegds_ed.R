#R scripts
#Novel risk loci for COVID-19 hospitalization among admixed American populations
#May 2024

rm(list = ls())

#Load libraries
library(SAIGEgds)
library(SeqArray)
library(SNPRelate)

# Add GDS
path <- "your-path-here"
fn <- paste(path, "mnulo_lat23.gds", seP="/")
covid_nulo <- seqOpen(fn)

# Load phenotypes
ph <- "Feno_latinos23_noeur_analizable.txt"
pheno <- read.delim(ph, sep="\t", header = T)
grm_pruned <- "snps_mnulo_lat23.gds"

#Show phenos
table(pheno$POP_HOSP)

#Compute glmm
glmm_hosp <- seqFitNullGLMM_SPA(R_HOSP~RSEX+REDAD+PC1+PC2+PC3+PC4+PC5+PC6+PC7+PC8+PC9+PC10+POP_HOSP,
				pheno3,
				grm_pruned,
				trait.type="binary",
				maf=0.005,
				missing.rate=0.02,
				sample.col="IID",
				num.thread=20,
				model.savefn = "mod_nulo_chosp_noeur_hosp.RData")
# 1625 hosp cases
# 1887 non hosp controls

##End Of Script
