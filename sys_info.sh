#!/bin/bash
if [ $# -lt 1  ]
    then
    echo "Usage: sys_info.sh -spfmdh

    -s                Get System Name
    -p                Get CPU information
    -f                Get CPU frequency
    -m                Get Memory information
    -d <name>         Get Hard Disk information
    -h                Print this message" 
    exit 
fi

checkOptions () {
    if [[ $OPTARG =~ ^-[d]$ ]]
        then
        echo "no argument"
        exit 1
    fi
}

while getopts "spfmd:h" opt
    do
        case $1 in
        # get system name
     -s)  
        manufacturer=$(dmidecode | awk '/Manufacturer/ { print $2,$3,$4}' | awk 'NR == 1')
        productName=$(dmidecode | awk  '/Product Name/ { print $3,$4 }' | awk 'NR == 1') 
        echo $manufacturer  $productname ;;
        #get CPU info
     -p)
        cores=$(lscpu | awk '/^Socket\(s\)/{ print $2 }')
        parametr=$(cat /proc/cpuinfo | grep -m 1 "model name" | sed 's/model name[ \t]*:[ \t]/''/i')
        processor=$(nproc --all)
        echo $cores x $parametr \($processor Cores\) ;;
        # get CPU frequency
     -f)
        dmidecode | awk '/Max Speed/ {print $3}' ;;
        # get memery info
     -m)
        numberOfDevice=$(dmidecode -t memory | awk 'NR=!/No/' | awk '/Size/  { print $2$3 }'| wc -l) 
        size=$(dmidecode -t memory | awk 'NR=!/No/'| awk '/Size/{ print $2$3 }' | uniq )
        formfactor=$(dmidecode -t memory | awk '/Form Factor/  { print $3 }' | awk 'NR == 1')
        speed=$(dmidecode -t memory | awk 'NR=!/Un/ && NR=!/Me/'| awk '/Speed/{ print $2,$3 }' | uniq)
        manufacturer=$(dmidecode -t memory | awk 'NR=!/Empty/' | awk '/Manufacturer/{ print $2 }' | awk 'NR == 1')
        echo $numberOfDevice x $size  $formfactor-$speed $manufacturer ;;
        # get Hard Disk information
     -d) 
        checkOptions 
        parametrOfDisk="$2"
        lshw -class disk -class storage -short | grep -s /dev/$parametrOfDisk | awk '{print $4,$5,$6 }' ;;
        # Print help message
    -h) 
        echo "Usage: sys_info.sh -spfmdh
    
        -s                Get System Name
        -p                Get CPU information
        -f                Get CPU frequency
        -m                Get Memory information
        -d <name>         Get Hard Disk information
        -h                Print this message" ;;
     *)
         echo "$1 is not an option" ;;
    esac
  shift
done

