# Purpose

In the course of the past few months working with pipenv I've noticed some rather annoying behavior in some edge cases where a lockfile can exist and the virtualenv that is built does not match the lockfile.

In addition I've noticed cases where constructing a lockfile yields a virtual-env that is incorrectly configured, but a lockfile that matches the intent of the Pipenv file and author.

This repo is one such case where I can trivially recreate this issue.

( note that one can also trivially solve the issue by forking mher/flower at commit f20f43c858df3c0a94e5e10015fcd7d52089e3f0 and locking celery to version 3.1.19 )

## Broken Expectations:

If a virtualenv constructed by pipenv when calling pipenv sync has a dependency state that breaks the top-most specification of a dependency then AN ERROR SHOULD BE REPORTED.

Ideally, there would be no need for an error to be thrown up to the user because a successful resolution path can be found. This is not always possible given a tree of dependency versions constraints cannot always be flattened such that all packages are satisfied. At the very least the user should not be under the impression that the virtualenv has been properly constructed only to find out that something differs from the intent expressed in the lockfile ( much less the Pipenv file ).

### Related Issues:

1. https://github.com/pypa/pipenv/issues/3296

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
