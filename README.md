# TLS

修改 `Dockerfile` 中的 `ENV`，替换为你自己的域名和 IP。

```bash
$ docker run --rm \
    -v $PWD/ssl:/ssl \
    -e DOMAIN=docker.diomain.com \
    -e SITE_IP=127.0.0.1 \
    khs1994/tls
```
