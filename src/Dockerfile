
# Copyright (C) 2023 Adam McKellar
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


FROM rockylinux:9

# Copy of helper scripts.
WORKDIR /opt
ADD ./helper_scripts ./helper_scripts

# Downloading models.
WORKDIR /opt/models
RUN /opt/helper_scripts/download_and_check_against_sha512.sh https://dl.fbaipublicfiles.com/transcoder/model_1.pth 1be95d2f4b81b90811f3342e36f231fe75f74f52aed5282dca48bac17f93b8172eebc86af1a95d91fc6a05806535e8a8df6ebdc17bbf229f01fc77aec27358b9
RUN /opt/helper_scripts/download_and_check_against_sha512.sh https://dl.fbaipublicfiles.com/transcoder/model_2.pth a5b375fcc6cd919b292f0618ce206226e7408b066466fc30cc3f4430e79650e647c64f0883516eb246309a5c1afadeb48927b38778040c10c32186ed99c01566

# Install Python.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN dnf install python3-devel -y
RUN python3 -m ensurepip

# Install Clang.
RUN dnf install clang -y
RUN dnf install clang-devel -y
RUN dnf install python3-clang -y

# Install git.
RUN dnf install git -y

# Install Python dependencies.
WORKDIR /opt
COPY requirements.txt .
RUN pip3 install -r requirements.txt
RUN pip3 install fastBPE==0.1.0

# Download facebookresearch Transcoder
WORKDIR /opt
RUN git clone https://github.com/facebookresearch/TransCoder.git

# Change libclang.so path of /opt/TransCoder/preprocessing/src/code_tokenizer.py
WORKDIR /
RUN sed -i "s|clang.cindex.Config.set_library_path('/usr/lib/llvm-7/lib/')|clang.cindex.Config.set_library_path('/usr/lib64')|g" /opt/TransCoder/preprocessing/src/code_tokenizer.py
RUN echo "Modified file preprocessing/src/code_tokenizer.py changing /usr/lib/llvm-7/lib/ to /usr/lib64 \n this modification is under the same license as this library" >> /opt/TransCoder/MODIFICATIONS.txt

# Creating Symlinks of libclang.
WORKDIR /usr/lib64
RUN /opt/helper_scripts/sym_link_libclang.sh
