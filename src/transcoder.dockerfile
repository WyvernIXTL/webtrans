# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# === Model Download ===
# Downloads the models for the facebookresearch transcoder.
# The model files are then hashed for integrity and hinder dependency exploits.
FROM rockylinux:9 AS downloader
WORKDIR /opt/helper_scripts
COPY ./helper_scripts/download_and_check_against_sha512.sh ./
WORKDIR /opt/models
RUN /opt/helper_scripts/download_and_check_against_sha512.sh https://dl.fbaipublicfiles.com/transcoder/model_1.pth 1be95d2f4b81b90811f3342e36f231fe75f74f52aed5282dca48bac17f93b8172eebc86af1a95d91fc6a05806535e8a8df6ebdc17bbf229f01fc77aec27358b9
RUN /opt/helper_scripts/download_and_check_against_sha512.sh https://dl.fbaipublicfiles.com/transcoder/model_2.pth a5b375fcc6cd919b292f0618ce206226e7408b066466fc30cc3f4430e79650e647c64f0883516eb246309a5c1afadeb48927b38778040c10c32186ed99c01566


# === TransCoder Download ===
# Download facebookresearch transcoder.
# Change hardcoded path of clang library. (libclang.so)
FROM rockylinux:9 AS transcoderdownloader
RUN dnf install git -y
WORKDIR /opt
RUN git clone https://github.com/facebookresearch/TransCoder.git
WORKDIR /
RUN sed -i "s|clang.cindex.Config.set_library_path('/usr/lib/llvm-7/lib/')|clang.cindex.Config.set_library_path('/usr/lib64')|g" /opt/TransCoder/preprocessing/src/code_tokenizer.py
RUN echo "Modified file preprocessing/src/code_tokenizer.py changing /usr/lib/llvm-7/lib/ to /usr/lib64 \n this modification is under the same license as this library" >> /opt/TransCoder/MODIFICATIONS.txt


# === Building Background Runner ===
# Build the Background Runner.
FROM crystallang/crystal:1.9-alpine AS crystalalpine
WORKDIR /opt
COPY ./background_runner ./background_runner
WORKDIR /opt/background_runner
RUN shards install
RUN shards build --production --release --static


# === Base Image with Python ===
# EPEL is enabled. Installs python and Clang/LLVM libraries.
# Symlinks and python dependencies are dynamically changed to existing LLVM/Clang version.
FROM rockylinux:9 AS pythonbaseslim
RUN dnf install epel-release -y
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN dnf install python3 -y
RUN python3 -m ensurepip

RUN dnf install clang-libs -y
WORKDIR /opt
ADD ./helper_scripts/create_symlinks_and_update_requirements_libclang.sh /opt/helper_scripts/
ADD requirements.txt .
WORKDIR /opt/helper_scripts/
RUN ./create_symlinks_and_update_requirements_libclang.sh


# === Base Image with Python and Build Tools ===
# LLVM and python development libraries are installed.
# Transcoder dependencies are installed in a virtual environment. (venv)
FROM pythonbaseslim AS pythonbase
RUN dnf install python3-devel -y
RUN python3 -m ensurepip
RUN dnf install clang -y
RUN dnf install clang-devel -y
RUN dnf install python3-clang -y

WORKDIR /opt
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip3 install -r requirements.txt
RUN pip3 install fastBPE==0.1.0


# === Webtrans ENV ===
# This stage encompasses all necessary tools and libraries to exectue the transcoder.
#
# Copy python venv & transcoder python code & models & background_runner
FROM pythonbaseslim AS transcoderenv
COPY --from=pythonbase /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
COPY --from=transcoderdownloader /opt/TransCoder /opt/TransCoder
COPY --from=downloader /opt/models /opt/models
COPY --from=crystalalpine /opt/background_runner/bin/ /opt/background_runner/bin/
WORKDIR /opt/TransCoder

