#!/bin/bash
#SBATCH --job-name=se-BWA-MEM
#SBATCH -A open
#SBATCH -N 1
#SBATCH -n 8
#SBATCH --mem-per-cpu=8G
#SBATCH -t 48:00:00
#SBATCH -o se-bwa-mem.out
#SBATCH -e se-bwa-mem.err
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mail-user mnk5428@psu.edu

# Initialize conda (ensure conda command is available)
eval "$(conda shell.bash hook)"

# Activate the environment
conda activate bwa_env

# Define input directory containing assembly files
assembly_dir="/storage/work/mnk5428/Dr.Zack/Assemblies"

# Define output directory for BWA-MEM alignment
bwa_output="/storage/work/mnk5428/Dr.Zack/BWA_results"

# Define output directory for BAM files
bam_output="/storage/work/mnk5428/Dr.Zack/BAM_results"

# Path to the reference genome file
ref_genome_file="/storage/work/mnk5428/Dr.Zack/Ref_genome_M.tuberculosis/m.tuberculosis_ref_genome.fasta"

# Create output directories if they don't exist
mkdir -p "$bwa_output" "$bam_output"

# Generate BWA index for the reference genome if not already done
if [ ! -f "${ref_genome_file}.bwt" ]; then
    echo "Generating BWA index for the reference genome"
    bwa index "${ref_genome_file}"
fi

# Check if index files were successfully generated
if [ ! -f "${ref_genome_file}.bwt" ]; then
    echo "Error: BWA index files not found for the reference genome."
    exit 1
fi

# Perform BWA-MEM alignment for each assembly
for assembly_file in "$assembly_dir"/*.fasta; do
    if [ -f "$assembly_file" ]; then
        assembly_name=$(basename "$assembly_file" .fasta)
        echo "Performing BWA-MEM alignment for: $assembly_name"
        bwa mem "${ref_genome_file}" "$assembly_file" > "$bwa_output/$assembly_name.sam"

        # Convert SAM to BAM
        echo "Converting SAM to BAM for: $assembly_name"
        sambamba view -S -f bam "$bwa_output/$assembly_name.sam" > "$bam_output/$assembly_name.bam"

        # Sort BAM file
        sambamba sort "$bam_output/$assembly_name.bam" -o "$bam_output/$assembly_name.sorted.bam"

        # Index sorted BAM file
        sambamba index "$bam_output/$assembly_name.sorted.bam"

        # Remove intermediate files (optional)
        rm "$bwa_output/$assembly_name.sam" "$bam_output/$assembly_name.bam"
    fi
done

echo "BWA-MEM alignment, BAM file conversion, and indexing completed"

