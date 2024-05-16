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

#MetaXcan (https://github.com/hakyimlab/MetaXcan)
#S-PrediXcan is an extension that infers PrediXcan's results using only summary statistics, implemented in 'SPrediXcan.py'

#Run as follows:
#python TWAS/MetaXcan/software/SPrediXcan.py \
#--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
#--snp_column panel_variant_id \
#--effect_allele_column effect_allele \
#--non_effect_allele_column non_effect_allele \
##--zscore_column zscore \
#--model_db_path "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Lung.db" \
#--covariance "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Lung.txt.gz" \
##--additional_output \
#--keep_non_rsid \
#--model_db_snp_key varID \
#--throw \
#--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_LUNG.csv \
#--verbosity 1 

#Run as follows:
#python TWAS/MetaXcan/software/SPrediXcan.py \
#--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
#--snp_column panel_variant_id \
#--effect_allele_column effect_allele \
##--non_effect_allele_column non_effect_allele \
#--zscore_column zscore \
#--model_db_path "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Cells_EBV-transformed_lymphocytes.db" \
#--covariance "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Cells_EBV-transformed_lymphocytes.txt.gz" \
#--additional_output \
#--keep_non_rsid \
#--model_db_snp_key varID \
#--throw \
#--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_LYMPHO.csv \
#--verbosity 1 

#Run as follows:
#python TWAS/MetaXcan/software/SPrediXcan.py \
#--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
#--snp_column panel_variant_id \
#--effect_allele_column effect_allele \
##--non_effect_allele_column non_effect_allele \
#--zscore_column zscore \
#--model_db_path "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Esophagus_Mucosa.db" \
#--covariance "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Esophagus_Mucosa.txt.gz" \
##--additional_output \
#--keep_non_rsid \
#--model_db_snp_key varID \
#--throw \
#--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_ESOMU.csv \
#--verbosity 1 

#Run as follows:
#python TWAS/MetaXcan/software/SPrediXcan.py \
#--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
##--snp_column panel_variant_id \
#--effect_allele_column effect_allele \
#--non_effect_allele_column non_effect_allele \
#--zscore_column zscore \
#--model_db_path "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Whole_Blood.db" \
#--covariance "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Whole_Blood.txt.gz" \
#--additional_output \
#--keep_non_rsid \
#--model_db_snp_key varID \
#--throw \
#--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_WB.csv \
#--verbosity 1 

#Run as follows:
#python TWAS/MetaXcan/software/SPrediXcan.py \
#--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
#--snp_column panel_variant_id \
#--effect_allele_column effect_allele \
#--non_effect_allele_column non_effect_allele \
#--zscore_column zscore \
#--model_db_path "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Whole_Blood.db" \
#--covariance "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/mashr_Whole_Blood.txt.gz" \
#--additional_output \
#--keep_non_rsid \
#--model_db_snp_key varID \
#--throw \
#--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_WB.csv \
#--verbosity 1 

cd "TWAS/twas_gtex8_eur/data/models/eqtl/mashr/"
#Iterate over the list of files
for f in *.txt.gz; do
#Run as follows:
python TWAS/MetaXcan/software/SPrediXcan.py \
--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
--snp_column panel_variant_id \
--effect_allele_column effect_allele \
--non_effect_allele_column non_effect_allele \
--zscore_column zscore \
--model_db_path ${f%.*.*}.db \
--covariance ${f%.*.*}.txt.gz \
--additional_output \
--keep_non_rsid \
--model_db_snp_key varID \
--throw \
--output_file TWAS/lat23/prediXcan_meta_hgiB2_amr_lat23_chosp_${f%.*.*}.csv \
--verbosity 1;
done

##End Of Script
