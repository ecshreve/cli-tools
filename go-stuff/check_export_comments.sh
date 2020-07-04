#!/bin/bash
#
# Take a .go file as input, find exported types and functions that don't have 
# doc comments, and add a TODO comment on the line above them.

# process_file 
# input: $1: filename $2: [type, func]
process_file () {
	file=$1
	echo "Processing $file" 
	categoriesToCheck=("func" "type")

	for category in ${categoriesToCheck[@]}
	do
		check_category $file $category
		echo "Found $? exported $category without comments."
	done

	echo "Done processing $file"
	echo
}

# check_category
# input: $1: filename $2: [type, func]
# return: $count: number of comments added
check_category () {
	case $2 in
	func)
		comment="\/\/ TODO: this exported function should have a comment describing it."

		# Regex to match an exported function signature.
		regex='^func (.*) [A-Z].* {$'
		;;
	type)
		comment="\/\/ TODO: this exported type should have a comment describing it."

		# Regex to match an exported type signature.
		regex='^type [A-Z][a-zA-Z0-9]* struct {$'
		;;
	esac

	# Get lines in file that match the regex.
	exportedVals=$(grep -n "$regex" $file)

	# Pull out the line numbers of the exported values into an array.
	exportedLines=( $(echo $exportedVals | cut -d':' -f1) )

	# We have to keep track of how many times we do a replacement because we do
 	# the replacements in-place, which adds a line to the file.
	count=0
	for line in ${exportedLines[@]} 
	do
		lineNumberToTest=$(($line - 1 + $count))

		# Check if the line above the exported value is empty, if it is then add
		# the TODO comment.
		check_line $file $lineNumberToTest
		retval=$?
		if [ "$retval" -eq "1" ]
		then
			gsed -E -i "$lineNumberToTest s/^\s*$/\n$comment/" "$file"
		fi
		((count=count+retval))
	done
	return $count
}


# check_line
# input: $1: filename $2: lineNumber
# return: 1 if lineNumber in filename is empty, 0 otherwise
check_line () {
	file=$1
	lineNumberToTest=$2

	lineToTest=$(gsed -n "$lineNumberToTest p" "$file")
	if [[ $lineToTest =~ ^[[:space:]]*$ ]]
	then
		return 1
	fi

	return 0
}

# Get an array of files in this directory.
files=( $(find . -type f -name '*.go') )

for file in ${files[@]}
do
	process_file $file
done
