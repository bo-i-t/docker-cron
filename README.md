# Docker Cron

Easily run cron schedules in a docker container.

Intended to facilitate fast setup of services for automated tasks such as
- Database backups
- ETL
- Model retraining
- Monitoring
- ...

## Quickstart

Build the image:
```
docker build -t bo-i-t/docker-cron https://github.com/bo-i-t/docker-cron.git
```

Run the container with your cron schedule mounted at `/etc/cron.d/crontab`. For this example we will use the
[example-cronfile](./example-cronfile) contained in this repo:
```
docker run -d -v ./example-cronfile:/etc/cron.d/crontab --name example-cron-container bo-i-t/docker-cron
```

Have a look at the container logs:
```
docker logs -f example-cron-container
```
These should show the cron file that was loaded and, after waiting for about one minute, "Hello World!" is printed.

Clean up:
```
docker stop example-cron-container
docker rm example-cron-container
docker image rm bo-i-t/docker-cron
```

## Details

### The crontab file

If the default docker [CMD](https://docs.docker.com/engine/reference/builder/#cmd) is not overwritten, the container will run the
[cron.sh](./cron.sh) script which expects the cron file at `/etc/cron.d/crontab`.

There are two main options to pass the job specifications to the container:

1. Mount a cron file from the host into the container as in the quickstart example above. Updating the cron schedule with this
option only requires restarting the container after changing the cron file on the host.
2. Create a custom image from this base image that copies a cronfile into the image. Updating the cron schedule with this option
requires a rebuild after changing the cron file on the host.

### Logs

If the default docker [CMD](https://docs.docker.com/engine/reference/builder/#cmd) is not overwritten, the container will run the
[cron.sh](./cron.sh) script which tails and echos `/var/log/cron.log` into the container output.
So a cron job that appends to this file (as in [example-cronfile](./example-cronfile)) will have any script output shown in the
container logs.

### Environment variables

The default docker [CMD](https://docs.docker.com/engine/reference/builder/#cmd) [cron.sh](./cron.sh) takes care of making any environment variables
passed to the container available in cron jobs.
Try to repeat the quickstart example above but pass the variable `PERSON_TO_GREET` into the container, e.g:
```
docker run -d -v ./example-cronfile:/etc/cron.d/crontab --name example-cron-container -e PERSON_TO_GREET=Friend bo-i-t/docker-cron
```

### Versions

The command
```
docker build -t bo-i-t/docker-cron https://github.com/bo-i-t/docker-cron.git
```
used in the quick start example above will build the image based on the current state of this repository's main branch. The local image
will have the full tag `bo-i-t/docker-cron:latest`.

It is recommended to fix the version by specifying full image and git tags when building the image like so:
```
docker build -t bo-i-t/docker-cron:v1.0.0 https://github.com/bo-i-t/docker-cron.git#v1.0.0
```

### Build arguments

By default, the image will be based on the [official `debian:bullseye` image](https://hub.docker.com/_/debian). This can be customized via the 
`DEBIAN_RELEASE` [build arg](https://docs.docker.com/build/guide/build-args/).
E.g. a bookworm based image could be build via
```
docker build -t bo-i-t/docker-cron-bookworm --build-arg="DEBIAN_RELEASE=bookworm" https://github.com/bo-i-t/docker-cron.git
```

# License

This project is licensed under the terms of the MIT license.