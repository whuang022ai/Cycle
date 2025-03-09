[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---
     █▀▀  █▄█  █▀▀  █░░  █▀▀  ░  █▀  █░█
     █▄▄  ░█░  █▄▄  █▄▄  ██▄  ▄  ▄█  █▀█       
               
                  v 0.0.1

---
# About

Cycle.sh is a small bash script to auto-run the custom commands with looping in folders in linux-like system.

# Install

### 1.download this project:

```
git clone
```

### 2. install 3rd_partylib with run install_3rd.sh

```
./Cycle/3rd_partylib/./install_3rd.sh
```

### 3. add your path to Cycle to $PATH , for example :

using vim open ~/.bashrc

```
sudo vim ~/.bashrc
```
edit .bashrc , add the path :

```
PATH=~/Cycle/:$PATH
```

```
source ~/.bashrc
```


# Usage

./cycle.sh

-i input root path

-o output root path

-p output postfix ,defult is 'result' 

-a input folder prefix 

-b input folder postfix for input 

(search folder pattern as a*b  , defult is all) 

-n not creat output sub folder , defult will creat by mkdir command 

use

# Define custom commands

please use those two var : 

$input_sub_dir , the root of input folder for each loop

$output_each_dir, the output folder  for each loop

to define the commands your own , for example:

custom_cmd.sh:

``` bash
cmd='ls $input_sub_dir > $output_each_dir/data.txt &'
echo "run cmd : "$cmd
eval $cmd

```
and run :

``` bash
./cycle.sh -i ./test -o ./out -c custom_cmd.sh 

```
the outputs will be like: 
```

current procressing input dir : ./test/1
current output dir : ./out/1_result
run cmd : ls $input_sub_dir > $output_each_dir/data.txt &
-----------------------
current procressing input dir : ./test/2
current output dir : ./out/2_result
run cmd : ls $input_sub_dir > $output_each_dir/data.txt &
-----------------------
current procressing input dir : ./test/3
current output dir : ./out/3_result
run cmd : ls $input_sub_dir > $output_each_dir/data.txt &
-----------------------

```


The input path structure:

```bash

Cycle/test
├── 1
│   └── 1.txt
├── 2
│   └── 2.txt
└── 3
    └── 3.txt

3 directories, 3 files
```

The output path structure:

```bash

/Cycle/out
├── 1_result
│   └── data.txt
├── 2_result
│   └── data.txt
└── 3_result
    └── data.txt

3 directories, 3 files
```
# Application example for looping fastqc

### 1. load data from fastq-dump

```bash
./test_2/./load_data.s
```

### 2. creat command file custom_cmd2.sh:

```bash
fastqc -t 16 -o $output_each_dir $input_sub_dir/fastq
```
### 3. run Cycle.sh

```bash
./cycle.sh -i ./test_2 -o ./out_2 -c custom_cmd2.sh -p fastqc -a SRR
```

result will be

```bash

├── SRR650259_fastqc
│   ├── fastq_fastqc.html
│   └── fastq_fastqc.zip
├── SRR650290_fastqc
│   ├── fastq_fastqc.html
│   └── fastq_fastqc.zip
├── SRR651263_fastqc
│   ├── fastq_fastqc.html
│   └── fastq_fastqc.zip
├── SRR651328_fastqc
│   ├── fastq_fastqc.html
│   └── fastq_fastqc.zip
└── SRR651357_fastqc
    ├── fastq_fastqc.html
    └── fastq_fastqc.zip
```
