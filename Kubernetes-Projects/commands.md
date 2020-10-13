minikube ip

minikube dashboard

kubectl get deployments

kubectl get replicasets

kubectl get pods

kubectl describe pod webserver-74d8bd488f-dwbzz

kubectl get pods -L k8s-app,label2

kubectl get pods -l k8s-app=webserver

kubectl delete deployments webserver

kubectl create -f webserver.yaml

kubectl get replicasets

kubectl create -f webserver-svc.yaml

kubectl expose deployment webserver --name=web-service --type=NodePort

kubectl describe service web-service

minikube service web-service

kubectl create -f .\azure-vote.yaml

az aks get-credentials --resource-group myResourceGroup --name myAKSCluster


