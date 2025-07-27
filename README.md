# PetClinic - DevOps Implementation

This project is based on the "Spring PetClinic Sample Application" repository. The idea here is to take the ready-to-use sample app, with the goal of making the following implementation changes/updates:



- Use Vagrant boxes(VMs) for the infrastructure; 
- Deploy three separate servers - One for the Web App, one for MySQL, and one for Nagios monitoring;
- Automate MYSQL installation, bind-address configuration and DB user creation using Puppet;
- Automate pre-requisites installation (Java 17, MySQL Server, Git, Maven) using Puppet; 
- Automate repo download, pom.xml configuration changes and app deployment using Puppet;
- Automate Nagios server deployment and configuration for monitoring application and DB endpoints.

### The sample application used for this project: [Spring PetClinic Sample Application](https://github.com/spring-petclinic/spring-framework-petclinic).
