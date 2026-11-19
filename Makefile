CLUSTER_NAME = order-cluster

create-cluster:
	kind create cluster --config kind-config.yaml --name $(CLUSTER_NAME)

delete-cluster:
	kind delete cluster --name $(CLUSTER_NAME)

build-image:
	docker build -t order-service:v1 ./apps/order-service/
	kind load docker-image order-service:v1 --name $(CLUSTER_NAME)

deploy-base:
	kubectl apply -f namespaces.yaml
	kubectl apply -f apps/postgres/pod.yaml
	kubectl apply -f apps/order-service/deployment.yaml

get-pods:
	kubectl get pods -n dev -o wide

deploy-stage2:
	kubectl apply -f apps/postgres/
	kubectl apply -f apps/order-service/

test-dns:
	kubectl run curl-test -n dev --image=curlimages/curl:latest --rm -it --restart=Never -- curl http://order-service

logs-sidecar:
	kubectl logs -n dev -l app=order-service -c sidecar-monitor -f