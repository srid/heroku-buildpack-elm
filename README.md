# Heroku buildpack for Elm apps

See [the blog post](http://www.srid.ca/posts/2015-06-14-elm-on-heroku.html) for details.

Or, check out the example app [elm-todomvc](https://github.com/evancz/elm-todomvc).

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

