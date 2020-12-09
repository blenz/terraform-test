MAKEFLAGS += --silent

APP_NAME=terraform-test
ENV=development

LOCAL_IMAGE=$(APP_NAME)
TAG=$(shell git rev-parse HEAD)
REMOTE_IMAGE=blenz1/$(LOCAL_IMAGE):$(TAG)

dev:
	npm run start

docker-build:
	docker build -t $(LOCAL_IMAGE) .

docker-run: docker-build
	docker run -p 3001:80 $(LOCAL_IMAGE)

docker-push: docker-build
	docker tag $(LOCAL_IMAGE) $(REMOTE_IMAGE)
	docker push $(REMOTE_IMAGE)

tf-init:
	cd terraform && \
	terraform workspace new $(ENV) && \
	terraform init

check-do_token:
ifndef DO_TOKEN
	$(error DO_TOKEN is undefined)
endif

TF_ACTION?=plan
tf-action: check-do_token
	cd terraform && \
	terraform workspace select $(ENV) && \
	terraform $(TF_ACTION) \
		-var app_name="$(APP_NAME)" \
		-var do_token="${DO_TOKEN}"

ssh:
	doctl compute ssh $(APP_NAME)-$(ENV)

ssh-cmd:
	doctl compute ssh $(APP_NAME)-$(ENV) \
		--ssh-command "$(CMD)"

deploy: docker-push
	$(MAKE) ssh-cmd CMD='docker pull $(REMOTE_IMAGE)'
	-$(MAKE) ssh-cmd CMD='docker container stop $(APP_NAME)'
	-$(MAKE) ssh-cmd CMD='docker container rm $(APP_NAME)'
	$(MAKE) ssh-cmd CMD='\
		docker run -d \
			--name $(APP_NAME) \
			--restart=unless-stopped \
			-p 80:80 \
			$(REMOTE_IMAGE)'
