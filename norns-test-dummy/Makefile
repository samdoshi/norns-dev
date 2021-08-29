.phony: build run run-bash run-bash-root shell shell-root

build:
	docker build -t samdoshi/norns-test-dummy .

run:
	docker run --rm -it \
		--cap-add=SYS_NICE \
		--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
		--ulimit rtprio=95 --ulimit memlock=-1 --shm-size=256m \
		-p 5000:5000 \
		-p 5555:5555 \
		-p 5556:5556 \
		--name norns-test-dummy \
		samdoshi/norns-test-dummy

run-audio:
	docker run --rm -it \
		--device /dev/snd \
		--group-add $(shell getent group audio | cut -d: -f3) \
		--cap-add=SYS_NICE \
		--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
		--ulimit rtprio=95 --ulimit memlock=-1 --shm-size=256m \
		-p 5000:5000 \
		-p 5555:5555 \
		-p 5556:5556 \
		--name norns-test-dummy \
		-v /tmp/jackdrc:/etc/jackdrc \
		samdoshi/norns-test-dummy

run-bash:
	docker run --rm -it \
		--cap-add=SYS_NICE \
		--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
		--ulimit rtprio=95 --ulimit memlock=-1 --shm-size=256m \
		-p 5000:5000 \
		-p 5555:5555 \
		-p 5556:5556 \
		--name norns-test-dummy \
		samdoshi/norns-test-dummy \
		bash

run-bash-root:
	docker run --rm -it \
		--user root \
		--cap-add=SYS_NICE \
		--cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
		--ulimit rtprio=95 --ulimit memlock=-1 --shm-size=256m \
		-p 5000:5000 \
		-p 5555:5555 \
		-p 5556:5556 \
		--name norns-test-dummy \
		samdoshi/norns-test-dummy \
		bash

shell:
	docker exec -it norns-test-dummy bash

shell-root:
	docker exec -it --user root norns-test-dummy bash
