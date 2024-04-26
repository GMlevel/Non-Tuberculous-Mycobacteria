#!/bin/bash
#SBATCH --job-name=sam-to-bam
#SBATCH -A open
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem-per-cpu=8G
#SBATCH -t 4:00:00
#SBATCH -o sam-to-bam.out
#SBATCH -e sam-to-bam.err
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mail-user mnk5428@psu.edu

# Initialize conda (ensure conda command is available)
eval "$(conda shell.bash hook)"

# Activate the environment with Sambamba
conda activate bwa_env

# Define input directory containing SAM files
sam_dir="/storage/work/mnk5428/Dr.Zack/BWA_results"

# Define output directory for BAM files
bam_output="/storage/work/mnk5428/Dr.Zack/BAM_results"

# Create output directory if it doesn't exist
mkdir -p "$bam_output"

# Perform SAM to BAM conversion for each SAM file
for sam_file in "$sam_dir"/*.sam; do
    if [ -f "$sam_file" ]; then
        sam_name=$(basename "$sam_file" .sam)
        bam_file="${sam_name}.bam"
        echo "Converting SAM to BAM for: $sam_name"
        sambamba view -S -f bam "$sam_file" > "$bam_output/$bam_file"
    fi
done

echo "SAM to BAM conversion completed"

