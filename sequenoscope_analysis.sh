
## Create sequenoscope conda environment
# conda create --name sequenoscope_env

## Activate sequenoscope conda environment.
#conda activate sequenoscope

## Install sequenoscope conda package.
#conda install -c bioconda -c conda-forge sequenoscope_env

#source ~/.bash_profile
source ~/.bashrc

conda activate sequenoscope

## The sequenoscope program parameters.

# The fastq file input directory.
fastq_input_dir="/Users/kevin.muirhead/Desktop/AAFC_Bioinformatics/sequenoscope/sequenoscope_analysis/fastqs"

# The extension of the fastq files. Can either be ".fastq" or ".fastq.gz"
fastq_extension=".fastq.gz"
#fastq_extension=".fastq"

# The ONT sequencing summary file.
seq_summary_file="/home/AGR.GC.CA/dumonceauxt/AS_sequenoscope/clubroot/sequencing_summary_FAW00817_8cd54fd6_63549f2a.txt"

# The fastq reference file.
ref_fasta_file="/Users/kevin.muirhead/Desktop/AAFC_Bioinformatics/sequenoscope/sequenoscope_analysis/3-ONTPb3genome-V3_Flye_PH219.fa"
#ref_fasta_file="/home/AGR.GC.CA/dumonceauxt/AS_sequenoscope/3-ONTPb3genome-V3_Flye_PH219.fa"

# The output filename prefix.
output_filename_prefix="3HSS_clubroot"

# The output file directory.
output_dir="/Users/kevin.muirhead/Desktop/AAFC_Bioinformatics/sequenoscope/sequenoscope_analysis/output"
mkdir -p $output_dir

## The sequenoscope filter_ONT program parameters.

# The adaptive-sampling sequencing decision classification. Valid options are 'unblocked', 'stop_receiving', or 'no_decision'.
classification_method="unblocked"

## The sequenoscope analyze program parameters.

# The sequence type.
seq_type="SE"

# The output fastq file to write the concatenated files to.
combined_fastq_file="${output_dir}/${output_filename_prefix}.fastq"

# If the combined_fastq_file does not exist then concatenate fastq files into one uncompressed fastq file.
if [ ! -s $combined_fastq_file ]; then
    # Find all the fastq files with the given extension, sort files and iterate over each file path and concatenate into one fastq file.
    for fastq_file in $(find ${fastq_input_dir} -type f -name "*${fastq_extension}" | sort -V);
    do
    #    echo ${fastq_file};

        # If the fastq extension is ".fastq.gz" then use gunzip -c to uncompress the gzip file.
        if [[ $(echo ${fastq_extension} | grep ".fastq.gz") ]]; then
            echo "gunzip -c ${fastq_file} >> ${combined_fastq_file}";
            #gunzip -c ${fastq_file} >> ${combined_fastq_file}
            
        # Else If the fastq extension is ".fastq" then then use the cat command to concatenate the files.
        elif [[ $(echo ${fastq_extension} | grep ".fastq") ]]; then
            echo "cat ${fastq_file} >> ${combined_fastq_file}";
            #cat ${fastq_file} >> ${combined_fastq_file}
        fi
    done
else
    fastq_output_filename=$(basename $combined_fastq_file)
    echo "The ${fastq_output_filename} file has already been created. Skipping to next set of commands!!!"
    
fi

# The sequenoscope analyze output directory.
analyze_output_dir="${output_dir}/analyze"
mkdir -p $analyze_output_dir

# The sequenoscope analyze command.
echo "sequenoscope analyze --input_fastq ${combined_fastq_file} --input_reference ${ref_fasta_file} -seq_type ${seq_type} --force -o ${analyze_output_dir} -op ${output_filename_prefix}"
sequenoscope analyze --input_fastq ${combined_fastq_file} --input_reference ${ref_fasta_file} -seq_type ${seq_type} --force -o ${analyze_output_dir} -op ${output_filename_prefix}

# The sequenoscope filter_ONT output directory.
filter_output_dir="${output_dir}/filtered_fastq"
mkdir -p $filter_output_dir

# The sequenoscope filter_ONT command.
echo "sequenoscope filter_ONT --input_fastq ${combined_fastq_file}--classification unblocked --input_summary ${seq_summary_file} -o ${filter_output_dir} -op ${output_filename_prefix}"
sequenoscope filter_ONT --input_fastq ${combined_fastq_file}--classification unblocked --input_summary ${summary_input_file} -o ${filter_output_dir} -op ${output_filename_prefix}

# The sequenoscope plot output directory.
plot_output_dir="${output_dir}/plot"
mkdir -p $plot_output_dir

# The sequenoscope plot command.
echo "sequenoscope plot --test_dir ${analyze_output_dir} --control_dir ${analyze_output_dir} --output_dir ${plot_output_dir}"
sequenoscope plot --test_dir ${analyze_output_dir} --control_dir ${analyze_output_dir} --output_dir ${plot_output_dir}
