#!/usr/bin/env nextflow


// Input and Output Directories
params.input_dir = "${params.input_dir}"
params.output_dir = "${params.output_dir}"

// Reference files
params.genomeIndex = "${params.genomeIndex}"
params.annotation = "${params.annotation}"
params.adapters = "${params.adapters}"

// Threads
params.threads = "${params.threads}"


//process takes fastq files input
//utilizes trimmomatic tool to trim for quality and adapter sequences

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


// fastqc reports of the trimmed reads

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

//star aligner to align reads to reference genome

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

// takes algined bam files and uses featurecount to perform quanitification
// returns a tab separated gene counts

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


// generates multiQC reports taking input counts and fastqc

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

//keywords to link out put of one process as input of the other


trimming.output -> fastqc_trimmed.input
fastqc_trimmed.output -> alignment.input
alignment.output -> quantification.input
quantification.output -> multiqc.input
