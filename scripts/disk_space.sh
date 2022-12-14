#!/bin/bash

blk=$(df -hT | grep /$ | cut -d' ' -f1)
used=$(df -h --output=used ${blk} | sed -n 2p | xargs)
size=$(df -h --output=size ${blk} | sed -n 2p | xargs)
