ARG PYTHON_VERSION=3.7.5

FROM python:${PYTHON_VERSION}

ENV PIPENV_VENV_IN_PROJECT=1

RUN PIPENV_VERSION="2020.5.28" ; \
    pip install "pipenv==${PIPENV_VERSION}" && test "$(pip show pipenv | grep -E '^Version:\s+' | sed -E 's/^Version:\s+//')" = "${PIPENV_VERSION}"

RUN export DEBIAN_FRONTEND=noninteractive ; \
    ( command -v bash >/dev/null 2>/dev/null || apt-get install -y bash ) \
    && ( command -v git >/dev/null 2>/dev/null || apt-get install -y git )
