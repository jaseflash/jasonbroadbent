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

NAMESPACE     NAME                   DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR              AGE
kube-system   cilium                 2         2         2       2            2           kubernetes.io/os=linux     69m
kube-system   cilium-envoy           2         2         2       2            2           kubernetes.io/os=linux     69m
kube-system   ebs-csi-node           2         2         2       2            2           kubernetes.io/os=linux     79m
kube-system   ebs-csi-node-windows   0         0         0       0            0           kubernetes.io/os=windows   79m

kubectl -n kube-system exec ds/cilium -- cilium status

Defaulted container "cilium-agent" out of: cilium-agent, config (init), mount-cgroup (init), apply-sysctl-overwrites (init), mount-bpf-fs (init), clean-cilium-state (init), install-cni-binaries (init)
KVStore:                                     Disabled   
Kubernetes:                                  Ok         1.32 (v1.32.9-eks-113cf36) [linux/amd64]
Kubernetes APIs:                             ["EndpointSliceOrEndpoint", "cilium/v2::CiliumClusterwideNetworkPolicy", "cilium/v2::CiliumEndpoint", "cilium/v2::CiliumNetworkPolicy", "cilium/v2::CiliumNode", "cilium/v2alpha1::CiliumCIDRGroup", "core/v1::Namespace", "core/v1::Pods", "core/v1::Service", "networking.k8s.io/v1::NetworkPolicy"]
KubeProxyReplacement:                        True   [enX0   10.0.3.76 fe80::49b:66ff:fed2:b509 (Direct Routing), enX1   10.0.3.149 fe80::4b4:f2ff:fe2d:8009, enX2   10.0.3.144 fe80::41f:fff:fe7a:3f07]
Host firewall:                               Disabled
SRv6:                                        Disabled
CNI Chaining:                                none
CNI Config file:                             successfully wrote CNI configuration file to /host/etc/cni/net.d/05-cilium.conflist
Cilium:                                      Ok   1.17.4 (v1.17.4-55aecc0f)
NodeMonitor:                                 Listening for events on 15 CPUs with 64x4096 of shared memory
Cilium health daemon:                        Ok   
IPAM:                                        IPv4: 5/13 allocated, 
IPv4 BIG TCP:                                Disabled
IPv6 BIG TCP:                                Disabled
BandwidthManager:                            Disabled
Routing:                                     Network: Native   Host: Legacy
Attach Mode:                                 Legacy TC
Device Mode:                                 veth
Masquerading:                                IPTables [IPv4: Enabled, IPv6: Disabled]
Controller Status:                           37/37 healthy
Proxy Status:                                OK, ip 10.0.3.232, 0 redirects active on ports 10000-20000, Envoy: external
Global Identity Range:                       min 256, max 65535
Hubble:                                      Ok              Current/Max Flows: 4095/4095 (100.00%), Flows/s: 6.46   Metrics: Disabled
Encryption:                                  Disabled        
Cluster health:                              1/2 reachable   (2025-10-20T11:17:46Z)
Name                                         IP              Node   Endpoints


Cilium Connectivity Test (Optional)
The Cilium connectivity test deploys a series of services and deployments, and CiliumNetworkPolicy will use various connectivity paths to connect. Connectivity paths include with and without service load-balancing and various network policy combinations



```

```

Also log in to the AWS console and check cluster to see all resources are now available and ready for services :)

GOOD JOB ALL 😁😁😁😁😁👌
```



