FROM python:3.9

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/xinntao/Real-ESRGAN.git

WORKDIR /Real-ESRGAN
RUN mkdir /Real-ESRGAN/inputs_local


RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y


RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN python3 setup.py develop

CMD ["python3", "inference_realesrgan.py","-n","RealESRGAN_x4plus","-i","inputs_local","-o","inputs_local","-t", "800", "--fp32"]














