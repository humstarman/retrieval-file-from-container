all: run cp clean

run:
	@docker run -d --name ${NAME} ${IMAGE} tail -f /dev/null

cp:
	@docker cp ${NAME}:/opt/. /tmp

clean:
	@docker stop ${NAME}
	@docker rm -f ${NAME}
