
# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# syntax=docker/dockerfile:1

# === Download Models and other files ===

FROM rockylinux:9 AS downloader

# Copy of helper scripts.
WORKDIR /opt/helper_scripts
COPY ./helper_scripts/download_and_check_against_sha512.sh ./

# Downloading models.
WORKDIR /opt/models
RUN /opt/helper_scripts/download_and_check_against_sha512.sh https://dl.fbaipublicfiles.com/transcoder/model_1.pth 1be95d2f4b81b90811f3342e36f231fe75f74f52aed5282dca48bac17f93b8172eebc86af1a95d91fc6a05806535e8a8df6ebdc17bbf229f01fc77aec27358b9
RUN /opt/helper_scripts/download_and_check_against_sha512.sh https://dl.fbaipublicfiles.com/transcoder/model_2.pth a5b375fcc6cd919b292f0618ce206226e7408b066466fc30cc3f4430e79650e647c64f0883516eb246309a5c1afadeb48927b38778040c10c32186ed99c01566


# === Base Image with Python ===

FROM rockylinux:9 as pythonbaseslim

# Enable EPEL
RUN dnf install epel-release -y

# Install Python.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN dnf install python3 -y
RUN python3 -m ensurepip


# === Base Image with Build Tools ===

FROM pythonbaseslim as builderbase

# Install Python Deleoper Headers
RUN dnf install python3-devel -y
RUN python3 -m ensurepip

# Install Clang.
RUN dnf install clang -y
RUN dnf install clang-devel -y
RUN dnf install python3-clang -y

# Install git.
RUN dnf install git -y


# === Builder Base Image with Helper Scripts, requirements.txt and Symlinks ===

FROM builderbase AS builderbaseh

# Copy of helper scripts.
WORKDIR /opt
ADD ./helper_scripts ./helper_scripts

# COPY requirements.txt
WORKDIR /opt
COPY requirements.txt .

# Update Clang Version in /opt/requirements.txt and create symlinks
WORKDIR /opt/helper_scripts/
RUN ./create_symlinks_and_update_requirements_libclang.sh


# === Slim Runner Base with symlinks and libclang libs ===

FROM pythonbaseslim as pythonbaseslimh

# Install Clang Libs
RUN dnf install clang-libs -y

# Copy of helper scripts.
WORKDIR /opt
ADD ./helper_scripts ./helper_scripts

# COPY requirements.txt
WORKDIR /opt
COPY requirements.txt .

# Update Clang Version in /opt/requirements.txt and create symlinks
WORKDIR /opt/helper_scripts/
RUN ./create_symlinks_and_update_requirements_libclang.sh


# === Python Dependency Install in VENV ===

FROM builderbaseh AS pythonbase

# Install Python dependencies.
WORKDIR /opt
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip3 install -r requirements.txt
RUN pip3 install fastBPE==0.1.0


# === TransCoder Download ===

FROM builderbase AS transcoderdownloader

# Download facebookresearch Transcoder
WORKDIR /opt
RUN git clone https://github.com/facebookresearch/TransCoder.git

# Change libclang.so path of /opt/TransCoder/preprocessing/src/code_tokenizer.py
WORKDIR /
RUN sed -i "s|clang.cindex.Config.set_library_path('/usr/lib/llvm-7/lib/')|clang.cindex.Config.set_library_path('/usr/lib64')|g" /opt/TransCoder/preprocessing/src/code_tokenizer.py
RUN echo "Modified file preprocessing/src/code_tokenizer.py changing /usr/lib/llvm-7/lib/ to /usr/lib64 \n this modification is under the same license as this library" >> /opt/TransCoder/MODIFICATIONS.txt


# === Webtrans ENV ===

FROM pythonbaseslimh AS transcoderenv

# Fetch Python Venv
COPY --from=pythonbase /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy TransCoder
COPY --from=transcoderdownloader /opt/TransCoder /opt/TransCoder

COPY --from=downloader /opt/models /opt/models


# === Building Background Runner ===
FROM crystallang/crystal:1.9-alpine AS cralp
WORKDIR /opt
COPY ./background_runner ./background_runner
WORKDIR /opt/background_runner
RUN shards install
RUN shards build --production --release --static


# === Deployment ===

FROM transcoderenv as deployment

COPY --from=cralp /opt/background_runner/bin/ /opt/background_runner/bin/

WORKDIR /opt/TransCoder
