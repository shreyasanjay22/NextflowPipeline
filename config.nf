// Nextflow Config File

// Process execution
executor = "local"
process.executor = 'local'
process.queue = 'long'

// Input and Output Directories
params.input_dir = "/path/to/input_fastq_files"
params.output_dir = "/path/to/output_files"

// Reference files
params.genomeIndex = "/path/to/genomeIndex"
params.annotation = "/path/to/annotation.gtf"
params.adapters = "/path/to/adapters.fa"

// Threads
params.threads = 8

// Docker Configuration
docker.enabled = true
docker.image = "image_name"
