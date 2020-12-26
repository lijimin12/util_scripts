#!/bin/sh

#echo $#argv
#echo $0
#echo $1
#echo $2
if [ $# -eq 0 ] ; then
    echo "svnchange log_length/since_revision [filename]"
    echo "Note: log_length <= 1000"
    echo "exmaples:"
    echo "  svnchange 20 ."
    echo "  svnchange 10 host/g5_api/src/g5_api_alloc.c |vim -"
    exit 0
fi

arg1=$1
first_rev=0
# in past 20 logs search the specified revision
log_length=20

if [ ${arg1:0:1} = 'r' ] ; then
    first_rev=${arg1:1}

# when $1 > 1000, it means revsion number rather than log length
elif [ $arg1 -ge 1000 ] ; then
    first_rev=$arg1
else
    log_length=$arg1
fi

#echo $log_length
#echo $first_rev
#exit 0

re='^[0-9]+$'
if ! [[ $log_length =~ $re ]] ; then
   echo "error: Not a number $log_length" >&2; exit 1
fi
if ! [[ $first_rev =~ $re ]] ; then
   echo "error: Not a number $first_rev" >&2; exit 1
fi

filename=$2
#echo "_${filename}_"

# grep pattern "^r[0-9]*" would match "review..."
rev_list=$(svn log $filename -l $log_length | /bin/grep "^r[0-9]" | cut -d '|' -f1 | cut -d 'r' -f2 )

#echo $rev_list
#exit 0

#rev_list=(73545 72696)
#rev_list="73545 72696"
for rev in $rev_list ; do
    #echo $rev
    # changes introduced in $first_rev not showed
    if [ $rev -eq $first_rev ] ; then
        break
    fi

    svn diff $filename -c $rev
done
