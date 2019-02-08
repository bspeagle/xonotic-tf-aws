# xonotic-tf-aws

Full install and config of Xonotic game server using Terraform and AWS.

- Files/server.cfg: config file used by server to load up game configuration. Change whatever you want in here before running Terraform and uploading to S3.

- Files/user_data.tpl: user data file for EC2 instance. Installs  Xonotic, configures server and imports server.cfg from S3.