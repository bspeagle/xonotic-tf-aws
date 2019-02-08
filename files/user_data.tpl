#! /bin/bash

echo 'Change directory to home/ec2-user'
cd /home/ec2-user

echo 'Download game!'
curl https://dl.xonotic.org/xonotic-0.8.2.zip --output xonotic.zip

echo 'Unzip game contents'
unzip xonotic.zip
rm xonotic.zip

echo 'Copy server script to top level directory'
cd Xonotic/server
cp server_linux.sh ../

echo 'Make directories for server config file and copy file from S3'
mkdir /home/ec2-user/.xonotic
mkdir /home/ec2-user/.xonotic/data
aws s3 cp s3://xonotic-filez/server.cfg /home/ec2-user/.xonotic/data

echo 'Change owner of data directory to ec2-user'
chown ec2-user /home/ec2-user/.xonotic

echo 'Send SMS that server is ready'
aws sns publish --region us-east-1 --phone-number +1<your phone number> --message "Xonotic game server ready!"

echo 'Start game server!'
cd ..
su ec2-user -c 'bash server_linux.sh'