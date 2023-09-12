# Developer Documentation

## Overview
The project is split into 3 components:
1. WebUI
2. Background Runner
3. Docker

## WebUI */src/webui*
The WebUI, logic and backend is mainly done with [Lucky](https://luckyframework.org/),
which uses [Crystal](https://crystal-lang.org/) as language. The webpages are mainly static.
The html is mostly described in Crystal with [tags](https://luckyframework.org/guides/frontend/rendering-html).
Forms and [saving to the database](https://luckyframework.org/guides/database/saving-records) are done by luckys ORM Avram.
Browser actions run on the server on `GET` or `POST` request. Pages are rendered as HTML pages.

### How it works
The user enters the index page. Here he has the option to log in or proceed as guest. If he logs in he is automatically redirected to the task creation page.
If he proeceeds as guest, he is also redirected to the task creation page. There he can enter the code he wished to transcode as well as the input and output languages.
When he then presses *Go!*, the task is saved and he is redirected to the task check page, which refreshes every 5s to check for task completion.

### Browser Actions
#### `Home::Index` [index.cr](../src/webui/src/actions/home/index.cr)
Renders index page if not logged in. Otherwise redirects to `Task::ShowCreatePage`.
#### `Task::ShowCreatePage` [show_create_page.cr](../src/webui/src/actions/task/show_create_page.cr)
Creates an instance of `SaveTranscompileTask` and renders a form `Task::CreatePage` for saving transcompilation tasks.
#### `Task::SaveForm` [save_form.cr](../src/webui/src/actions/task/save_form.cr)
Receives from `Task::CreatePage` a `SaveTranscompileTask` which is saved if correct. The user is then redirected to `Task::ShowCheckPage`.
#### `Task::ShowCheckPage` [show_check_page.cr](../src/webui/src/actions/task/show_check_page.cr)
Checks the database for *task_id* of a `TranscompileTask` task and displays it on successfull copmletion.
#### `Docs::ShowApiDocs` [show_api_docs.cr](../src/webui/src/actions/docs/show_api_docs.cr)
Renders page with some limited api documentation.
#### `Docs::ShowLicense` [show_license.cr](../src/webui/src/actions/docs/show_license.cr)
Renders page with small amount of licensing information.

### Pages
#### `Home::IndexPage` [index_page.cr](../src/webui/src/pages/home/index_page.cr)
Homepage with login button and button to proceed as guest. If the user is allready logged in he is [redirected](https://luckyframework.org/guides/http-and-routing/request-and-response#redirecting) to `Task::ShowCreatePage`.
#### `Task::CreatePage` [create_page.cr](../src/webui/src/pages/task/create_page.cr)
Page for createing a `TranscompileTask`.
The user is given an input textarea for entering his code and two drop down menus for choosing the input and output language.
When pressing the "Go!" button the user is redirected via `Task::SaveForm` to `Task::CheckPage`.
#### `Task::CheckPage` [check_page.cr](../src/webui/src/pages/task/check_page.cr)
Selfrefreshing webpage for checking the status and result of the given `TranscompileTask`.
The JS code for the refresh can be found in "src/js/me.js"
The refresh comes from the BrowserAction `Task::ShowCheckPage`.
#### `Docs::ApiDocumentation` [api_documentation.cr](../src/webui/src/pages/docs/api_documentation.cr)
Static webpage displaying api documentation, which can also be found on github.
#### `Docs::LicenseDocumentation` [license_documentation.cr](../src/webui/src/pages/docs/license_documentation.cr)
Static webpage displaying some information regarding the licensing of the project.

### The Api
Usage for the api you can find in the [readme](../README.md).
#### `Api::Tasks::CreateTask` [create_task.cr](../src/webui/src/actions/api/tasks/create_task.cr)
Creates transcompilation task and returns id to fetch the result later.
#### `Api::Tasks::CheckTask` [check_task.cr](../src/webui/src/actions/api/tasks/check_task.cr)
This class harbours the api functionality of the server regarding checking if a transcompilation task exists or is finished. 
The user must supply an `id` of the task and his own api token (`auth_token`).
The function then returns `HTTP::Status::OK` (200) if the task exists.
Is `completed` true means that the task was executed and `output_code` is then also returned.

### JS
#### [me.js](../src/webui/src/js/me.js)
The code which refreshes the task check page every 5 seconds.

### The ORM
The ORM creates when running the [databse migration](https://luckyframework.org/guides/database/intro-to-avram-and-orms#migrations) the database and all the necessary tables for the models.
The ORM also saves user input into the database.
#### `TranscompileTask` [transcompiler_task.cr](../src/webui/src/models/transcompile_task.cr)
Class storing information about regarding transcompilation tasks.
*input_code* is the user provided code.
*output_code* is the transpiled code.
*completed* is the status of completion.
*priority* is the priority regarding if the request came from a user or guest.
*inp_lang* is the language of the provided code.
*outp_lang* is the target language of the transcompilation.
#### `CreateTranscompileTasks::V20230702161059` [20230702161059_create_transcompile_tasks.cr](../src/webui/db/migrations/20230702161059_create_transcompile_tasks.cr)
DB migration for `TranscompileTask`. This stores information for the orm what tables to create and how to roll back.
#### `SaveTranscompileTask` [save_transcompile_task.cr](../src/webui/src/operations/save_transcompile_task.cr)
Check the input of the user and and save it to the database.
This class inherits most of its functionality from `SaveOperation`.
The provided logic here is only there to permit the user to actually save certain variables
via `permit_columns`, to change priority if the user is logged in, to check validicity of
`inp_lang` and `outp_lang` and to check that `inp_lang` and `outp_lang` are not the same.

### Development Builds via `lucky dev`
1. [Install lucky](https://luckyframework.org/guides/getting-started/installing)
2. Install [postgres](https://www.postgresql.org/download/)
3. Head into the `./src/webui` directory
4. Configure [./config/database.cr](../src/webui/config/database.cr)
5. Run `./script/setup`
6. Run `lucky dev` for development build and deploy of the webui.
For more informaton please head to [the lucky framworks starter guide](https://luckyframework.org/guides/getting-started/starting-project).


## Background Runner */src/background_runner*
The background runner is a short piece of code which executes the transcoder perdiodically when a not completed task is found in the database.

### `background_runner_loop` [background_runner.cr](../src/background_runner/src/background_runner.cr)
Loop which reads transcompiler task with highest priority, executes it and writes it back to database.

This function opens a connection to the database `db_url` and executes until haltet the following:
1. Executes and read output of query `NEXT_JOB`.
2. Determine which model to use, depending on input and output languages.
3. Execute the transcoder.
4. Write on sucess the output back into database and set task as completed.

### `Env Variables`
The background runners options are given through env variables. Thus these settings can be quite easily edited in the docker compose file.
#### `WEBTRANS_POSTGRES_URL`
The url to the postgres server.
#### `WEBTRANS_PYTHON_EXECUTABLE_PATH`
The name of the python executable or its path.
#### `WEBTRANS_MODEL_1` & `WEBTRANS_MODEL_2`
Paths to the models of the facebookresearch transcoder.


## Docker
The project uses docker compose which builds the 2 docker files [`transcoder.dockerfile`](../src/transcoder.dockerfile) and [`webui.dockerfile`](../src/webui.dockerfile).
### [`webui.dockerfile`](../src/webui.dockerfile)
Builds the docker image encompassing the webui.
The dependencies for production compilation of the lucky project are installed into a crystal image and then the server is compiled.
This takes a few minutes. The resulting image is large.
### [`transcoder.dockerfile`](../src/transcoder.dockerfile)
There are multiple things going on here:
1. Downloading the models.
2. Compiling the background runner.
3. Installing the python dependencies to run the transcoder into a python venv.
4. Copying the python venv, the models and the background runner into the final stage.
### [`docker-compose.yml`](../src/docker-compose.yml)
The images ar pulled & build in orderly fashion, as execution of the `webui` is dependent on the `postgres` db and execution of the `transcoder` / background runner is dependent on the existence of the database and tables of db. These are created on the first run of the `webui`s databse migrations.
The env variables of the background runner where allready explained above. Information about the env variables of lucky for use of deploying a server you can find [here](https://luckyframework.org/guides/deploying/ubuntu).
The reason an nvidea gpu is needed at the moment, comes from [pytorch](https://pytorch.org/) needing different packages for the gpus of the different vendors. I have not implemented the image to build with amd gpus yet, as I cannot test if it works.

