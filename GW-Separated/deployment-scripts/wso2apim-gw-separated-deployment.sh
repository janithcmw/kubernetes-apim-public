#create namespace
kubectl create namespace wso2

# set namespace
kubectl config set-context $(kubectl config current-context) --namespace=wso2

# create ServiceAccount
kubectl create -f kubernetes-basics/svcaccount.yaml

# databases
echo 'deploying databases ...'
kubectl create -f kubernetes-rdbms/MySQL/wso2apim-gw-separated-mysql-dbscripts-conf.yaml
kubectl create -f kubernetes-rdbms/MySQL/wso2apim-gw-separated-mysql-service.yaml
kubectl create -f kubernetes-rdbms/MySQL/wso2apim-gw-separated-mysql-deployment.yaml

# APIM-GW-Separated-Netshoot
#PVCs
kubectl create -f kubernetes-volume/Storage/wso2apim-netstat-captured-data-storage-pv.yaml
kubectl create -f kubernetes-volume/Storage/wso2apim-netstat-captured-data-storage-claim.yaml

# APIM-GW-Separated-PSTMKM
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-separated-pstmkm-log-storage-pv.yaml
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-sepatated-pstmkm-log-storage-claim.yaml
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-separated-pstmkm-conf-entrypoint.yaml
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-separated-pstmkm-bin.yaml
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-separated-pstmkm-deployment-conf.yaml
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-separated-pstmkm-service.yaml
kubectl create -f kubernetes-apim/PSTMKM/wso2apim-gw-separated-pstmkm-deployment.yaml

# APIM-GW-Separated-GW
kubectl create -f kubernetes-apim/GW/wso2apim-gw-separated-gw-log-storage-pv.yaml
kubectl create -f kubernetes-apim/GW/wso2apim-gw-sepatated-gw-log-storage-claim.yaml
kubectl create -f kubernetes-apim/GW/wso2apim-gw-separated-gw-conf-entrypoint.yaml
kubectl create -f kubernetes-apim/GW/wso2apim-gw-separated-gw-bin.yaml
kubectl create -f kubernetes-apim/GW/wso2apim-gw-separated-gw-deployment-conf.yaml
kubectl create -f kubernetes-apim/GW/wso2apim-gw-separated-gw-service.yaml
kubectl create -f kubernetes-apim/GW/wso2apim-gw-separated-gw-deployment.yaml

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

