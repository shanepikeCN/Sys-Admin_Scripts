#! /bin/bash

#Storing app id and key for the TFL api
APP_ID="346a73f1"
APP_KEY="3563c3ca9c0ce255026cb5bb815441b8"
ARG2=$2
ARG3=$3
ARG4=$4

# Test
# https://api.tfl.gov.uk/BikePoint/Search?query=east&app_id=346a73f1&app_key=3563c3ca9c0ce255026cb5bb815441b8

function search_name()
{
	json_response=$(curl -s "https://api.tfl.gov.uk/BikePoint/Search?query=$ARG2&app_id=$APP_ID&app_key=$APP_KEY")
	if [[ -z $ARG2 || $json_response == '[]' ]]; then
		echo "Please specify a search term"
		#exit 10
	fi
	echo $json_response | sed -e 's/[{}]/''/g' | awk '
		BEGIN{ 
			format = "%-5s            %-5s \t %-5s %-5s \n"
			printf format, "Id", "Name", "Latitude", "Longitude"
			RS=",\""; FS=":"; OFS="\t"; ORS="";
		}	
		/id/{printf "%-5s ", $2}/commonName/{printf "%-5s \t", $2}/lat/{printf "%-5s ", $2}/lon/{printf "%-5s \n", $2}
		' | sed 's/\"//g'  | column -ts $'\t'
}

function search_metric()
{	
	json_response=$(curl -s "https://api.tfl.gov.uk/BikePoint?lat=$ARG2&lon=$ARG3&radius=$ARG4&app_id=$APP_ID&app_key=$APP_KEY")
	if [[ -z $ARG2 || $json_response =~ .*HttpError.* || $json_response == '[]' ]]; then
		echo "The search request is invalid"
		#exit 11
	fi
	echo $json_response | sed -e 's/[{}]/''/g' | awk '
		BEGIN{ 
			format = "%s \t %s \t %s %s %s \n"
			printf format, "Id", "Name", "Latitude", "Longitude", "Distance"
			RS=",\""; FS=":"; OFS="\n"; ORS="\n";
		}	
		# /id/{printf "%-5s \t", $2}/commonName/{printf "%-5s \t", $2}
		# 
		/id/{printf "%s \t", $2}/commonName/{printf "%s \t", $2}/lat/{printf "%s \t", $2}
		/lon/{printf "%s \t", $2}
		/distance/{printf "%s \n", $2}
		' | sed 's/\"//g' | column -ts $'\t'

}

function id_bikepoint()
{
	json_response=$(curl -s "https://api.tfl.gov.uk/BikePoint/$ARG2?app_id=346a73f1&app_key=3563c3ca9c0ce255026cb5bb815441b8")
	if [[ -z $ARG2 || $json_response =~ .*HttpError.* || $json_response == '[]' ]]; then
		echo "Please specify a bike point app_id"
		#exit 12
	elif [[ $json_response =~ .*'The following input is not recognised.'* ]]; then
		echo "Bike point id <$ARG2> not recognised"
		#exit 13
	fi
		echo $json_response
}

function print_usage()
{
		echo "Usage:"
		echo "londonbikes search <search_string>"
		echo "londonbikes search <latitude> <longitude> <radius_in_metres>"
		echo "londonbikes id <bike_point_id>"
}

case $1 in
	search)
		if [[ $# == 2 ]]; then
			search_name
		elif [[ $# == 4 ]]; then
			search_metric
		else
			print_usage
		fi
		;;
	id)
		id_bikepoint
		;;
	*) 
		print_usage
		;;
esac