<img width="1027" height="528" alt="image" src="https://github.com/user-attachments/assets/f0fff3d9-38f4-4d84-a834-8f1ffe3dbe92" />

**Disclaimer: This setup is for POC purposes and not fit for production**

#   Terraform & kubernetes install with Cillium CNI for Node connectivity

#    install terraform, kubectl, aws cli, helm

# deploy kubernetes into aws with kubernetes

```
terraform init
terraform plan
terraform apply

aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

watch kubectl get nodes
```


## Install CNI ---->  I am using Cillium ----> this will bring nodes up and working once CNI has been installed

### Setup of Cillium CNI

```
helm repo add cilium https://helm.cilium.io/

helm install cilium cilium/cilium --version 1.17.4 \
  --namespace kube-system \
  --set eni.enabled=true \
  --set ipam.mode=eni \
  --set egressMasqueradeInterfaces=eth+ \
  --set routingMode=native\
  --set kubeProxyReplacement=true\
  --set k8sServiceHost=***********************.eu-west-*.eks.amazonaws.com\ # ------> kubectl cluster-info ---> shows K8 API
  --set k8sServicePort=443

 eksctl create nodegroup -f nodegroup.yaml

kubectl get nodes # all nodes will be ready now
kubectl get pods # all pods will be ready now including cilium pods

kubectl get ds -A

<img width="2686" height="218" alt="image" src="https://github.com/user-attachments/assets/2ec1517c-bf83-4dcc-b768-60a812b6a3c6" />



```

```

Also log in to the AWS console and check cluster to see all resources are now available and ready for services :)

GOOD JOB ALL 😁😁😁😁😁👌
```



