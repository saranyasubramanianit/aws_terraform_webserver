## Description

This repo contains terraform code to provision AWS infrastructure with nginx webserver in Ubuntu Linux and ELB infront of EC2 instance.

### Prerequisties:

 In order to execute this code , We need below seetings available already,
  
   1. AWS credentials as the environment variable,

    ```
      export AWS_ACCESS_KEY_ID=(your access key)
      export AWS_SECRET_ACCESS_KEY_ID=(your secret access key)
     ```

   2. S3 bucket with name my-tfstatebucket to store the terraform state file.


 ### Running the automation:
    
    ```
     terraform init 
     terraform plan
    ```

     terrafrom plan - shows the changes it makes in AWS envrionment.

    ```
     terraform apply

     ```

  The output contains the elb_dns, subnet_id and vpc_id . 

  Open the browser and access the elb_dns url


  ### Note

    Autoscaling entries are commented out in main.tf . if need they can be applied after removing the comment.