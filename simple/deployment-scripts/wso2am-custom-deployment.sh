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
kubectl create -f kubernetes-apim/wso2apim-conf.yaml
kubectl create -f kubernetes-apim/wso2apim-conf-entrypoint.yaml
kubectl create -f kubernetes-apim/wso2apim-service.yaml
kubectl create -f kubernetes-apim/wso2apim-deployment.yaml
