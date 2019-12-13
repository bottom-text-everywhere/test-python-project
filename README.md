# make environment requirements:

1. make
1. command | which
1. bash
1. git
1. sed
1. rm
1. mkdir
1. touch
1. docker

# clean virtualenv

```bash
make clean
```

# run tests

```bash
make test
```

### what are the tests?

[see test.sh](test.sh)

### other commands

1. create a docker image where tests can run

```bash
make build
```

2. start a shell in a docker image where tests run

```bash
make shell
```
