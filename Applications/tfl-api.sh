#! /bin/bash

#Storing app id and key for the TFL api
app_id="346a73f1"
app_key="3563c3ca9c0ce255026cb5bb815441b8"

# Storing arguments passed from the command line
no_args=$#
arg1=$1
arg2=$2
arg3=$3
arg4=$4

# https://api.tfl.gov.uk/BikePoint/Search?query=east&app_id=346a73f1&app_key=3563c3ca9c0ce255026cb5bb815441b8

function search_standard()
{ # Standard search based on place name

    if [[ $no_args == 2 ]]; then
        #Stores the JSON response from URL
        echo "https://api.tfl.gov.uk/BikePoint/Search?query=$arg2&app_id=$app_id&app_key=$app_key"
        response=$(curl -s "https://api.tfl.gov.uk/BikePoint/Search?query=$arg2&app_id=$app_id&app_key=$app_key")
        if [[ ! -n $arg2 || $response =~ .*System.Web.Http.HttpError.* || $response == "[]" ]]; then #Checks if response contains error message
            echo "Please specify a search term"
            #exit 10
        else    
           response=$(echo $response | sed -e 's/[{}]/''/g') #Striping special characters from JSON response
           printf "%20s %20s %20s %20s \n" "id" "Name" "Latitude" "Longitude" #Printing table headings
           # Storing our results for each field into an arrays
           id=($(echo $response | awk -v RS=',"' -F: '/^id/ {print $2}' | sed 's/\"//g'))
           IFS='"' read -r -a name <<< $(echo $response | awk -v RS=',"' -F: '/^commonName/ {print $2}' | sed 's/\n/ /g')
           #name=($(echo $response | awk -v RS=',"' -F: '/^commonName/ {print $2}' | sed 's/\"//g'))
           for((t=0;t<${#name[@]};t++));
           do
           	echo "Number $t: ${name[$t]/$del}"
           done

           echo "Test: ${name[2]}"
           latitude=($(echo $response | awk -v RS=',"' -F: '/^lat/ {print $2}'))
           longitude=($(echo $response | awk -v RS=',"' -F: '/^lon/ {print $2}'))
           for((i=0;i<${#id[@]};i++)); # Loops for the length of our results
           do
            printf "%20s %20s %20s %20s" ${id[$i]} ${name[$i]} ${latitude[$i]} ${longitude[$i]} | column -s -t	 # Prints each columns with item from array
           done

        fi
        # curl "https://api.tfl.gov.uk/BikePoint/Search?query=east&app_id=346a73f1&app_key=3563c3ca9c0ce255026cb5bb815441b8" | sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
    elif [[ $no_args == 3 ]]; then

        response=$(curl -s "https://api.tfl.gov.uk/BikePoint?lat=$arg2&lon=$arg3&radius=$arg4&app_id=$app_id&app_key=$app_key")
        if [[ $response =~ .*System.Web.Http.HttpError.* || $response == "[]" ]]; then #Checks if response contains error message
            #statements
            echo "The search request is invalid"
            # exit 11
        else #Conducts the search based on latitude, longitude and distance (radius)
           response=$(echo $response | sed -e 's/[{}]/''/g')
           printf "%-20s %-20s %-20s %-20s \n" "id" "Name" "Latitude,Longitude" "Distance"
           # Storing our results for each field into an array
           id=($(echo $response | awk -v RS=',"' -F: '/^id/ {print $2}' | sed 's/\"//g'))
           name=($(echo $response | awk -v RS=',"' -F: '/^commonName/ {print $2}' | sed 's/\"//g'))
           latitude=($(echo $response | awk -v RS=',"' -F: '/^lat/ {print $2}'))
           longitude=($(echo $response | awk -v RS=',"' -F: '/^lon/ {print $2}'))
           distance=($(echo $response | awk -v RS=',"' -F: '/^distance/ {print $2}'))

           for((i=0;i<${#id[@]};i++)); # Loops for the length of our results
           do
           		printf "%-20s %-20s %-20s %-20s" ${id[$i]} ${name[$i]} ${latitude[$i]},${longitude[$i]} ${distance[$i]} | column -s -t # Prints each columns with item from array
           done
        fi
    else
    	echo "Please specify a search term"
    	#exit 10	
    fi

}

function id()
{ # Displays information about the bike point id

   # Storing the JSON response
	response=$(curl -s "https://api.tfl.gov.uk/BikePoint/$arg2?app_id=346a73f1&app_key=3563c3ca9c0ce255026cb5bb815441b8")
    if [[ ! -n $arg2 || $response =~ .*System.Web.Http.HttpError.* || $response == "[]" ]]; then #Checks if response contains error message or is empty
        echo "Please specify a bike point id"
        exit 12
    elif [[ $response =~ .*'The following input'.* ]]; then #Checking if bikepoint exists in the response
        echo "Bike point id $arg2 not recognised"
        exit 13
    else #statements
        response=$(echo $response | sed -e 's/[{}]/''/g')
        printf "%-20s %-20s %-20s %-20s %-20s \n" "Name" "Latitude" "Longitude" "Num Bikes" "Empty Docks"
        # Storing our results for each field into an array
        name=($(echo $response | awk -v RS=',"' -F: '/^commonName/ {print $2, $3}' | sed 's/\"//g'))
        latitude=($(echo $response | awk -v RS=',"' -F: '/^lat/ {print $2}'))
        longitude=($(echo $response | awk -v RS=',"' -F: '/^lon/ {print $2}'))
        num_bikes=($(echo $response | awk -v RS=',"' -F: '/^NbBikes/ {print $2}'))
        empty_docks=($(echo $response | awk -v RS=',"' -F: '/^NbEmptyDocks/ {print $2}'))

        for((i=0;i<${#latitude[@]};i++)); # Loops for the length of our results
        	do
        		printf "%-20s %-20s %-20s %-20s %-20s \n" ${name[$i]} ${latitude[$i]} ${longitude[$i]} ${num_bikes[$i]} ${empty_docks[$i]} | column -s -t # Prints each columns with item from array
        	done
    fi
}
	
    case "$1" in
      "") # Prints out usage information when no arguments are defined
         echo "Usage: "
         echo "londonbikes search <search_string> "
         echo "londonbikes search <latitude> <longitude> <radius_in_metres>"
         echo "londonbikes id <bike_point_id>"
         ;;
      search)
         search_standard
         ;;
      id)
         id
         ;;
    esac
