#!/usr/bin/env bash
echo "Checking dependancies..."
cat Deps.txt | while read line
do
  if ! man "$line" > /dev/null 2>&1; then
    echo "    Missing dependancy ${line}"
  else
    echo "    Found dependancy ${line}"
  fi
done
echo "Checking Folder Structure..."
if [ ! -d "./Modules" ] ; then
  echo "    Missing folder \"Modules\", Creating now..."
  mkdir Modules
else
  echo "    Found folder \"Mondules\""
fi
if [ ! -d "./Temp" ]; then
  echo "    Missing folder \"Temp\", Creating now..."
  mkdir Temp
else
  echo "    Found folder \"Temp\""
fi
if [ ! -d "./Networks" ]; then
  echo "    Missing folder \"Networks\", Creating now..."
  mkdir Networks
else
  echo "    Found folder \"Networks\""
fi
if [ ! -d "./Devices" ]; then
  echo "    Missing folder \"Devices\", Creating now..."
  mkdir Devices
else
  echo "    Found folder \"Devices\""
fi
if [ ! -d "./Openings" ]; then
  echo "    Missing folder \"Openings\", Creating now..."
  mkdir Openings
else
  echo "    Found folder \"Openings\""
fi

