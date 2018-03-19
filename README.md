# shellinabox-shell

This is a simple docker container which contains shellinabox and some executables like `python`,`ipython`,`python3`,`ipython3`,`cling`. And using Tomorrow Theme from [shellinabox-s3](https://github.com/sevenissimo/shellinabox-s3) are included.

### How to run

1. mkdir a directory named `shellinabox-shell` or other names.
2. cd `shellinabox-shell`
3. create `docker-compose.yml` file which like belows
```
version: '2'

services:
    shellinabox-shell:
        build: .
        image: liudonghua123/shellinabox-shell:latest
        ports:
            - "4200:4200"
        restart: always
```
4. run `docker-compose up -d`

### License

MIT
