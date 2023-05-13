# webtrans
WebTrans 2023 project

IN DEVELOPMENT! NOT FOR PRODUCTION!

## Getting Started
### Building and Running Worker Docker Container
Important!: Image size > 7 GB.

```bash
git clone https://github.com/WyvernIXTL/webtrans.git
cd ./webtrans/src
docker build -t wt_worker_debug .
```
Running with cuda enabled gpu:
```bash
docker run -it --gpus <gpuid> wt_worker_debug
```
Running TransCoder:
```bash
cd /opt/TransCoder
python3 translate.py
```