# Non-Tuberculous-Mycobacteria
# Trimming (Trimmomatic)

Trimmomatic to remove low-quality adapter sequences, leading/trailing low-quality bases, and reads below a specified minimum length.
Fine-tune Trimmomatic parameters (e.g., sliding window quality score, minimum read length) based on your sequencing data quality.

# Assembly (Unicycler)

Unicycler for de novo assembly of the trimmed reads. Unicycler is well-suited for NTM genomes due to its hybrid assembly approach, combining short and long reads to achieve highly accurate and contiguous assemblies.

# PubMLST

PubMLST to identify the specific Mycobacterium species and strain type based on the assembled genome.
PubMLST provides a standardized typing scheme for mycobacteria.

# Alignment (BWA)

BWA (Burrows-Wheeler Aligner) to map the trimmed reads against a reference genome of a closely related Mycobacterium species. This step is optional if you're primarily interested in variant calling within your assembled genome.
BWA offers efficient and accurate mapping, especially for short-read data.

# Annotation (Prokka)

Prokka to annotate the assembled genome. Prokka predicts gene features (open reading frames, tRNAs, rRNAs) and provides functional annotations based on existing reference databases.

# Variant Calling (Freebayes)

Freebayes to identify single nucleotide polymorphisms (SNPs) and insertions/deletions (indels) in the assembled genome compared to the reference genome 
Freebayes is a Bayesian variant caller known for its accuracy and sensitivity, particularly for detecting variants in mycobacterial genomes.

# ABRICATE Analysis

ABRICATE to search the assembled genome for acquired antimicrobial resistance (AMR) genes and determine the potential resistance profile of the NTM strain.
