MAKEFLAGS += --silent

APP_NAME=terraform-test

dev:
	npm run start

docker-build:
	docker build -t $(APP_NAME) .

docker-run: docker-build
	docker run -p 3001:80 $(APP_NAME)