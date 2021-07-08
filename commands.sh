# project_id='273675412';
# project_id='276669428';
project_id='276983723';

# Get run name from basespace
run_name=$(bs get project -i ${project_id} --template='{{.Name}}');

# Create folder
mkdir -p ${run_name};

# Download FASTA and VCF files from BaseSpace
bs download project -i ${project_id} -o ${run_name}/ --extension=fa --extension=vcf.gz

# Merge fasta
cat ${run_name}/*/*.fa > ${run_name}/${run_name}.fa

# Create index on VCFs
for file in $(ls ${run_name}/*/*vcf.gz); do bcftools index ${file}; done

# Merge consensus_filtered_variants.vcf.gz files 
bcftools merge ${run_name}/*/*consensus_filtered_variants.vcf.gz -0 -O z -o ${run_name}/${run_name}.consensus_filtered_variants.vcf.gz
bcftools index ${run_name}/${run_name}.consensus_filtered_variants.vcf.gz

# Merge hard-filtered.vcf.gz files
bcftools merge ${run_name}/*/*hard-filtered.vcf.gz -0 -O z -o ${run_name}/${run_name}.hard-filtered.vcf.gz
bcftools index ${run_name}/${run_name}.hard-filtered.vcf.gz
