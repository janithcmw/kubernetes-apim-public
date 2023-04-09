#create namespace
kubectl create namespace wso2

# set namespace
kubectl config set-context $(kubectl config current-context) --namespace=wso2

# create ServiceAccount
kubectl create -f kubernetes-basics/svcaccount.yaml

# databases
echo 'deploying databases ...'
kubectl create -f kubernetes-apim-mysql/wso2apim-mysql-conf.yaml
kubectl create -f kubernetes-apim-mysql/wso2apim-mysql-service.yaml
kubectl create -f kubernetes-apim-mysql/wso2apim-mysql-deployment.yaml

# APIM-AllinOne
#PVCs
kubectl create -f kubernetes-apim/wso2apim-netstat-captured-data-storage-claim.yaml
kubectl create -f kubernetes-apim/wso2apim-log-storage-claim.yaml

#configMaps
kubectl create -f kubernetes-apim/wso2apim-conf.yaml
kubectl create -f kubernetes-apim/wso2apim-conf-entrypoint.yaml

#services
kubectl create -f kubernetes-apim/wso2apim-service.yaml
kubectl create -f kubernetes-apim/wso2apim-gateway-service.yaml

#deployment
kubectl create -f kubernetes-apim/wso2apim-deployment.yaml

#Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml
kubectl create -f kubernetes-apim-ingresses/wso2apim-ingress.yaml