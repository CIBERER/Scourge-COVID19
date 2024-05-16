#R scripts
#Novel risk loci for COVID-19 hospitalization among admixed American populations
#May 2024

rm(list = ls())

#Load libraries
library(qqman)

#Load data for chromosome 1
chrom1 <- read.delim("chr1_joint.txt", sep = "", header = T)

#Load data for the chromosomes
for (i in 2:23){ 
 crom <- read.delim(paste("chr", i, "_joint.txt", sep = ""), sep = "")
 assign(paste("chrom", i, sep = ""), crom)
 }
 
allcrom <- Reduce(function(...) rbind(...), list(chrom1, chrom2, chrom3, chrom4, chrom5,
						 chrom6, chrom7, chrom8, chrom9, chrom10,
                                                 chrom11, chrom12, chrom13, chrom14, chrom15,
                                                 chrom16, chrom17, chrom18, chrom19, chrom20,
                                                 chrom21, chrom22, chrom23))

write.table(allcrom, "RESULTADOS_CHOSP_joint_NOEUR_pophosp_lat23.txt", quote = F, row.names = F)

#Get and save top values
tops_e <- allcrom[which(allcrom$pval<=1e-5),]
write.table(tops_e, "TOP_CHOSP_joint_NOEUR_pophosp_lat23.txt", quote = F, row.names = F)

allcrommanh_cov_e <- allcrom[which(!is.na(allcrom$pval)),]
allcrommanh_cov_e$CHR < -ifelse(allcrommanh_cov_e$CHR == "X", 23, allcrommanh_cov_e$CHR)
allcrommanh_cov_e$RCHR <- as.numeric(allcrommanh_cov_e$CHR)

#Plot
jpeg("CHOSP_joint_NOEUR_pophosp_lat23.jpeg", width = 2000, height = 2000, res = 500, pointsize = 4)
manhattan(allcrommanh_cov_e, 
		chr = "RCHR", 
		bp = "POS", 
		p = "pval", 
                main = "C_hosp joint lat23 sin eur pop_hosp", 
                ylim = c(0, 8), 
                cex = 0.3, 
                cex.axis = 0.9, 
                joint = c("#669999", "#99CCCC"))

jpeg("QQ_CHOSP_joint_NOEUR_pophosp_lat23.jpeg", width = 2000, height = 2000, res = 500, pointsize = 4)
qq(allcrommanh_cov_e$pval, main = "C_hosp joint lat23 sin eur pop_hosp", ylim = c(0,15), cex = 0.3, cex.axis = 0.9)
dev.off()

##End Of Script
