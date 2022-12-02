#!/bin/bash

function main() {
  # Causes bash to exit at any point if there is any error and output each line as it is executed - useful for debugging
  set -e -x -o pipefail
  if [ "$skip" == false ];
    then
      dx-download-all-inputs --parallel
      mv /home/dnanexus/in/*/* /home/dnanexus/in
      docker_fileid=project-ByfFPz00jy1fk6PjpZ95F27J:file-GK4FQYQ0jy1pZ3qV6bFkVfPy
  		dx download ${docker_fileid}

      # Get name of docker file (should include the version) and name of image
      docker_filename=$(dx describe ${docker_fileid} --name)
  		docker_imagename=$(tar xfO "${docker_filename}" manifest.json | sed -E 's/.*"RepoTags":\["?([^"]*)"?.*/\1/')

      # Make output folder & load docker image
      mkdir -p ~/out/polyedge_output/MSH2_polyedge
    	docker load < "${docker_filename}"

      # '-a stderr' prints any error messages
    	docker run -v /home/dnanexus/in:/data "${docker_imagename}" /data/"${BAM_name}" \
    	1>~/out/polyedge_output/MSH2_polyedge/"${BAM_prefix}".msh2_polyedge.txt
  		dx-upload-all-outputs --parallel
  fi
  }