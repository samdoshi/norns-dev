# `samdoshi/norns-dev`

## About this Docker image

This Docker image contains both the build-time and run-time dependencies for [`matron`][matron] and [`maiden`][maiden]

Please visit [github.com/samdoshi/norns-dev][norns-dev] for information on how to use this image to set up a build environment customised to your requirements.

[matron]: https://github.com/monome/norns
[maiden]: https://github.com/monome/maiden
[norns-dev]: https://github.com/samdoshi/norns-dev

The image makes available:

 - **[`go`][go]**: required to build [`maiden`][maiden].
 - **[`node`][node] & [`yarn`][yarn]**: required to build the front end for [`maiden`][maiden].
 - **[`jack2`][jack2]**: compiled without D-Bus to allow it to run headless.
 - **[`lua`][lua], [`luarocks`][luarocks] & [`ldoc`][ldoc]**: `ldoc` is required to build the Lua documentation.
 - **[`supercollider`][supercollider] & [`sc3-plugins`][sc3-plugins]**: compiled without the IDE.
 - **[`libmonome`][libmonome]**: without OSC and with `udev` disabled as it doesn't work well in the Docker environment.
 - **[`nanomsg`][nanomsg]**: required for `ws-wrapper`.
 
Please see `install.sh` and `install-lib.sh` to see exactly what is installed.
 
[go]: https://golang.org/
[jack2]: http://www.jackaudio.org/
[lua]: http://www.lua.org/
[luarocks]: https://luarocks.org/
[ldoc]: http://stevedonovan.github.io/ldoc/
[supercollider]: https://supercollider.github.io/
[sc3-plugins]: https://supercollider.github.io/sc3-plugins/
[node]: https://nodejs.org/en/
[yarn]: https://yarnpkg.com/en/
[libmonome]: https://github.com/monome/libmonome
[nanomsg]: https://github.com/nanomsg/nanomsg

## Summary of `Makefile` targets

 - **`build`**: builds the Docker image and tags it as `samdoshi/norns-dev`.
 - **`run`**: runs the image with increased `/dev/shm` size and a higher `rtprio` so that `jackd` works, and then drops you at a `bash` prompt.

## Tips and tricks

We're using a single `RUN` directive to set up the image, partly to keep the image as small as possible, but also to avoid having a very large `Dockerfile` that is hard to edit. However, if you're trying to make changes, it can be frustrating having to run the entirety of `install.sh` for every small change you make.

The best technique is to either comment out the `RUN /tmp/install/install.sh` line in the `Dockerfile`, then a `make build` followed by a `make run` will leave you at a `bash` prompt where you can manually run the individual `install_*` functions (after sourcing `install-lib.sh`).

e.g.:

```
# on the host
$ make build
$ make run
# we're now inside the container
$ source /tmp/install/install-lib.sh
$ install_apt
$ install_packages
# etc, etc
```

At this point you can interactively configure and compile software, and then use what you've learned to update `install-lib.sh`.

Alternatively, you can comment out steps in `install.sh` to have `make build` create a partially built image.

## Notes

`supercollider` and `sc3-plugins` are built with `make -j1` to reduce the amount of memory required so that they build as 'automated builds' on Docker Hub, or in the default 2GB Docker for Mac virtual machine.

