# dockerfiles

> Dockerfile.chrome

```bash
docker build --tag chrome/dev --file Dockerfile.chrome .
docker run -d -t chrome/dev
```

> Dockerfile.tor

```bash
docker build --tag tor/dev --file Dockerfile.tor .
docker run -d -t tor/dev
```

> Dockerfile.nginx

```bash
docker build --tag nginx/dev --file Dockerfile.nginx .
docker run -d -t -p 80:80 nginx/dev
```
