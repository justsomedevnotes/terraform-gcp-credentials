# Introduction
This post covers various methods to configure terraform with Google Cloud Platform credentials.  It assumes the terraform project structure of provider.tf, variables.tf, terraform.tfvars, etc.  Terraform provider.tf, variables.tf, and instance.tf files are   provided in the repository.  The only file needed is the terraform.tfvars file which examples are given below on how to create.  
    
## Prerequisits
A Vagrantfile is provided in the http://github.com/justsomedevnotes/terraform-gcp-credentials repository with required binaries.  
- Google Cloud Platform account
- gcloud command line
- terraform

## Describing the Approaches
There are two approaches that I know of to give your terraform configurations permission to access your GCP account.  The first is using GCP service accounts.  The second is using the gcloud default login credentials.  The first involves creating a service account key, downloading it, and giving it to terraform (demonstrated in the first section below).  The second is logging in using the gcloud command line and not providing any credentials to terraform configuration allowing it to default to your gcloud credentials (demonstrated in the second section below).

## Using GCP Service Accounts
There are two ways to set the service account key in the terraform configuration; 1) referencing the json file, 2) copying the actual content in the terraform configuration.  Both ways require a key, so lets go ahead and get the key.  

In the Google Cloud console select the below (make sure to select adequate permissions such as project --> owner)  
```console
  API & Services --> Credentials --> Create Credentials --> Service Account Key --> New Service Account 
   ```
   Save this key in a location that your shell and terraform will have access.  

### Referencing the JSON
In your terraform.tfvars file, just add a reference to the JSON file in the service account key variable entry.  

terraform.tfvars  
 
```console
 project = "your project"
 region = "us-central1"# or whatever region you want
 zone = "us-central1-a" # or whatever zone you want 
service_account_key = "my_service_account_key.json" # or whatever your file is named 
```

### Referencing the actual Service Account Key Value
Rather than referencing the JSON file, the actual key value can be inserted directly into the terraform configuration files.  The below approach inserts the value into the tfvars file and is referenced by the provider.tf file.  
```console
project = "your project"
 region = "us-central1"# or whatever region you want
 zone = "us-central1-a" # or whatever zone you want 
sservice_account_key = <<SERVICE_ACCOUNT_KEY
# insert the key value here
SERVICE_ACCOUNT_KEY
```
Once the key value or the json is set, give the Testing the Credentials section a try.  

## Using Default gcloud Credentials
The second approach is to not provide any credentials to the terraform configuration files.  Terraform will look for the gcloud configuration and use those credentials if found.  This would probably be more of a testing some development type use-case.  

```console
gcloud auth application-default login 
```
It should prompt you for a verification code.  Just follow the link to retrieve the verification code and update the local gcloud credentials.  Once the gcloud credentials are set, terraform can execute using the default credentials and the provider.tf credentials entry can be removed or commented out.  Give the Testing the Credentials section a try.  

## Testing the Credentials
Using the instance.tf file provided in the repository execute the below commands.  
Initialize terraform...  
```console
terraform init
```
create the plan...  
```console
terraform plan -out=plan
```
apply the plan...  
```console
terraform apply plan
```

If everything executes successfully you will have a new compute instance created.  Congratulations!  Don't forget to destroy when you are finished.  
```console
terraform destroy
```
