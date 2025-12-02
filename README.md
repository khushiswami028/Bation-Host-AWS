#Bation-Host <br>
In this terraform code there is a secure network connectivity with custom vpc.
2 subnets , 1st for public connection ,2nd is private subnet diabled public ip.
then created route tables ,public route table assosiate with public subnets and also for internetgateway.
2nd route table assosiate with private subnet and for internet connectivity we need to add nat-gateway.
then launch 2 instance 1st in public subnet and another one in private subnet.
In public instance we need to copy the private key of another instance so we can acsses 2nd instance via key and with private ip.
so that's how we can create a secure network.
Bation host is mostly use for security purpose of the databases. 
