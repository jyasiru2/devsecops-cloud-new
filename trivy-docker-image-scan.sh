##!/bin/bash
#
#dockerImageName=$(awk 'NR==1 {print $2}' Dockerfile)
#echo $dockerImageName
#
##dockerImageName = this will be dig out from our docker file
#
#docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 0 --severity HIGH --light $dockerImageName
##this is used to find HIGH severity vulnerabilities with exit code 0
#
#docker run --rm -v $WORKSPACE:/root/.cache/ aquasec/trivy:0.17.2 -q image --exit-code 1 --severity CRITICAL --light $dockerImageName
##this is used to find CRITICAL severity vulnerabilities with exit code 1
#
#    # Trivy scan result processing
#    exit_code=$?
#    echo "Exit Code : $exit_code"
#
#    # Check scan results
#    if [[ "${exit_code}" == 1 ]]; then
#        echo "Image scanning failed. Vulnerabilities found"
#        exit 1;
#    else
#        echo "Image scanning passed. No CRITICAL vulnerabilities found"
#    fi;
