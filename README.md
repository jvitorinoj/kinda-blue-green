# Blue green mock


## Blue-Green Deployment
A blue-green deployment is a software release management strategy that aims to minimize downtime and risk during the deployment process. In a blue-green deployment, two identical environments, referred to as the "blue" and "green" environments, are set up.

The blue environment represents the currently live and stable version of the application, while the green environment is used for deploying and testing the new version. The deployment process involves the following steps:

1. Initially, all user traffic is directed to the blue environment.
2. The new version of the application is deployed to the green environment.
3. The green environment is thoroughly tested to ensure that the new version is functioning correctly.
4. Once the green environment is deemed stable, the traffic is switched from the blue environment to the green environment.
5. The blue environment becomes the new staging environment for future deployments.
6. If any issues are discovered in the green environment, the traffic can be quickly switched back to the blue environment to minimize downtime.

For the sake of simplicity and due to constrains (a.k.a💲and time), this project will not install 2 cluster, each one acting as environment (blue and green) and with a service like Azure Frontend to deal with the traffic between the cluster, instead it´s going to be:

- 1 single cluster defined on aks.tf
- 2 deployments for the same application `myapp`, 1 simulating the blue environment and other the green
- 1 service that will handle the traffic to blue or green based on selector
- Deploy of the jenkins helm chart, so the blue/green change can be done by a pipeline

The names blue and green here are for didatic purpose, after the green became the live environment, green become blue and blue become green.

## Prerequisites
Before getting started, make sure you have the following prerequisites:

- Terraform installed
- Azure CLI installed
- Azure subscription
- environment variable TF_VAR_subscription_id set or added to the variables.tf

## Installation


Adjust the variables in the variables.tf file and run the commands bellow

`terraform init`
`terraform plan && terraform apply`

## Usage

As soon the cluster finished to be created, it will public ip for jenkins service and and other public ip for the bluegreen service, at first - as should be - myapp is going to be the blue one -nginx container running on version 1.27. You can check this by running the command below


`curl -s `terraform output -raw bluegreen_service_ip`/version | grep -oP '(?<=nginx/)[0-9.]+'`

You can get the ip  from `terraform output bluegreen_service_ip` and paste it in your browese to check the nginx running


To switch to the green depployment, just run the command below

`kubectl patch service bluegreen-svc -p '{"spec": {"selector": {"app": "myapp", "version": "green"}}}'`


Run the command to check the version again and now you will see the version 1.14

`curl -s `terraform output -raw bluegreen_service_ip`/version | grep -oP '(?<=nginx/)[0-9.]+'`

Note the cluster has the two deployments running at the same time, one was not scaled down and other scaled up as in the rollout deployment, what achieve the caracteristics of the blue green deployment.

NOTE: The switch between the blue green should be done in a pipeline in jenkins, but the default jenkins agent does not have kubectl.


## Todo
- [ ] Create jenkins agent with kubectl
- [ ] Create a application that shows a custom info - or color - to better showcase the change between blue green
- [ ] jenkins pipeline 
- [ ] remove application gateway (It was the original ideal to switch from  blue to green based on weight but it´s not being used)

