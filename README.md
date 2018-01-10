# 一键自行签发 SSL 证书

```bash
$ docker run -it --rm -v $PWD/ssl:/ssl khs1994/tls 127.0.0.1 123.206.62.18 www.t.khs1994.com lnmp.khs1994.com 192.168.199.100 ...
```

务必将 `./ssl/root-ca.crt` 导入浏览器中。各浏览器导入方法请自行查找。

# help

```bash
$ docker run -it --rm -v $PWD/ssl:/ssl khs1994/tls help
```

# 快速测试

`https://*.t.khs1994.com` 均指向 127.0.0.1

你可以使用这个网址快速测试。
