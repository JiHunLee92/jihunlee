#!/bin/bash

/usr/local/bin/aws s3 sync /land/service/sticpay-web.main/var/ s3://sticpay-admin-logs/web01 --storage-class DEEP_ARCHIVE
