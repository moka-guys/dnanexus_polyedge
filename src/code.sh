#!/bin/bash

# The following line causes bash to exit at any point if there is any error
# and to output each line as it is executed -- useful for debugging
set -e -x -o pipefail
if [ $skip == false ];
	then		
		mark-section "download inputs"
		dx-download-all-inputs --parallel
		
		# move bam index into sample folder as BAM
		mv $BAI_path /home/dnanexus/in/BAM/
		
		# make output folder
		mkdir -p ~/out/polyedge_output/MSH2_polyedge
		
		# download polyedge docker
		Docker_file_ID=project-GGkXf800y0kGvj2086zfvKk3:file-GGp31zQ0y0k678Xv4bF1b33P #TODO move to 001
  		dx download ${Docker_file_ID}
		# get name of the docker file (should include the version) and the name of the image
		Docker_image_file=$(dx describe ${Docker_file_ID} --name)
  		Docker_image_name=$(tar xfO "${Docker_image_file}" manifest.json | sed -E 's/.*"RepoTags":\["?([^"]*)"?.*/\1/')
		# Load docker image
		docker load < /home/dnanexus/"${Docker_image_file}"

		# Get sample name
		sample_name=$BAM_prefix
		echo $sample_name
		# run docker image
  		docker run -v /home/dnanexus/in/BAM:/data ${Docker_image_name} /data/$BAM_name 1>~/out/polyedge_output/MSH2_polyedge/${sample_name}_msh2_polyedge.txt 2>~/out/polyedge_output/MSH2_polyedge/${sample_name}_stderr.txt
		cat ~/out/polyedge_output/MSH2_polyedge/${sample_name}_msh2_polyedge.txt
		cat ~/out/polyedge_output/MSH2_polyedge/${sample_name}_stderr.txt
		
		# Send output back to DNAnexus project
		mark-section "Upload output"
		dx-upload-all-outputs --parallel
fi
mark-success