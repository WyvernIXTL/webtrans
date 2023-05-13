
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
RUN curl -s -O https://dl.fbaipublicfiles.com/transcoder/model_1.pth
RUN curl -s -O https://dl.fbaipublicfiles.com/transcoder/model_2.pth

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
