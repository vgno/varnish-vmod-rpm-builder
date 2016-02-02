# Docker image to build vmods for varnish

## Build and Run

```console
docker build -t vmodbuild .
docker run --rm vmodbuild /bin/bash
```
### Copy the files to someplace from within the image

```console
cd /root/rpmbuild/RPMS/x86_64/
scp * <to someplace nice>
```

