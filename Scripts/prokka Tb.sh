#!/bin/bash
#SBATCH --job-name=se-prokkaTB
#SBATCH -A open
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem-per-cpu=8G
#SBATCH -t 48:00:00
#SBATCH -o se-prokkaTB.out
#SBATCH -e se-prokkaTB.err
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mail-user mnk5428@psu.edu

# Initialize conda (ensure conda command is available)
eval "$(conda shell.bash hook)"

# Activate the environment
conda activate prokka_env

# Set the paths to your assemblies, output directory, and reference genome directory
assembly_dir="/storage/work/mnk5428/Dr.Zack/Assemblies"
output_dir="/storage/work/mnk5428/Dr.Zack/Annotation results against M.tuberculosis ref genome"
ref_genome_dir="/storage/work/mnk5428/Dr.Zack/Ref genome M.tuberculosis"

# Create a temporary directory to store the converted reference genomes
temp_dir=$(mktemp -d)

# Convert reference genomes from text to FASTA format
for ref_file in "$ref_genome_dir"/*.txt; do
    # Get the base filename of the reference file without the extension
    ref_name=$(basename "$ref_file" .txt)
    
    # Convert reference file to FASTA format
    fasta_file="$temp_dir/$ref_name.fasta"
    awk -v seq="sequence" '{if (substr($0, 1, 1) == ">") print ">"seq++; else print}' "$ref_file" > "$fasta_file"
done

# Iterate over the assemblies in the assembly directory
for assembly_file in "$assembly_dir"/*.fasta; do
    # Get the base filename of the assembly without the extension
    assembly_name=$(basename "$assembly_file" .fasta)
    
    # Run Prokka on the assembly, providing the converted reference genome
    prokka --outdir "$output_dir/$assembly_name" --prefix "$assembly_name" --genus "Genus" --species "species" --strain "strain" "$assembly_file"
done

# Remove the temporary directory
rm -r "$temp_dir"
