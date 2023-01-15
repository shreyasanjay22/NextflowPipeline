

params.genomeIndex = "/path/to/genomeIndex"
params.annotation = "/path/to/annotation.gtf"
params.adapters = "/path/to/adapters.fa"
params.input_dir = "/path/to/input_fastq_files"
params.output_dir = "/path/to/output_files"
params.threads = 8

/
*
*process takes fastq files input
*Utilizes trimmomatic tool to trim for quality and adapter sequences
*
/

process trimming {
    input:
        file("${params.input_dir}/*.fastq")

    output:
        file("${params.output_dir}/*.trim.fastq")

    script:
        """
        trimmomatic SE -phred33 ${input} ${output} ILLUMINACLIP:${params.adapters}:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
        """
}

/
*
*
*
/
process fastqc_trimmed {
    input:
        file("${params.output_dir}/*.trim.fastq")

    output:
        file("${params.output_dir}/fastqc/*.zip")

    script:
        """
        fastqc ${input} -o ${params.output_dir}/fastqc
        """
}


/
*
*star aligner to align reads to reference genome
*
/

process alignment {
    input:
        file("${params.output_dir}/*.trim.fastq")

    output:
        file("${params.output_dir}/*.bam")

    script:
        """
        STAR --genomeDir ${params.genomeIndex} --readFilesIn ${input} --outFileNamePrefix ${output} --runThreadN ${params.threads}
        """
}


/
*
*Takes algined bam files and uses featurecount to perform quanitification
*Output is tab separated gene counts
/
process quantification {
    input:
        file("${params.output_dir}/*.bam")

    output:
        file("${params.output_dir}/*.counts")

    script:
        """
        featureCounts -a ${params.annotation} -o ${output} ${input} -p -t exon -g gene_id -T ${params.threads}
        """
}

/
*
*
*
/

process multiqc {
    input:
        file("${params.output_dir}/*.counts"),
        file("${params.output_dir}/fastqc/*.zip")

    output:
        file("${params.output_dir}/multiqc_report.html")

    script:
        """
        multiqc ${params.output_dir} -f -o ${params.output_dir}
        """
}

/
*
*Channel keywords to link out put of one process as input of the other
*
/

trimming.output -> fastqc_trimmed.input
fastqc_trimmed.output -> alignment.input
alignment.output -> quantification.input
quantification.output -> multiqc.input
