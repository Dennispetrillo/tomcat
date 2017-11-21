# Tomcat

## About Tomcat

The [Apache Tomcat®](http://tomcat.apache.org/) software is an open source implementation of the Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket technologies. The Java Servlet, JavaServer Pages, Java Expression Language and Java WebSocket specifications are developed under the Java Community Process.
## Goal

Use Chef to successfully install and configure tomcat on a RHEL7-based target system.

## Background

This cookbook is using the following software versions:
- Chef Develpment Kit version: 2.3.4
- Chef-client version: 13.4.19
- berks version: 6.3.1
- kitchen version: 1.17.0
- inspec version: 1.36.1
- Mongo 3.4 Community Edition

Cookbook developed locally and uploaded to chef-server

Bootstrapped to ec2 node using SSH

Node = AWS ec2 RHEL 7.4 64-bit instance

## setup (assuming chefdk and tools are on the workstation)

- Fork this repo to your cookbooks directory within your chef-repo directory
- Upload cookbook to chef server
- Create an ec2 instance
    - RHEL 7.4 64-bit
    - Create a .pem key when creating the instance if one not already created.  Option available when creating the instance         and needed for bootstrapping the node and accessing the node in local mode using the methods below.
    - Store the .pem in ~/.ssh/YourPemName.pem
- Bootstrap the node (here is one format that may be used at the command line of the local workstation)
  knife bootstrap IDPADDRESS --ssh-user ec2-user --sudo --identify-file ~/.ssh/YourPemFileName.pem -N NODENAME --run-list 'cookbook::recipe'
- The above should compile, converge and perform a chef client run
- Log in to the node remotely.  Here is one format that may be used at the command line of the local workstation
        ssh -i ~/.ssh/YourPemKeyFileName.pem ec2-user@IPADDRESS-OF-THE-NODE
- Enter curl http://localhost:8080 to determine if tomcat is running

## Kitchen Testing

Test kitchen is also incorporated in this workbook to support a "test first" approach.

Test/smoke/setup/setup/setup_test.rb _contains tests developed to support the resources defined in recipes/setup.rb

In order to use aws ec2 for the temporary environment used by kitchen, the cookbookName/.kitchen.yml file must be configured. 

In addition it's important to set up Access Key and Secret Access key for Kitchen stored in .aws in your home directory as those credentials will be used to create an ec2 instance by kitchen.  That can be created in the AWS interface for a user under Security Credentials.  More information around test kitchen can be viewed here https://learn.chef.io/tracks/local-development-and-testing#/

It's important to understand that test kitchen will create the instance for testing so you don't have to launch an aws instance manually - test kitchen will handle that for you.

'Kitchen test' will create an instance, run tests and destroy the instance at the end of the run.  But the other methods used by kitchen (create, converge, verify) will allow you to view your instance and confirm file locations, etc. for verification as the instance will persist until destroyed.

Here is an example for an ec2 configuration:

---
**driver**:
  **name:** ec2
  
  **aws_ssh_key_id:** YourKeyPair (do not inclulde the .pem)
  
  **region:** aws region, i.e., us-west-2, etc.
  
  **availability_zone:** a (you may see us-west-2a, us-west-2b, etc.  Here we just want the letter)
  
  **instance_type:** t2.micro (take a look at the instance type (step 2) when launching an instance to see the options)
  
  **image_id:** ami-9fa343e7 (the image id of the instance you'd like to launch.  You can get that from Step 1 on the launch                                process)
  
  **security_group_ids:** ['the security group you'd like applied to this instance']
  
  **retryable_tries:** 120

**provisioner:
  name:** chef_zero

**verifier:
  name:** inspec

**transport:
  ssh_key:** ~/.ssh/YourKeyPair.pem

**platforms:** <br>
    \- name: centos-7<br>
**suites:**<br>
    \- name: setup <br>
    run_list:<br>
        \- recipe[tomcat::setup]<br>
    verifier:<br>
        inspect_tests:<br>
         \- test/smoke/setup<br>
    attributes:<br>
    

