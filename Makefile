.PHONY: crds sleep install sleep gateway sleep grafana

crds:
	kubectl apply -f installation/crds/crd.yaml

sleep:
	sleep 120

install:
	helm package ./installation
	helm upgrade -i flagger ./flagger-1.0.1.tgz \
		--namespace=istio-system \
		--set crd.create=false \
		--set meshProvider=istio \
		--set metricsServer=http://prometheus:9090

gateway:
	helm package ./gateway
	helm install flagger-gateway ./flagger-0.1.0.tgz \
		--namespace=istio-system

grafana:
	helm package ./grafana
	helm upgrade -i flagger-grafana ./grafana-1.4.0.tgz \
		--namespace=istio-system \
		--set url=http://prometheus:9090 \
		--set user=admin \
		--set password=admin