# Heroku buildpack for Elm apps

Check out the example app [elm-todomvc](https://github.com/evancz/elm-todomvc). In brief:

- Add an [`app.json`](https://github.com/evancz/elm-todomvc/blob/master/app.json) file
  - Ensure that a second buildpack provides the web server (elm-todomvc uses the static buildpack)
- Specify the value of `ELM_COMPILE` (command used to compile your Elm sources) in `app.json`
- Optionally specify the value of `ELM_PACKAGE_INSTALL` (command used to install your dependencies) in `app.json`. By default `elm package install --yes` will be used.
- Deploy!

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

* Modify the `ELM_VERSION` env var in Dockerfile
* `make binaries upload`
* Modify the `ELM_VERSION` env var in `bin/compile`
* Update CHANGELOG.md
* git push
