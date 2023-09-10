# webtrans
WebTrans 2023 project

IN DEVELOPMENT! NOT FOR PRODUCTION!


## Usage

### Quick Start
```bash
git clone https://github.com/WyvernIXTL/webtrans.git
cd webtrans/src
docker compose build
docker compose up
```
Should result in the website running on [127.0.0.1:8085](http://127.0.0.1:8085/)

### Configure
Before deployment you should configure some env variables in the docker compose file:
* `SECRET_KEY_BASE`
* `APP_DOMAIN`


### The API

#### Create Token with Login
```bash
curl example.com/api/sign_ins -X POST -d "user:email=user@example.com" -d "user:password=changeme"
```
returns
```json
{"token":"your-token"}
```

#### Create Token through Signup
```bash
curl example.com/api/sign_ups -X POST -d "user:email=user@example.com" -d "user:password=changeme" -d "user:password_confirmation=changeme"
```
returns
```json
{"token":"your-token"}
```

#### Create Transcompilation Task
```bash
curl example.com/api/createtask -X POST -H "Content-Type: application/json" -d '{
	"auth_token": "your-token",
	"transcompile_task": {
		"inp_lang": "inp-lang",
		"outp_lang": "outp-lang",
		"input_code": "your-encoded-code"
	}
}'
```
returns
```json
{"id":"task-id"}
```

#### Check Transcompilation Task
```bash
curl example.com/api/checktask/task-id -X GET -d "auth_token=your-token"
```
returns on success if finished (200)
```json
{"id": "task-id", "completed": "true", "output_code": "output_code"}
```
if not finished (200)
```json
{"id": "task-id", "completed": "false"}
```


### MISC

#### Use the Facebookresearch Transcoder Standalone
```bash
git clone https://github.com/WyvernIXTL/webtrans.git
cd ./webtrans/src
docker compose build
docker --it --rm --gpus all src-transcoder
python3 translate.py --src_lang <<cpp|python|java>> --tgt_lang <<cpp|python|java>> --model_path /opt/models/model_<<1|2>>.pth < inputfile
```

#### Troubleshooting
* Make sure to have enough RAM (wsl might crash with just 3GB)


#### License
The project is under MPL 2.0