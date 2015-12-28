#! /usr/bin/env python
import sys
import argparse # Import the optparse package to parse command line options

app_id = "346a73f1"
app_key = "3563c3ca9c0ce255026cb5bb815441b8"

def usage_message():
	return 	'''
	londonbikes search <search_string> 
	londonbikes search <latitude> <longitude> <radius_in_metres>
	londonbikes id <bike_point_id>'''
			
def search_normal():
	print "Normal search"

def search_long():
	print "Long search"




parser = argparse.ArgumentParser(description="Process search and id inputs", usage=usage_message()) # Creating an argument parser
parser.add_argument(
        'search', metavar='str', type=str, choices=xrange(1, 3),
         nargs='+', help='an integer in the range 1..3')
args = parser.parse_args()



