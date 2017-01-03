#!/bin/bash +x
#################################
#   Arthur 2016.11.28
#################################
if [ -z "$1" ] || [ -z "$2" ]
  then echo; echo "Syntax: $0 <branch name> <repo path>"; echo;
	exit -1
fi

echo "========================================================"
echo "LAST MASTER CHANGES IN BRANCH $1 VERIFICATION"
echo "========================================================"

cd $2 || exit -1
git fetch || exit -1

CM=`git rev-parse remotes/origin/master`
echo "Master revision is $CM"

CB=`git rev-parse remotes/origin/$1`
echo "$1 revision is $CB"

BM=`git merge-base origin/$1 origin/master`
echo "Base revision of $1 is $BM"

if [ $CM == $BM ] 
  then echo "$CM is equel to base commit of $1"
	exit
fi

echo "WARNING: $CM is not equal to base commit of $1 - $BM"

LM=`git show -s --format=%ci ${BM}`

echo
echo "Last merge from master time is: $LM"
echo

CC=1
TT=${BM:0:7}
echo
echo "---------------------------------------------------------"
echo "Below is list of master commits for merge to your branch:"
echo "---------------------------------------------------------"

for line in `git log --oneline remotes/origin/master | head -200 | cut -d' ' -f1`
do
	 if [ $line == $TT ]
    then break
	 fi
	 ((CC++))
done

git log --oneline remotes/origin/master | head -${CC}