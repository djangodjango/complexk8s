# Build images
docker build -t epsyl0n/multi-client:latest -t epsyl0n/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t epsyl0n/multi-server:latest -t epsyl0n/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t epsyl0n/multi-worker:latest -t epsyl0n/multi-worker:$SHA -f ./worker/Dockerfile ./worker

#push images to docker hub
docker push epsyl0n/multi-client:latest
docker push epsyl0n/multi-server:latest
docker push epsyl0n/multi-worker:latest

docker push epsyl0n/multi-client:$SHA
docker push epsyl0n/multi-server:$SHA
docker push epsyl0n/multi-worker:$SHA

# apply kubernetes config
kubectl apply -f k8s/database-persistent-volume-claim.yaml
kubectl apply -f k8s/postgres-deployment.yaml
kubectl apply -f k8s/postgres-cluster-ip-service.yaml
kubectl apply -f k8s
kubectl set image deployments/client-deployment client=epsyl0n/multi-client:$SHA
kubectl set image deployments/server-deployment server=epsyl0n/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=epsyl0n/multi-worker:$SHA