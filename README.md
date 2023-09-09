# webtrans
WebTrans 2023 project

IN DEVELOPMENT! NOT FOR PRODUCTION!

## Getting Started
### Building and Running Worker Docker Container
Important!: Image size ~ 7 GB.

```bash
git clone https://github.com/WyvernIXTL/webtrans.git
cd ./webtrans/src
docker build -t wt_worker_debug .
```
Running with cuda enabled gpu:
```bash
docker run -it --rm --gpus <gpuid> wt_worker_debug
```
Running TransCoder:
```bash
cd /opt/TransCoder
python3 translate.py
```

## Usage

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