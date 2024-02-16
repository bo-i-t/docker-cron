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
docker build -t example-cron-image .
```

Run the container with cron schedule as specified in [example-cronfile](./example-cronfile):
```
docker run -v ./example-cronfile:/etc/cron.d/crontab -d --name example-cron-container example-cron-image
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
docker image rm example-cron-image
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
docker run -v ./example-cronfile:/etc/cron.d/crontab -d --name example-cron-container -e PERSON_TO_GREET=Friend example-cron-image
```