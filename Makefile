IMG := heroku-buildpack-elm

all:	binaries
	@true

binaries:
	docker build -t ${IMG} .

upload:
	docker run --rm -v ${AWSVOL} ${AWSENV} ${IMG} docker2s3.sh

shell:
	docker run --rm -it ${IMG} bash
