#!/bin/bash

s3cmd mb s3://ejbca-p12
s3cmd put /opt/ejbca_ce_6_15_2_1/p12/superadmin.p12 s3://ejbca-p12/superadmin.p12 
