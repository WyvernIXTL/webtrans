
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


FROM fedora:latest

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

# Install GCC (fastBPE dependeny).
RUN dnf install gcc -y
RUN dnf install gcc-c++ -y

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
RUN g++ -std=c++11 -pthread -O3 fastBPE/main.cc -IfastBPE -o fast
RUN python3 setup.py install

# Change libclang.so path of /opt/TransCoder/preprocessing/src/code_tokenizer.py
WORKDIR /
RUN sed -i "s|clang.cindex.Config.set_library_path('/usr/lib/llvm-7/lib/')|clang.cindex.Config.set_library_path('/usr/lib64')|g" /opt/TransCoder/preprocessing/src/code_tokenizer.py
RUN echo "Modified file preprocessing/src/code_tokenizer.py changing /usr/lib/llvm-7/lib/ to /usr/lib64 \n this modification is under the same license as this library" >> /opt/TransCoder/MODIFICATIONS.txt

# !!!!!!!!!! this might be a problem
RUN ln -s /usr/lib64/libclang.so.16 /usr/lib64/libclang-16.so



# Install Apex.
#WORKDIR "/opt"
#RUN git clone https://github.com/NVIDIA/apex
#WORKDIR "/opt/apex"
#RUN pip3 install -r requirements.txt
#RUN pip3 install -v --disable-pip-version-check --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./
#RUN pip3 install -v --disable-pip-version-check --no-cache-dir ./