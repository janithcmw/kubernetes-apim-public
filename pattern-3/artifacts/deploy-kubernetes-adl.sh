#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

#create namespace
kubectl create namespace wso2

# set namespace
kubectl config set-context $(kubectl config current-context) --namespace=wso2

# create ServiceAccount
kubectl create -f service-account/apim-service-account.yaml

#nfs for persistence volume
helm repo add wso2 https://helm.wso2.com
helm install wso2-nfs-server-provisioner wso2/nfs-server-provisioner --version 1.1.0

#uninstall nfs
helm uninstall wso2-nfs-server-provisioner

# volumes
#kubectl create  -f volumes/persistent-volumes.yamlx  #not needed.

#entrypoint-sh
kubectl create -f apim-gateway/wso2apim-conf-entrypoint.yaml


# databases
echo 'deploying databases ...'
kubectl create  -f rdbms/rdbms-persistent-volume-claim.yaml
kubectl create  -f rdbms/wso2apim-mysql-dbscripts.yaml
kubectl create  -f rdbms/rdbms-service.yaml

# Configuration deployment TODO need sleep?
kubectl create  -f rdbms/rdbms-deployment.yaml

# connector jar
kubectl create configmap db-connector-jar --from-file=mysql-connector-java-5.1.47.jar

# GW
# Configuration Maps
kubectl create  configmap apim-gw-manager-worker-bin --from-file=../confs/apim-gw-manager-worker/bin/
kubectl create  configmap apim-gw-manager-worker-conf --from-file=../confs/apim-gw-manager-worker/repository/conf/
kubectl create  configmap apim-gw-manager-worker-identity --from-file=../confs/apim-gw-manager-worker/repository/conf/identity/
kubectl create  configmap apim-gw-manager-worker-axis2 --from-file=../confs/apim-gw-manager-worker/repository/conf/axis2/
kubectl create  configmap apim-gw-manager-worker-datasources --from-file=../confs/apim-gw-manager-worker/repository/conf/datasources/
kubectl create  configmap apim-gw-manager-worker-tomcat --from-file=../confs/apim-gw-manager-worker/repository/conf/tomcat/

# Configuration Services
kubectl create  -f apim-gateway/wso2apim-sv-service.yaml
kubectl create  -f apim-gateway/wso2apim-pt-service.yaml
kubectl create  -f apim-gateway/wso2apim-manager-worker-service.yaml

# Configuration PVC
#kubectl create  -f apim-gateway/wso2apim-mgt-volume-claim.yaml -- not needed
kubectl create  -f apim-gateway/wso2apim-mgt-synapse-storage-claim.yaml
kubectl create  -f apim-gateway/wso2apim-mgt-log-storage-claim.yaml

# Configuration deployment TODO need sleep?
kubectl create  -f apim-gateway/wso2apim-manager-worker-deployment.yaml
kubectl create  -f apim-gateway/log-monitoring-pod.yaml

#TM
# Configuration Maps
kubectl create  configmap apim-tm-stateful-bin --from-file=../confs/apim-tm-stateful/bin/
kubectl create  configmap apim-tm-stateful-conf --from-file=../confs/apim-tm-stateful/repository/conf/
kubectl create  configmap apim-tm-stateful-identity --from-file=../confs/apim-tm-stateful/repository/conf/identity/
kubectl create  configmap apim-tm-stateful-identity-datasources --from-file=../confs/apim-gw-manager-worker/repository/conf/datasources/


# Configuration Services
kubectl create  -f apim-tm-stateful-adl/wso2apim-tm-headless-service.yaml
kubectl create  -f apim-tm-stateful-adl/wso2apim-tm-service.yaml

# Configuration volume claim
#kubectl create  -f apim-tm-stateful-adl/wso2apim-tm-stateful-volume-claim.yaml  --not needed
kubectl create  -f apim-tm-stateful-adl/wso2apim-tm-stateful-executionplan-volume-claim.yaml

# Configuration deployment TODO need sleep?
kubectl create  -f apim-tm-stateful-adl/wso2apim-tm-deployment.yaml


#Store-Pub
# Configuration Maps
kubectl create  configmap apim-store-publisher-bin --from-file=../confs/apim-store-pub/bin/
kubectl create  configmap apim-store-publisher-conf --from-file=../confs/apim-store-pub/repository/conf/
kubectl create  configmap apim-store-publisher-identity --from-file=../confs/apim-store-pub/repository/conf/identity/
kubectl create  configmap apim-store-publisher-axis2 --from-file=../confs/apim-store-pub/repository/conf/axis2/
kubectl create  configmap apim-store-publisher-datasources --from-file=../confs/apim-store-pub/repository/conf/datasources/
kubectl create  configmap apim-store-publisher-tomcat --from-file=../confs/apim-store-pub/repository/conf/tomcat/

# Configuration Services
kubectl create  -f apim-store-pub-adl/wso2apim-store-publisher-service.yaml

# Configuration volume claim
#kubectl create  -f apim-store-pub-adl/wso2apim-store-publisher-volume-claim.yaml --not needed

# Configuration deployment TODO need sleep?
kubectl create  -f apim-store-pub-adl/wso2apim-store-publisher-deployment.yaml

