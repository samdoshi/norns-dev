# Unmaintained

**I'm not longer maintaing this repo**

Please visit [`winder/norns-dev`][winder] for a version with working screen & input.

There are also lots of updates on this [lines thread][lines].

[winder]: https://github.com/winder/norns-dev
[lines]: https://llllllll.co/t/getting-norns-running-inside-docker-working/14938?u=sam

---

# Setting up a Norns development environment

**THIS REPO IS STILL A WORK IN PROGRESS**

[Discussions on lines](https://llllllll.co/t/getting-norns-running-inside-docker/14938).

## Docker images in this repo

 - [`norns-dev`][]: base Docker image, provides the build and run-time dependencies.
 - [`norns-test-dummy`][]: runs `jackd`, `crone`, `matron`, and `maiden`, but only using a dummy audio out, instructions are also provided for sound output and grid connectivity on Linux.

[`norns-dev`]: norns-dev/
[`norns-test-dummy`]: norns-test-dummy/

## Linux

Developer focused example coming soon, but for now see [`norns-test-dummy`] which provides instructions on connecting audio and grids.

## OS X

**Unsupported at the moment**

Some tricky challenges here.

Firstly how to get the audio as glitch free as possible?

 - Try to get `NetJack2` working between Vagrant/Docker and the host?
 - Try to run SuperCollider/Crone on the host and allow access via `ws-wrapper` to a guest in Vagrant/Docker?
 
How to get connect grids and other peripherals? Docker for Mac doesn't seem to allow for USB sharing, I think Vagrant does. The other alternative is to use the OSC protocol available in `libmonome`.

## Development strategies

### Maiden

Coming soon

### Matron

Coming soon

### Dust

Coming soon

## Future plans

### Screen / keys / encoders

Ideas:

 - Add a conditional flag to open an X11 surface instead of directly accessing the framebuffer.
 - Convert key presses from an X11 window to events in `matron` to simulate the keys and encoders.
 - Convert the `cairo` surface to a PNG and send that to browser via `maiden`.
 - Similarly allow `maiden` to send simulated key/encoder events to `maiden`.
 
X11 allows for remote display, so it can work with Docker and a virtual machine.

### Other

 - Add cross compilers to the `norns-dev` Docker image, as well as documentation to push build outputs to a device.
 - Investigate using [`pi-gen`][pi-gen] to automate the building of full system images.
 
 [pi-gen]: https://github.com/RPi-Distro/pi-gen
