echo 'Setting up dashboard'
kubectl apply -f kubernetes/cluster/dashboard-config.yml
echo 'Creating service account'
kubectl create serviceaccount dashboard -n default
kubectl create clusterrolebinding dashboard-admin -n default  --clusterrole=cluster-admin  --serviceaccount=default:dashboard
echo 'Dashboard: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login'
echo 'Getting authentication token'
kubectl get secret $(kubectl get serviceaccount dashboard -o jsonpath="{.secrets[0].name}") -o jsonpath="{.data.token}" | base64 --decode