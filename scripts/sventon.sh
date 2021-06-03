#!/bin/bash
command=$1
wh=$2
index=$(sed -r 's/\+//g' <<< $wh)
svn $command $index
