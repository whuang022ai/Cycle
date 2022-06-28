#!/bin/bash 
rootpath="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
source $rootpath/3rd_partylib/bash_progress_bar-master/progress_bar.sh                                                       
logo() {
cat <<"EOT"
-------------------------------------------


     █▀▀  █▄█  █▀▀  █░░  █▀▀  ░  █▀  █░█
     █▄▄  ░█░  █▄▄  █▄▄  ██▄  ▄  ▄█  █▀█       
               
                  v 0.0.1

-------------------------------------------
EOT
}

# set help msg
function help(){
  logo
  echo "Cycle.sh is a small script to auto-run the custom commands with looping in folders."
  printf "Usage: ./$(basename $0) \n [-i input root path] \n [-o output root path] \n [-p output postfix ,defult is 'result' ] \n [-a (input folder prefix) -b (input folder postfix )for input folder pattern a*b  , defult is all ] \n [-n not creat output sub folder , defult will creat by mkdir command] \n [-s not show progress bar , defult is yes] \n"
  exit 1
}
# get args
output_postfix='result'
input_prefix=""
input_postfix=""
use_input_dir=0
use_output_dir=0
use_cmd=0
creat_output_dir=1
with_progress_bar=1
while getopts 'hi:o:c:p:a:b:ns' OPTION; do
  case "$OPTION" in 
    i) 
      input_dir=${OPTARG}
      use_input_dir=1
      ;;

    o)
      output_dir=${OPTARG}
      use_output_dir=1
      ;;

    c)
      cmd_file=${OPTARG}
      use_cmd=1
      ;;    

    p)
      output_postfix=${OPTARG}
      ;;
    
    a)
      input_prefix=${OPTARG}
      ;;

    b)
      input_postfix=${OPTARG}
      ;;  

    n)
      creat_output_dir=0
      ;;
    s)
      with_progress_bar=0
      ;;      
    ?)
      help
      ;;
    h | *)
      help
  esac
done
# check must have args
if [ "$use_input_dir" -eq 0 ] || [ "$use_output_dir" -eq 0 ] || [ "$use_cmd" -eq 0 ]; then
    echo 'Options -i <input dir> or -o <output dir> or -c < command define file> are missing' 
    echo
    help
fi
# creat cmd file
[ -e .fcycle.sh ] && rm .fcycle.sh
echo 'function run_for_each_sub_dir { ' >> .fcycle.sh
cat $cmd_file >> .fcycle.sh
echo >> .fcycle.sh
echo '}'>> .fcycle.sh
source .fcycle.sh
logo
if [ "$with_progress_bar" -eq 1 ]; then
  enable_trapping
  setup_scroll_area
fi
total=0
counter=0
for input_sub_dir in "$input_dir"/$input_prefix*$input_postfix
do
  let "total+=1"
done
# loop through sub dir
for input_sub_dir in "$input_dir"/$input_prefix*$input_postfix
do
  sub_dir_name=`basename "$input_sub_dir"`
  output_each_dir=""
  output_each_dir=$output_dir"/"$sub_dir_name"_"$output_postfix
  echo  "current procressing input dir : $input_sub_dir"
  echo "current output dir : $output_each_dir"
  if [ "$creat_output_dir" -eq 1 ]; then
    mkdir $output_each_dir
  fi 
  run_for_each_sub_dir $input_sub_dir $output_each_dir
  let "counter+=1"
  percent=$(awk "BEGIN { pc=100*${counter}/${total}; i=int(pc); print (pc-i<0.5)?i:i+1 }")
  if [ "$with_progress_bar" -eq 1 ]; then
    draw_progress_bar $percent
  fi 
  echo "-----------------------"
done
sleep 1
if [ "$with_progress_bar" -eq 1 ]; then
  destroy_scroll_area
fi
wait
rm .fcycle.sh