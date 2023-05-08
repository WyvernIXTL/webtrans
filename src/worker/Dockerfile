
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


FROM rockylinux:9

RUN dnf update -y

# Downloading models.
WORKDIR /opt/models
RUN curl -s -O https://dl.fbaipublicfiles.com/transcoder/model_1.pth https://dl.fbaipublicfiles.com/transcoder/model_2.pth

# Install Python.
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN dnf install python3-devel -y
RUN python3 -m ensurepip

# Install Clang.
RUN dnf install clang -y
RUN dnf install clang-devel -y
RUN dnf install python3-clang -y

# Install Python dependencies.
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Install git.
RUN dnf install git -y

# Download facebookresearch Transcoder
WORKDIR "/opt"
RUN git clone https://github.com/facebookresearch/TransCoder.git


# Install fastBPE.
WORKDIR "/optTransCoder/XLM/tools"
RUN git clone https://github.com/glample/fastBPE
WORKDIR "/optTransCoder/XLM/tools/fastBPE"
RUN clang++ -std=c++11 -pthread -O3 fastBPE/main.cc -IfastBPE -o fast
RUN python3 setup.py install

# Install Apex.
#WORKDIR "/opt"
#RUN git clone https://github.com/NVIDIA/apex
#WORKDIR "/opt/apex"
#RUN pip3 install -r requirements.txt
#RUN pip3 install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
#RUN pip3 install -v --disable-pip-version-check --no-cache-dir ./