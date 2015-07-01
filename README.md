# Heroku buildpack for Elm apps

See [the blog post](http://www.srid.ca/posts/2015-06-14-elm-on-heroku.html) for details.

Or, check out the example app [elm-todomvc](https://github.com/evancz/elm-todomvc).

## Customizing

The buildpack aims to use the latest version of Elm by default. To specify an alternative Elm
version, create this file in your repo:

```
$ cat > .buildpack.env
export ELM_VERSION=0.15
^D
```

## HACKING

### Generating and uploading binaries

Binaries are generated using docker, and uploaded to s3.

```
# To generate docker image containing the binaries
make binaries

# To upload to s3
aws configure  # creates ~/.aws/...
make upload
```

### Updating binaries

* Modify the `FOO_VERSION` env var in Dockerfile
* `make binaries upload`
* Modify the `FOO_VERSION` env var in `bin/compile`
* Update CHANGELOG.md
* git push
