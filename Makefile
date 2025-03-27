start:
	minikube start --nodes 2 -p multinode-demo --force

stop:
	minikube stop -p multinode-demo

run:
	helm install prometheus-operator prometheus-community/kube-prometheus-stack -f kubernetes-prometheus/values.yaml --namespace monitoring
	kubectl apply -f "kubernetes-node-exporter/*.yaml"
	kubectl apply -f "kube-state-metrics-configs/*.yaml"
	kubectl apply -f "kubernetes-grafana/*.yaml"
	kubectl apply -f "otel-collector/*.yaml"
	kubectl apply -f "otel-agent/*.yaml"

run-php:
	kubectl apply -f "generate-load/*.yaml"

delete-php:
	kubectl delete -f "generate-load/*.yaml"

run-load:
	kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache; done"

delete:
	# kubectl delete -f "kubernetes-prometheus/*.yaml"
	helm uninstall prometheus-operator -n monitoring
	kubectl delete -f "kubernetes-node-exporter/*.yaml"
	kubectl delete -f "kube-state-metrics-configs/*.yaml"
	kubectl delete -f "kubernetes-grafana/*.yaml"
	kubectl delete -f "otel-collector/*.yaml"
	# kubectl delete -f "otel-agent/*.yaml"
	# kubectl delete -f "kubernetes-alertmanager/*.yaml"
