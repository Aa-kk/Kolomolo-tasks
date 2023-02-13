# AWS-API-GATEWAY-TASK
 This folder contains files which are the solution to the AWS-API-GATEWAY task. I deployed the whole infrastructure using terraform. the terraform script can be found in the terraform folder.

 When you apply the infrastructure.tf file, it creates the dynamodb table, api and methods, necessary permissions/policies for the services to interact with each other and other resources needed for the infrastructure to work and then outputs the api url to the console

## How to invoke api
 The api has two methods, POST and GET. To invoke the api you can make use of curl from the terminal or any other tool of your choice like postman or insommia

### POST method
To use the POST method, you can do:  
`curl -X POST <API URL> -d '<BODY>'`     

The `API URL` is the url address for the API, for my already deployed solution it is `https://7lxgpzc6d6.execute-api.eu-central-1.amazonaws.com/dev`

The `BODY` has to be in this format`{"firstname":"<name>", "age":<number>}`  

#### Sample invocation 
Here's a sample of an invocation   
`curl -X POST https://7lxgpzc6d6.execute-api.eu-central-1.amazonaws.com/dev -d '{"firstname":"Fred", "age":28}'`   
Which would return a success message including string of characters which represent the user_id which in this example scenario is `5a6ed560-9112-4759-b977-3d2f52fa5abf`  


### GET Method
To use the GET method you can do:  
`curl -X GET <API URL>/<user_id>`   

Configured the method to accept a path which represents the user_id of the person you want to query.   

#### Sample invocation
`curl -X GET https://7lxgpzc6d6.execute-api.eu-central-1.amazonaws.com/dev/5a6ed560-9112-4759-b977-3d2f52fa5abf` 

GET method returns an error if an invalid user_id is queried.
