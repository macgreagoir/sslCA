#!/bin/bash
# Reset the CA back to scratch
#
# THIS WILL DELETE ALL YOUR CERTS!

find ./ -name "*pem" -exec rm {} \;
rm index.txt*
rm serial*
