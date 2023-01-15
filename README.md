# RNA-seq Analysis Pipeline

This pipeline is designed to process RNA-seq data from fastq files to quantification files. The pipeline includes the following steps:\

Trimming of reads\
Alignment of reads to a reference genome\
Quantification of gene expression\
Quality control analysis\


## Requirements
Nextflow\
Docker\
Reference genome and annotation files\
Pre-built genome index for STAR aligner\
Input fastq files\

## Usage
1) Clone the repository and navigate to the directory containing the pipeline

```bash
#!/bin/bash
git clone https://github.com/<username>/rnaseq-pipeline
cd rnaseq-pipeline
```

2) Build the Docker image using the provided Dockerfile

```
#!/bin/bash
docker build -t rnaseq-pipeline .
```

3) Run the pipeline using Nextflow and the Docker image. Make sure to replace the placeholder values in the command with the appropriate paths for your system.

```
#!/bin/bash
nextflow run pipeline.nf -profile docker --genomeIndex /path/to/genomeIndex --annotation /path/to/annotation.gtf --adapters /path/to/adapters.fa --input_dir /path/to/input_fastq_files --output_dir /path/to/output_files --threads 8
```