#IS-KM
# Configuration Maps
kubectl create  configmap apim-km-bin --from-file=../confs/apim-km/bin/
kubectl create  configmap apim-km-conf --from-file=../confs/apim-km/repository/conf/
kubectl create  configmap apim-km-identity --from-file=../confs/apim-km/repository/conf/identity/
kubectl create  configmap apim-km-axis2 --from-file=../confs/apim-km/repository/conf/axis2/
kubectl create  configmap apim-km-datasources --from-file=../confs/apim-km/repository/conf/datasources/
kubectl create  configmap apim-km-tomcat --from-file=../confs/apim-km/repository/conf/tomcat/

# Configuration Services
kubectl create  -f apim-km/wso2apim-km-service.yaml
kubectl create  -f apim-km/wso2apim-key-manager-service.yaml

# Configuration deployment TODO need sleep?
kubectl create  -f apim-km/wso2apim-km-deployment.yaml

#Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.6.4/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f ingresses/wso2apim-ingress.yaml
kubectl apply -f ingresses/wso2apim-tm-ingress.yaml

#backend yaml
kubectl create -f backend-mi/backend-mi-pod.yaml

#kubectl create  configmap apim-publisher-bin --from-file=../confs/apim-publisher/bin/
#kubectl create  configmap apim-publisher-conf --from-file=../confs/apim-publisher/repository/conf/
#kubectl create  configmap apim-publisher-identity --from-file=../confs/apim-publisher/repository/conf/identity/
#kubectl create  configmap apim-publisher-axis2 --from-file=../confs/apim-publisher/repository/conf/axis2/
#kubectl create  configmap apim-publisher-datasources --from-file=../confs/apim-publisher/repository/conf/datasources/
#kubectl create  configmap apim-publisher-tomcat --from-file=../confs/apim-publisher/repository/conf/tomcat/

#kubectl create  configmap apim-store-bin --from-file=../confs/apim-store/bin/
#kubectl create  configmap apim-store-conf --from-file=../confs/apim-store/repository/conf/
#kubectl create  configmap apim-store-identity --from-file=../confs/apim-store/repository/conf/identity/
#kubectl create  configmap apim-store-axis2 --from-file=../confs/apim-store/repository/conf/axis2/
#kubectl create  configmap apim-store-datasources --from-file=../confs/apim-store/repository/conf/datasources/
#kubectl create  configmap apim-store-tomcat --from-file=../confs/apim-store/repository/conf/tomcat/

#kubectl create  configmap apim-tm1-bin --from-file=../confs/apim-tm-1/bin/
#kubectl create  configmap apim-tm1-conf --from-file=../confs/apim-tm-1/repository/conf/
#kubectl create  configmap apim-tm1-identity --from-file=../confs/apim-tm-1/repository/conf/identity/
#
#kubectl create  configmap apim-tm2-bin --from-file=../confs/apim-tm-2/bin/
#kubectl create  configmap apim-tm2-conf --from-file=../confs/apim-tm-2/repository/conf/
#kubectl create  configmap apim-tm2-identity --from-file=../confs/apim-tm-2/repository/conf/identity/

echo 'deploying services and volume claims ...'
kubectl create  -f apim-analytics/wso2apim-analytics-service.yaml
kubectl create  -f apim-analytics/wso2apim-analytics-1-service.yaml
kubectl create  -f apim-analytics/wso2apim-analytics-2-service.yaml

kubectl create  -f apim-gateway/wso2apim-sv-service.yaml
kubectl create  -f apim-gateway/wso2apim-pt-service.yaml
kubectl create  -f apim-gateway/wso2apim-manager-worker-service.yaml

kubectl create  -f apim-km/wso2apim-km-service.yaml
kubectl create  -f apim-km/wso2apim-key-manager-service.yaml

kubectl create  -f apim-publisher/wso2apim-publisher-local-service.yaml
kubectl create  -f apim-publisher/wso2apim-publisher-service.yaml

kubectl create  -f apim-store/wso2apim-store-local-service.yaml
kubectl create  -f apim-store/wso2apim-store-service.yaml


kubectl create  -f apim-publisher/wso2apim-publisher-volume-claim.yaml
kubectl create  -f apim-store/wso2apim-store-volume-claim.yaml
kubectl create  -f apim-gateway/wso2apim-mgt-volume-claim.yaml
kubectl create  -f apim-tm/wso2apim-tm-1-volume-claim.yaml

sleep 30s
# analytics
echo 'deploying apim analytics ...'
kubectl create  -f apim-analytics/wso2apim-analytics-1-deployment.yaml
sleep 10s
kubectl create  -f apim-analytics/wso2apim-analytics-2-deployment.yaml

# apim
sleep 30s
echo 'deploying apim traffic manager ...'
kubectl create  -f apim-tm/wso2apim-tm-1-deployment.yaml
kubectl create  -f apim-tm/wso2apim-tm-2-deployment.yaml

echo 'deploying apim key manager...'
kubectl create  -f apim-km/wso2apim-km-deployment.yaml

sleep 1m
echo 'deploying apim publisher ...'
kubectl create  -f apim-publisher/wso2apim-publisher-deployment.yaml

sleep 30s
echo 'deploying apim store...'
kubectl create  -f apim-store/wso2apim-store-deployment.yaml

sleep 30s
echo 'deploying apim manager-worker ...'
kubectl create  -f apim-gateway/wso2apim-manager-worker-deployment.yaml

echo 'deploying wso2apim and wso2apim-analytics ingress resources ...'
kubectl create -f ingresses/nginx-default-http-backend.yaml
kubectl create -f ingresses/nginx-ingress-controller.yaml
kubectl create -f ingresses/wso2apim-analytics-ingress.yaml
kubectl create -f ingresses/wso2apim-ingress.yaml