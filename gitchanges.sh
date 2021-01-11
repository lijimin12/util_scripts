#!/bin/sh
# gitchanges
# show changes for a certain file

set -e

#echo $#argv
#echo $0
#echo $1
#echo $2
if [ $# -eq 0 ] ; then
    echo "Usage:"
    echo "gitchanges [commit or number changes] filename"
    echo "It shows changes since @commit, not including, or last @number of changes."
    echo "The max number of changes to show is fixed as 100."
    echo "By default, it would show last 5 changes."
    echo "exmaples:"
    echo "  gitchanges <revision> host/g5_api/src/g5_api_alloc.c |vim -"
    echo "  gitchanges host/g5_api/src/g5_api_alloc.c | vim -" 
    echo "  gitchanges 10 host/g5_api/src/g5_api_alloc.c |vim -"
    exit 0
fi

if [ $# -eq 1 ] ; then
filename=$1
# default log length
log_len=5
first_rev="ffffff"
fi

if [ $# -eq 2 ] ; then
# length regular expression
len_re='^[0-9a-z]+$'
# revision regular expression
rev_re='^[0-9a-z]+$'

if [[ $1 =~ $len_re ]] ; then
    log_len=$1
    first_rev="ffffff"
elif [[ $1 =~ $rev_re ]] ; then
    first_rev=$1
    log_len=10000
else
    echo "error: $1 is neither a valid revision number nor a length number" >&2; exit 1
fi

filename=$2
#echo "_${filename}_"
fi

rev_list=$(git log --oneline $filename | /bin/grep "^[0-9a-ze]" | cut -d ' ' -f1)
#echo $rev_list

count=0
max_count=100
for rev in $rev_list ; do
    #echo $rev
    # changes introduced in $first_rev not showed
    if [ $rev == $first_rev ] ; then
        break
    fi
    if [ $count -eq $log_len ] ; then
        break
    fi
    if [ $count -eq $max_count ] ; then
        echo "too many revisions, exit"
        break
    fi

    if [ $count -ne 0 ] ; then
        echo -e "\n------------------------------------ ~$count\n"
    fi
    ((count=count+1))

    #svn diff $filename -c $rev
    git show $rev $filename
#echo "diff" ${rev} $filename "#" $count
#git diff ${rev}~ ${rev} $filename
done

