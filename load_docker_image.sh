#!/bin/bash

for i in `ls ./images/*`
do
   docker load -i $i
done
