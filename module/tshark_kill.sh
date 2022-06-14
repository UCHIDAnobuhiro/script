#!/bin/bash
sudo kill $(ps -e | grep tshark | awk '{print $1}')
