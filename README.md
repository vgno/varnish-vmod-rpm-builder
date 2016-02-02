= Docker image to build vmods for varnish

```console
docker build -t vmodbuild .
docker run --rm vmodbuild /bin/bash
```
Now within the image

```console
cd /root/rpmbuild/RPMS/x86_64/
scp * <to someplace nice>
```

