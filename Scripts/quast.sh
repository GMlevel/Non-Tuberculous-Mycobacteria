#!/bin/bash
#SBATCH --job-name=se-QuastTB
#SBATCH -A open
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem-per-cpu=8G
#SBATCH -t 48:00:00
#SBATCH -o se-quastTB.out
#SBATCH -e se-quastTB.err
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mail-user mnk5428@psu.edu

# Initialize conda (ensure conda command is available)
eval "$(conda shell.bash hook)"

# Activate the environment
conda activate quast_env

# Define input directory containing assembly files
assembly_dir="/storage/work/mnk5428/Dr.Zack/Assemblies"

# Define output directory for QUAST analysis
quast_output="/storage/work/mnk5428/Dr.Zack/Quast_results"

# Create output directory if it doesn't exist
mkdir -p "$quast_output"

# Perform QUAST analysis for each assembly
for assembly_file in "$assembly_dir"/*.fasta; do
    if [ -f "$assembly_file" ]; then
        assembly_name=$(basename "$assembly_file" .fasta)
        echo "Running QUAST analysis for assembly: $assembly_name"
        quast.py -o "$quast_output/$assembly_name" "$assembly_file"
    fi
done

echo "QUAST analysis completed"

