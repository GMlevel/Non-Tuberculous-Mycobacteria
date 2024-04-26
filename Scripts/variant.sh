#!/bin/bash
#SBATCH --job-name=variant-calling
#SBATCH -A open
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem-per-cpu=8G
#SBATCH -t 24:00:00
#SBATCH -o variant-calling.out
#SBATCH -e variant-calling.err
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mail-user mnk5428@psu.edu

# Initialize conda (ensure conda command is available)
eval "$(conda shell.bash hook)"

# Activate the environment with FreeBayes
conda activate bwa_env

# Define input directory containing sorted BAM files
bam_dir="/storage/work/mnk5428/Dr.Zack/BAM_results"

# Define output directory for variant calling results
vcf_output="/storage/work/mnk5428/Dr.Zack/VariantCalling_results"

# Path to the reference genome file
ref_genome_file="/storage/work/mnk5428/Dr.Zack/Ref_genome_M.tuberculosis/m.tuberculosis_ref_genome.fasta"

# Create output directory if it doesn't exist
mkdir -p "$vcf_output"

# Perform variant calling using FreeBayes for each sorted BAM file
for bam_file in "$bam_dir"/*.sorted.bam; do
    if [ -f "$bam_file" ]; then
        bam_name=$(basename "$bam_file" .sorted.bam)
        echo "Performing variant calling for: $bam_name"
        freebayes -f "${ref_genome_file}" "$bam_file" > "$vcf_output/$bam_name.vcf"
    fi
done

echo "Variant calling with FreeBayes completed"

