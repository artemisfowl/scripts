#!/bin/bash
# Author : sb

# Brief : make a script which will perform the following task
# ffmpeg -i input.mkv  -acodec libmp3lame -ac 2 -ab bit_rate(k) -ar 48000 ./output.mp3

help() {
	echo -e "convert script help information"
	printf "\n"
	echo -e "Usage: convert_to_mp3.sh -i <input_file_path> -o <output_file_path> -b <bit_rate>"
	echo -e "-h, --help : display this help information"
	echo -e "-i 	   : Input filepath flag"
	echo -e "-o 	   : Output filepath flag"
	echo -e "-b 	   : bit rate flag"
}

check_args() {
	check_input=0												# flag check for input file
	check_output=0											# flag check for output file
	check_br=0													# flag check for bitrate

	inp_flag_count=0
	output_flag_count=0
	br_flag_count=0

	# Iterate through the list of arguments
	for var in "$@"
	do
		if [ "$var" == "--help" ] || [ "$var" == "-h" ];
		then
			return 1												# show the help information
		elif [ "$var" == "-i" ];
		then
			check_input=1
			inp_flag_count=$((inp_flag_count+1))
		elif [ "$var" == "-o" ];
		then
			check_output=1
			output_flag_count=$((output_flag_count+1))
		elif [ "$var" == "-b" ];
		then
			check_br=1
			br_flag_count=$((br_flag_count+1))
		fi

		if [ $inp_flag_count -gt 1 ] || [ $output_flag_count -gt 1 ] || [ $br_flag_count -gt 1 ];
		then
			echo -e "Too many input/output filepaths/bit rate inputs"
			printf "\n"
			help
			exit
		fi

		if [ "$check_input" -eq "1" ] && [ "$var" != "-i" ] && [ "$inp_flag_count" == "1" ];
		then
			input_file="$var"
			check_input=0										# reset the flag
		fi
		if [ "$check_output" -eq "1" ] && [ "$var" != "-o" ] && [ "$output_flag_count" == "1" ];
		then
			output_file="$var"
			check_output=0									# reset the flag
		fi
		if [ "$check_br" -eq "1" ] && [ "$var" != "-b" ] && [ "$br_flag_count" == "1" ];
		then
			bit_rate="$var"
			check_output=0									# reset the flag
		fi
	done
}

main() {
	input_file=""
	output_file=""
	bit_rate=""

	check_args "$@"
	result="$?"

	if [ "$result" -eq "1" ];
	then
		help
		exit
	fi

	# input file should be present
	if [ -z "$input_file" ];
	then
		echo -e "input file not provided"
		exit
	fi

	# output file should be present
	if [ -z "$output_file" ];
	then
		echo -e "output file not provided"
		exit
	fi

	# bit rate should be present
	if [ -z "$bit_rate" ];
	then
		echo -e "bit rate not provided"
		exit
	fi

	echo -e "Input file : $input_file"
	echo -e "Output file : $output_file"
	echo -e "Bit Rate : $bit_rate"

	# make the final call to the ffmpeg function
	ffmpeg -i "$input_file"  -acodec libmp3lame -ac 2 -ab "${bit_rate}k" -ar 48000 "$output_file"
}

# main script execution starts here
main "$@"
