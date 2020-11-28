#!/bin/bash

file='/var/log/testlog.log'
subject='Aunto'
receiver='rauleduardovigil@gmail.com'

echo "content" | mutt -a "$file" -s "$subject" -- $receiver 
