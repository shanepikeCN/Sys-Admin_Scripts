#! /bin/bash
OLD_IFS=$IFS; IFS="," # Settings field seperate for CSV files

while read product price quantity
do
	echo -e "\e[1;33m$product ========================\e[0m\n\
	Price : \t $price \n\
	Quantity: \t $quantity \n"
done < $1
IFS=$OLD_IFS