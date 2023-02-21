#!/bin/bash

function main() {
  set -e -x -o pipefail  # Output each line as executed, exit bash upon error
  if [ "$skip" == false ];
    then
      input_location=/home/dnanexus/in
      output_location=/home/dnanexus/out
      csv_out=${output_location}/polyedge_csv/polyedge
      html_out=${output_location}/polyedge_html/polyedge
      pdf_out=${output_location}/polyedge_pdf/polyedge
      dx-download-all-inputs --parallel
      # Create input and output dirs
      mkdir -p /data ${csv_out} ${html_out} ${pdf_out}
      mv ${input_location}/*/* /data  #  Easier to mount to docker when in one dir

      docker_fileid=project-ByfFPz00jy1fk6PjpZ95F27J:file-GPkqbz80jy1XgXv1JvVZ6J9V
  		dx download ${docker_fileid}
      # Get name of docker file (should include the version) and name of image
      docker_filename=$(dx describe ${docker_fileid} --name)
      # --force-local required as if tarfile name contains a colon it tries to resolve the tarfile to a machine name
  		docker_imagename=$(tar xfO "${docker_filename}" manifest.json --force-local | sed -E 's/.*"RepoTags":\["?([^"]*)"?.*/\1/')
    	docker load < "${docker_filename}"  # Load docker image
      sudo docker images
    	docker run -v /data/:/data/ -v ${output_location}:/outputs/ "${docker_imagename}" -B /data/${BAM_name} -I /data/${BAI_name} -G ${gene} -S ${poly_start} -E ${poly_end} -C ${chrom}      
      
      # Move outputs into their respective output folders to delocalise into the dnanexus project
      mv ${output_location}/*.csv ${csv_out}
      mv ${output_location}/*.pdf ${pdf_out}
      mv ${output_location}/*.html ${html_out}
      dx-upload-all-outputs --parallel
  fi
  }
