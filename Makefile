include Makefile.inc

define log 
    @echo "`date` - [INFO] - $(1)"
endef

all: get update

get: run cp clean 

run:
	$(call log, "run the image: ${IMAGE} for the container: ${NAME}")
	@docker run -d --name ${NAME} ${IMAGE} tail -f /dev/null

cp:
	$(call log, "cp the file from ${NAME}:/opt to /tmp")
	@docker cp ${NAME}:/opt/. /tmp

clean:
	$(call log, "clean the container: ${NAME}")
	@docker stop ${NAME}
	@docker rm -f ${NAME}

update: bak stop new delete restart

stop:
	$(call log, "stop svc: ${MASTER_COMPONENT} ${NODE_COMPONENT}")
	@systemctl stop ${MASTER_COMPONENT} ${NODE_COMPONENT} 

bak:
	$(call log, "backup: kubectl ${MASTER_COMPONENT} ${NODE_COMPONENT}")
	@mkdir -p /usr/local/bin/bak
	@cd /usr/local/bin; yes| cp ${MASTER_COMPONENT} ${NODE_COMPONENT} kubectl ./bak; cd -

new:
	$(call log, "deploy new binary files: kubectl ${MASTER_COMPONENT} ${NODE_COMPONENT}")
	@cd /tmp; tar -zxf kubernetes-server-linux-amd64.tar.gz; cd -
	@cd /tmp/kubernetes/server/bin; yes| cp ${MASTER_COMPONENT} ${NODE_COMPONENT} kubectl /usr/local/bin; cd -

delete:
	$(call log, "make /etc/systemd/system/kubelet.service right")
	@sed -i /"--allow-privileged="/d /etc/systemd/system/kubelet.service 

restart:
	$(call log, "restart svc: ${MASTER_COMPONENT} ${NODE_COMPONENT}")
	@systemctl daemon-reload
	@systemctl restart ${MASTER_COMPONENT} ${NODE_COMPONENT} 

test:
	@kubectl get nodes
