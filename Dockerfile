FROM "debian:stable-slim"
RUN mkdir -p /tensorflow/models
RUN apt-get update && yes | apt-get upgrade
RUN apt-get install -y git python-pip protobuf-compiler python-pil python-lxml
RUN pip install --upgrade pip
RUN pip install tensorflow jupyter matplotlib flask
RUN git clone https://github.com/tensorflow/models.git /tensorflow/models
WORKDIR /tensorflow/models/research
RUN protoc object_detection/protos/*.proto --python_out=.
RUN export PYTHONPATH=$PYTHONPATH:`pwd`:`pwd`/slim
RUN jupyter notebook --generate-config --allow-root
RUN echo "c.NotebookApp.password = u'sha1:6a3f528eec40:6e896b6e4828f525a6e20e5411cd1c8075d68619'" >> /root/.jupyter/jupyter_notebook_config.py
EXPOSE 8888
#CMD ["jupyter", "notebook", "--allow-root", "--notebook-dir=/tensorflow/models/research/object_detection", "--ip=0.0.0.0", "--port=8888", "--no-browser"]
EXPOSE 5000
WORKDIR /tensorflow/models/research/object_detection
CMD ["python", "flask_app.py"]