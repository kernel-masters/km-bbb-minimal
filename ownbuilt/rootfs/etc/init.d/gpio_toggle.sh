#!/bin/sh

GPIO=10  # Broche 10 du port "Expansion A"

cd /sys/class/gpio

echo ${GPIO} > export

cd gpio${GPIO}

echo out > direction

while true
do
	echo 1 > value
	sleep 1
	echo 0 > value
	sleep 1
done
