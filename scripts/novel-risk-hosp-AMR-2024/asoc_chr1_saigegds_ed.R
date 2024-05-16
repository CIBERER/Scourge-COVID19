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
fn <- paste(path, "chr1.gds", seP="/")
chrom <- seqOpen(fn)

#Define params
maf <- 0.002
missing <- 0.02
parallel <- 10

joint<- seqAssocGLMM_SPA(chrom, "mod_nulo_chosp_noeur_hosp.RData", maf = maf, missing = missing, parallel = parallel)

names(joint) <- c("ID","CHR","POS","SNP","REF","ALT","AF.ALT_nam","mac","N","beta","SE","pval","pval_noadj","converged")

write.table(joint,"chr1_joint.txt",sep="\t",row.names=FALSE, quote=F)

##End Of Script
