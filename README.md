# Real-ESRGAN_containerization

## Goal 
The main goal of this project is to make inferences on the images by containerizing the https://github.com/xinntao/Real-ESRGAN project. The container should run in the infer.sh file with the given input image file path. In addition to this, the outputs should be in the same file path as the inputs.<br/>

## Application

### 1.	Setup:
Docker Desktop: 4.15.0
### 2.	Dockerfile Creation:

**Dockerfile**
---


FROM python:3.9								**---1**

RUN apt-get update && apt-get install -y git					**---2**

RUN git clone https://github.com/xinntao/Real-ESRGAN.git			**---3**	

WORKDIR /Real-ESRGAN							**---4**

RUN mkdir /Real-ESRGAN/inputs_local						**---5**

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y		**---6**

RUN pip install --upgrade pip							**---7**	

RUN pip install -r requirements.txt					**---8**

RUN python3 setup.py develop							**---9**

CMD ["python3", "inference_realesrgan.py","-n","RealESRGAN_x4plus","-i","inputs_local","-o","inputs_local","-t", "800", "--fp32"]			**---10**

---

1.	 It determines the base image layer. The base image is Python 3.9
2.	The git system is created on the container. 
3.	The GitHub repo of the application is cloned to the container environment by using git. 
4.	The Real-ESRGAN file is chosen as the working directory for running other docker instructions. 
5.	In the Real-ESRGAN file, the inputs_local file is created for the mounting operation with the input image path in the local. 
6.	Some cv2 dependencies are installed.
7.	The pip is upgraded.
8.	The required packages for the project are installed by using pip
9.	The setup.py script is run.
10.	The inference.py script is run with the required commands:<br/>
&nbsp;•	**RealESRGAN_x4plus:** model name<br/>
&nbsp;•	**-i inputs_local:** Describes the input file location. This file path will be mounted with the local input file path given as input. <br/>
&nbsp;•	**-o inputs_local:** Describes the output path. Originally, the application creates the default result file named "results" for the output. By adding this command, the input and output location will be the same file. In addition, the outputs will be created on the local file path too, by using bind mount.<br/>
&nbsp;•	**-t 800:** Tile size. <br/>
&nbsp;•	**--fp 32:** provides fp32 precision during inference.  (to prevent cuda out of memory)


### 3.	Docker Image Creation and Upload to Docker Hub:
After forming this dockerfile, the docker image of real_esrgan:v1 was created by running the command below. <br/>

&emsp; **docker build -t real_esrgan:v1 .**<br/>

In the Docker Hub, a repository was created named real_esrgan. The docker commands below were applied to push of the local docker image to Docker Hub. (cf76de880683 is image ID, beerce is username). If someone wants to create their own image in the hub, the username should be changed based on their own account. (url: https://hub.docker.com/repository/docker/beerce/real_esrgan/general)<br/>

&emsp; **docker tag cf76de880683 beerce/real_esrgan:v1** <br/>
&emsp; **docker push beerce/real_esrgan:v1** <br/>

### 4.	Inference file:
If the inference on Real-ESRGAN application is wanted to do, the image can be pulled from the Docker Hub, and then the container can be run (if the docker image is not in the docker desktop). To do this, the sh file below can be run or just the commands in the file can be run in the terminal.<br/>

&emsp; **./infer.sh C:/Users/… (PowerShell)** <br/>
&emsp; **Bash infer.sh C:/Users/…. (Git bash)**

**infer.sh**
---


 #!/bin/sh
docker pull beerce/real_esrgan:v1							**---1**

docker run --rm -d -it --platform linux/amd64 --name cont-realesrgan  --mount type=bind,src=$1,target=/Real-ESRGAN/inputs_local beerce/real_esrgan:v1		**---2**

---

1.	Pulling the docker image from the Docker Hub
2.	Running the container <br/>
&nbsp; •	**--rm:** provides removing the container after running <br/>
&nbsp; •	**--name:** specifies the container name. In this situation name is cont-realesrgan <br/>
&nbsp; •	**--platform linux/amd64:** the image OS is Linux and the architecture is amd64. To run this image in another OS this command can be used.<br/>
&nbsp; •	**--mount type: bind:** bind mount option<br/>
&nbsp; •	**src:** source path of the mounting. $1 represents the input given when the sh file is run.<br/>
&nbsp; •	**target:** target path in the container.<br/>

### Example
![image](https://user-images.githubusercontent.com/66211576/215257224-a987e244-97fb-4a6c-9c10-dbe747e11548.png)

![image](https://user-images.githubusercontent.com/66211576/215257229-45a129be-8776-4f41-80b6-9346d6601754.png)

