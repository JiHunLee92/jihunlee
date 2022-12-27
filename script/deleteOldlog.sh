#!/bin/bash

path="/land/service/landfx-web.renewal/var/"
expire_days=30

echo "Start deleteExpireFile.sh"
find ${path} \( -name "*.log"\) -type f -mtime +${expire_days} -exec rm -f {} \;
echo "End deleteOLDLogFiles.sh
