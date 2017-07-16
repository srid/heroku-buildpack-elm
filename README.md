# Heroku buildpack for Elm apps

Check out the example app [elm-todomvc](https://github.com/srid/elm-todomvc). In brief:

- Add an [`app.json`](https://github.com/srid/elm-todomvc/blob/heroku/app.json) file
  - Ensure that a second buildpack provides the web server (elm-todomvc uses the static buildpack)
- Specify the value of `ELM_COMPILE` (command used to compile your Elm sources) in `app.json`
- Add the elm buildpack: `heroku buildpacks:add https://github.com/srid/heroku-buildpack-elm`
  - Add static buildpack if needed: `heroku buildpacks:add https://github.com/hone/heroku-buildpack-static`
- Deploy! 
  - e.g. `git commit -am "empty" && git push heroku master && heroku ps:scale web=1`

## Customizing

### Elm Version

The buildpack aims to use the latest version of Elm by default. To specify an alternative Elm
version, create this file in your repo:

```
$ cat .buildpack.env
export ELM_VERSION=0.15
^D
```

### Build Cache
 
By default, this buildpack will save and reuse intermediate build objects between deploys. If you want to perform a clean build on every deploy, you may specify that in your .buildpack.env file:

```
$ cat .buildpack.env
export CACHE_BUILD_OBJECTS=false
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

### Upgrading to newer Elm version

* Modify the `ELM_VERSION` env var in Dockerfile
* `make binaries upload`
* Modify the `ELM_VERSION` env var in `bin/compile`
* Update CHANGELOG.md
* git push

## Questions?

Feel free to ask in Github Issues.
