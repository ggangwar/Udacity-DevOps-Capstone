lint:
	# This is linter for Dockerfiles
	hadolint --ignore DL3007 Dockerfile
	#hadolint Dockerfile
	# This is a linter for html files
	tidy -q -e index.html
build:
	sh ./run_docker.sh
upload:
	sh ./upload_docker.sh
deploy:
	sh ./run_kubernetes.sh
redirect:
	sh ./run_bluegreen_kubernetes.sh