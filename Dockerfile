FROM python:3.7-slim
# install the notebook package
RUN pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

# Install things needed for dev.
RUN apt-get update
RUN apt-get install --yes --no-install-recommends build-essential advancecomp git

# User env finalise
RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}

RUN git clone https://github.com/NetBSD/src
RUN (cd src;./build.sh -U -u -j4 -m amd64 -O ~/obj tools)
RUN (cd src;./build.sh -U -u -j4 -m amd64 -O ~/obj kernel=USERMODE)

