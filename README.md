# TLS

替换 `DOMAIN` 为你的网站地址 `SITE_IP` 为你站点的 IP。

```bash
$ docker run --rm \
    -v $PWD/ssl:/ssl \
    -e DOMAIN=docker.domain.com \
    -e SITE_IP=127.0.0.1 \
    khs1994/tls
```

将 `./ssl/root-ca.crt` 导入浏览器中。
