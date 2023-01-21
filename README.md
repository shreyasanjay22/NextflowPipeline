# RNA-seq Analysis Pipeline

This pipeline automates the process of RNA-seq analysis by performing several steps such as trimming, alignment, quantification, and summarizing the results.

## Prerequisites
Docker\
Nextflow

## Installation
Clone this repository: git clone https://github.com/your_username/RNA-seq-pipeline.git\
Build the Docker image: docker build -t rna-seq-pipeline .\
Make sure to adjust the paths and parameters in the config file to match your specific pipeline and system.

# Usage
To run the pipeline, use the following command:

```
nextflow run rnaseq_script.nf -c nextflow.config
```
This command runs the rnaseq_script.nf script with the options specified in the nextflow.config file

## Output
The pipeline generates several output files, including:

Trimmed fastq files\
Fastqc reports of the trimmed reads\
Aligned bam files\
Tab-separated gene counts\
MultiQC report\
The output files are located in the directory specified in the config file.

## Dependencies
The pipeline uses the following tools and libraries:

Trimmomatic\
FastQC\
STAR aligner\
FeatureCounts\
MultiQC\
All dependencies are included in the Docker image.


