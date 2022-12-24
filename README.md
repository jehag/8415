# LOG8415_Inv
To run the code, you need to install awscli first. This can be done throught this link:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
Once this is done, you need to install terraform:
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
The next step is to setup the aws credentials of your account:
https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/setup-credentials.html
After doing all of this, the last step is to run the main.tf file. To do so, enter these commands in a command line at the same location as the main.tf file:
terraform init
terraform apply
Then enter yes in the terminal to approve the changes to be made.
Your cluster should be deployed and ready to use.
To use the proxy, head into the proxy instance and locate the proxy.py file. Run the following commands there:
sudo su
sourcebase/bin/activate
python proxy.py
