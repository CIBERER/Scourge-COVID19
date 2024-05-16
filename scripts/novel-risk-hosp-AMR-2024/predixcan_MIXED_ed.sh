#!/bin/bash
#SBATCH -p batch -t 1:00:00 
#SBATCH --mem=100G
#SBATCH -n1
#SBATCH --mail-type=end
#SBATCH --mail-user=your-user@your-domain.com

#Novel risk loci for COVID-19 hospitalization among admixed American populations
#May 2024

#Load modules at your SLURM cluster
module load miniconda3/4.9.0
conda activate gwastools 

#MetaXcan (https://github.com/hakyimlab/MetaXcan)
#S-PrediXcan is an extension that infers PrediXcan's results using only summary statistics, implemented in 'SPrediXcan.py'

#Run as follows:
#python TWAS/MetaXcan/software/SPrediXcan.py \
#--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
#--snp_column variant_id \
#--effect_allele_column effect_allele \
#--non_effect_allele_column non_effect_allele \
#--zscore_column zscore \
#--model_db_path "TWAS/twas_aframr/predictdb/gala.sage.All_Whole_Blood_tw_0.5_signif.db" \
#--covariance "TWAS/twas_aframr/predictdb/gala.sage.All_Whole_Blood_covariances.txt.gz" \
##--additional_output \
#--keep_non_rsid \
#--model_db_snp_key varID \
#--throw \
#--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_wholeblood_GALASAGE.csv \
#--verbosity 1 

#Run as follows:
python /mnt/lustre/scratch/nlsas/home/usc/gb/sdd/TWAS/MetaXcan/software/SPrediXcan.py \
--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
--snp_column variant_id \
--effect_allele_column effect_allele \
--non_effect_allele_column non_effect_allele \
--zscore_column zscore \
--model_db_path "TWAS/twas_aframr/predictdb/gala.sage.AA_Whole_Blood_tw_0.5_signif.db" \
--covariance "TWAS/twas_aframr/predictdb/gala.sage.AA_Whole_Blood_covariances.txt.gz" \
--additional_output \
--keep_non_rsid \
--model_db_snp_key varID \
--throw \
--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_wholeblood_GALASAGE_AA.csv \
--verbosity 1 

#Run as follows:
python TWAS/MetaXcan/software/SPrediXcan.py \
--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
--snp_column variant_id \
--effect_allele_column effect_allele \
--non_effect_allele_column non_effect_allele \
--zscore_column zscore \
--model_db_path "TWAS/twas_aframr/predictdb/gala.sage.MX_Whole_Blood_tw_0.5_signif.db" \
--covariance "TWAS/twas_aframr/predictdb/gala.sage.MX_Whole_Blood_covariances.txt.gz" \
--additional_output \
--keep_non_rsid \
--model_db_snp_key varID \
--throw \
--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_wholeblood_GALASAGE_MX.csv \
--verbosity 1 

python TWAS/MetaXcan/software/SPrediXcan.py \
--gwas_file  "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
--snp_column variant_id \
--effect_allele_column effect_allele \
--non_effect_allele_column non_effect_allele \
--zscore_column zscore \
--model_db_path "TWAS/twas_aframr/predictdb/gala.sage.PR_Whole_Blood_tw_0.5_signif.db" \
--covariance "TWAS/twas_aframr/predictdb/gala.sage.PR_Whole_Blood_covariances.txt.gz" \
--additional_output \
--keep_non_rsid \
--model_db_snp_key varID \
--throw \
--output_file prediXcan_meta_hgiB2_amr_lat23_chosp_wholeblood_GALASAGE_PR.csv \
--verbosity 1

##End Of Script
