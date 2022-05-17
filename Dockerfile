FROM ubuntu:18.04

ARG USER_ID
ARG GROUP_ID

ARG git_owner="singnet"
ARG git_repo="phi"
ARG git_branch="master"

ENV SINGNET_DIR=/opt/${git_owner}
ENV PROJECT_DIR=/opt/${git_owner}/${git_repo}
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV PYTHONPATH "${PYTONPATH}:${PROJECT_DIR}/src"
ENV LD_LIBRARY_PATH /usr/local/lib

RUN mkdir -p ${PROJECT_DIR}

RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    git \
    vim

RUN cd /tmp && \
    apt update && \
    apt-get install build-essential

RUN python3 -m pip install -U pip

ADD ./requirements.txt ${SINGNET_DIR}

RUN cd ${SINGNET_DIR} && \
    pip3 install -r requirements.txt

RUN addgroup --gid $GROUP_ID user && \
    adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user

USER user

WORKDIR ${PROJECT_DIR}
