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
kubectl create -f kubernetes-apim/wso2apim-log-storage-pv.yaml
kubectl create -f kubernetes-apim/wso2apim-netstat-captured-data-storage-pv.yaml
kubectl create -f kubernetes-apim/wso2apim-netstat-captured-data-storage-claim.yaml
kubectl create -f kubernetes-apim/wso2apim-log-storage-claim.yaml

#configMaps
kubectl create -f kubernetes-apim/wso2apim-conf.yaml
kubectl create -f kubernetes-apim/wso2apim-bin.yaml
kubectl create -f kubernetes-apim/wso2apim-conf-entrypoint.yaml

#services
kubectl create -f kubernetes-apim/wso2apim-service.yaml
kubectl create -f kubernetes-apim/wso2apim-gateway-service.yaml

#deployment
kubectl create -f kubernetes-apim/wso2apim-deployment.yaml

#Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml
kubectl create -f kubernetes-apim-ingresses/wso2apim-ingress.yaml

##kubectl commands
##to exec to wso2apim
#kubectl exec -it <pod name> bash
##to exec to netshoot
#kubectl exec -it <pod name> bash -c netshoot
##then using the following command the tcp dumps can be captured.
#tcpdump -i any  -w test.pcap
##to get the tcp dump using docker cp
#kubectl cp wso2/wso2am-pattern-1-am-1-deployment-75975469f5-4nnxn:/root/netstat-data/test.pcap /home/janithw/data/test.pcap -c netshoot
##to view the logs as tail
#kubectl logs -f <pod name>

