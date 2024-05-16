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
#compute omic associations, integrating measurements across tissues while factoring correlation
#Use 'SMulTiXcan.py'
python SMulTiXcan.py \
--models_folder TWAS/twas_gtex8_eur/data/models/eqtl/mashr/ \
--models_name_pattern "mashr_(.*).db" \
--snp_covariance TWAS/twas_gtex8_eur/data/models/gtex_v8_expression_mashr_snp_smultixcan_covariance.txt.gz \
--metaxcan_folder TWAS/lat23/ \
--metaxcan_file_name_parse_pattern "(.*)_mashr_(.*).csv" \
--gwas_file "TWAS/lat23/harmonized_meta_hgiB2_amr_lat23_chosp_pophosp_noeur.txt" \
--snp_column panel_variant_id \
--effect_allele_column effect_allele \
--non_effect_allele_column non_effect_allele \
--zscore_column zscore \
--keep_non_rsid \
--model_db_snp_key varID \
--cutoff_condition_number 30 \
--verbosity 7 \
--throw \
--output MultiXcan_meta_hgiB2_amr_lat23_chosp_mashgex8.csv

##End Of Script
