# terraform_aks_registry_container_app
Deploy an application k8s with terraform on Azure AKS, with Azure registry 

Commands:

      terraform init
      
      terraform plan
      
      terraform apply
      
      docker deploy -t fernandosantini/rotten-potatoes:v1
      
      az login 
      
      az aks get-credentials --resource-group labs-aks --name aks
      
      az acr login --name studieslabsacr
      
      kubectl apply -f deploiment.yaml
