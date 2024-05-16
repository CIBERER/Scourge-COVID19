#!/bin/bash
#SBATCH -p batch -t 1:00:00 
#SBATCH --mem=100G
#SBATCH -n1
#SBATCH --mail-type=end
#SBATCH --mail-user=your-user@your-domain.com

#Novel risk loci for COVID-19 hospitalization among admixed American populations
#May 2024

#Load modules at your SLURM cluster
module load miniconda3/4.11.0
conda activate gwastools 

#1. El primer paso consiste en harmonizar los datos con los de la base de datos. 
#  
# Notas: temos que exportar TODO con sep
# Hai que exportar a taboa dos weights do modelo para empalmar os snps
# Nesa táboa TEMOS que poñer o header como chromosome position id allele_0 allele_1 (ea) allele_1_frequency (NAs) rsid
# No gwas engadimos a man a columna rsid
#gwas$rsid <- meta$rsid[match(gwas$panel_variant_id, meta$id)] # comproba se hai dups. o meta é o do meta-hgi


# IGNORAR ISTO..DEIXO POR SE ACASO
# hai varios rsid con dous snps... collemos o de maior weight
#cova<-#abrimos covariance
#meta<-#abrimos metadatos
#snps<-meta[c("id","rsid")]
#snps2<-distinct(snps)
#snps2_rep<-snps2[which(duplicated(snps2$rsid)),]
#d2 <- left_join(cova,snps2, by=c("RSID1"="rsid")) 
#d2<-select(d2,c(GENE, id, RSID2, VALUE)) 
#names(d2)[2]<-"RSID1"
#d2<-left_join(d2,snps2,by=c("RSID2"="rsid"))
#d2<-select(d2,c(GENE,RSID1,id,VALUE))
#names(d2)[3]<-c("RSID2")
#write.table(d2)

Rscript cambios.R

# engadimos o --chromosome_format!

#python /mnt/lustre/scratch/nlsas/home/usc/gb/sdd/TWAS/harm_imp/summary-gwas-imputation/src/gwas_parsing.py  -gwas_file "S_assoc_scourge_eur_cs.txt"   -snp_reference_metadata "/mnt/lustre/scratch/nlsas/home/usc/gb/sdd/TWAS/twas_gtex8_eur/data/reference_panel_1000G/variant_metadata.txt.gz" METADATA -output_column_map rs variant_id -output_column_map SE standard_error -output_column_map NEA non_effect_allele -output_column_map EA effect_allele -output_column_map beta_meta effect_size -output_column_map pval_meta pvalue -output_column_map SCHR chromosome -output_column_map POS position  -output_order variant_id panel_variant_id chromosome position effect_allele non_effect_allele pvalue zscore effect_size standard_error sample_size -output harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur  --insert_value sample_size 73275 --chromosome_format

##End Of Script
