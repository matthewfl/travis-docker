KERNEL_PATH=/home/matthew/Downloads/linux
DOCKER=sudo docker

all: uml

uml:
	$(DOCKER) build -t travis-uml-builder .
	$(DOCKER) run -v $(KERNEL_PATH):/kernel --name travis-uml-builder -t travis-uml-builder make -f /Makefile uml-inside
	exit `$(DOCKER) wait travis-uml-builder`
	cp $(KERNEL_PATH)/linux uml


uml-inside:
	cd /kernel && make ARCH=um -j 4
	cp /kernel/linux /uml

docker-download:
	curl  https://get.docker.io/builds/Linux/x86_64/docker-latest > docker
	chmod +x docker

package:
	mkdir -p pkg
	cp docker pkg
	cp uml pkg
	cp start pkg
	cp init pkg
	./makeself/makeself.sh --header ./makeself/makeself-header.sh --bzip2 --nox11 --nowait --copy pkg travis-docker.run "Travis docker" 'source ./start'

clean:
	-$(DOCKER) rm -f travis-uml-builder
	-$(DOCKER) rmi -f travis-uml-builder
	#-rm -rf docker

test:
	-rm -rf /tmp/travis-docker
	./travis-docker.run
