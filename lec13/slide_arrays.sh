#!/usr/bin/env bash

# You should work through the slides and uncomment each section as you continue.
# Most text editors allow you to do ctrl+/ (or cmd+/) to comment or uncomment
# a block of lines.

# print a visual separator
function sep() {
    echo '#######################################################################################'
}
#######################################################################################
# Declaration slide
#######################################################################################
arr[11]=11
arr[22]=22
arr[33]=33
arr[51]="a string value"
arr[52]="different string value"
# sep
#######################################################################################
# Print some values
#######################################################################################
# echo "Index 11: ${arr[11]}" # prints: Index 11: 11
# echo "Index 51: ${arr[51]}" # prints: Index 51: a string value
# echo "Index 0: ${arr[0]}"   # DOES NOT EXIST! (aka nothing)
# sep
#######################################################################################
# Print expansions take 1
#######################################################################################
# echo "Individual: ${arr[@]}"
# echo "Joined::::: ${arr[*]}"
# sep
#######################################################################################
# Print expansions take 2
#######################################################################################
# echo "Length of Individual: ${#arr[@]}"
# echo "Length of Joined::::: ${#arr[*]}"
# sep
#######################################################################################
# Print expansions take 3
#######################################################################################
# echo '@ Expansion'
# for x in "${arr[@]}"; do echo "$x"; done
# echo '* Expansion'
# for x in "${arr[*]}"; do echo "$x"; done
# sep
#######################################################################################
# Even more initialization options
#######################################################################################
# arr[44]=$((arr[11] + arr[33]))
# echo "Index 44: ${arr[44]}"     # Index 44: 44
# arr[55]=$((arr[11] + arr[44]))
# echo "Index 55: ${arr[55]}"     # Index 55: 55
# new_arr=([17]="seventeen" [24]="twenty-four")
# new_arr[99]="ninety nine" # may as well, not new
# for x in "${new_arr[@]}"; do echo "$x"; done
# for idx in "${!new_arr[@]}"; do echo "$idx"; done
# sep
#######################################################################################
# Splicing
#######################################################################################
# zed=( zero one two three four )
# echo "From start: ${zed[@]:0}"
# echo "From 2: ${zed[@]:2}"
# echo "Indices [1-3]: ${zed[@]:1:3}"
# for x in "${zed[@]:1:3}"; do echo "$x"; done
# for x in "${zed[*]:1:3}"; do echo "$x"; done
# sep
