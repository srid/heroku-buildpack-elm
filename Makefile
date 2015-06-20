IMG := heroku-buildpack-elm
AWSVOL := ~/.aws:/root/.aws

all:	binaries
	@true

binaries:
	docker build -t ${IMG} .

upload:
	docker run --rm -v ${AWSVOL} --name=${IMG}-uploader ${IMG} upload-to-s3.sh

shell:
	docker run --rm -it -v ${AWSVOL} ${IMG} bash
