FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    openjdk-8-jre-headless \
    trimmomatic \
    STAR \
    subread \
    fastqc \
    multiqc 

RUN wget https://github.com/nextflow-io/nextflow/releases/download/v20.10.0/nextflow \
    && chmod +x nextflow \
    && mv nextflow /usr/local/bin/

COPY genomeIndex /path/to/genomeIndex
COPY annotation.gtf /path/to/annotation.gtf
COPY adapters.fa /path/to/adapters.fa
COPY my_pipeline.nf /path/to/my_pipeline.nf

ENV PATH="/path/to/genomeIndex:${PATH}"

CMD ["nextflow", "run", "/path/to/my_pipeline.nf", "--genomeIndex", "/path/to/genomeIndex", "--annotation", "/path/to/annotation.gtf", "--adapters", "/path/to/adapters.fa", "--input_dir", "/path/to/input_fastq_files", "--output_dir", "/path/to/output_files", "--threads", "8"]

