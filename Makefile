IMG := heroku-buildpack-elm

all:	binaries
	@true

binaries:
	docker build -t ${IMG} .

upload:
	docker run --rm ${IMG} docker2s3.sh
