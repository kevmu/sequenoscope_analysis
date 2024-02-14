
## Create sequenoscope conda environment
# conda create --name sequenoscope_env

## Activate sequenoscope conda environment.
#conda activate sequenoscope

## Install sequenoscope conda package.
#conda install -c bioconda -c conda-forge sequenoscope_env

## The sequenoscope analyze program parameters.
fastq_file="/home/AGR.GC.CA/dumonceauxt/AS_sequenoscope/fastq/3HSS.fastq"
ref_fasta_file="/home/AGR.GC.CA/dumonceauxt/AS_sequenoscope/3-ONTPb3genome-V3_Flye_PH219.fa"
seq_type="SE"


analyze_output_dir="/home/AGR.GC.CA/dumonceauxt/AS_sequenoscope/analyze"
mkdir -p $analyze_output_dir

## The sequenoscope analyze program parameters.

# The adaptive-sampling sequencing decision classification. Valid options are 'unblocked', 'stop_receiving', or 'no_decision'.
classification_decision=""
echo "sequenoscope analyze --input_fastq ${fastq_file} --input_reference ${ref_fasta_file} -seq_type ${seq_type} --force -o ${analyze_output_dir}"
sequenoscope analyze --input_fastq ${fastq_file} --input_reference ${ref_fasta_file} -seq_type ${seq_type} --force -o ${analyze_output_dir}

#seq_summary_file="seq_summary.txt"

#sequenoscope filter_ONT --input_FASTQ <file.fq> --input_summary ${seq_summary_file} --classification -o <output.FASTQ>


#plot_output_dir="/home/AGR.GC.CA/dumonceauxt/AS_sequenoscope/plot"
#mkdir -p $plot_output_dir

#sequenoscope plot --test_dir <test_dir_path> --control_dir <control_dir_path> --output_dir <out_path>
