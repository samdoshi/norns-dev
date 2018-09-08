# `norns-test-dummy`

## Quickstart

Run the following:

```
docker run --rm -it \
    --ulimit rtprio=95 --ulimit memlock=-1 --shm-size=256m \
    -p 5000:5000 -p 5555:5555 -p 5556:5556 \
    samdoshi/norns-test-dummy
```

Then visit http://127.0.0.1:5000/maiden/ in your browser.

**Type `Ctrl-b d` to quit `tmux` and the Docker session.**

## Getting sound output on Linux

_Coming soon_
