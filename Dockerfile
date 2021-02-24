FROM python:3.9

COPY src/instadl.sh /

RUN apt-get update -q -y \
    && apt-get install -q -y --no-install-recommends \
        ca-certificates \
        curl \
        acl \
        sudo \
        libfreetype6 \
        libjpeg62-turbo \
        libxpm4 \
        libpng16-16 \
        libicu63 \
        libxslt1.1 \
        libmemcachedutil2 \
        libzip4 \
        imagemagick \
        libonig5 \
        unzip \
        git

RUN pip install -U flask instaloader jupyterlab

VOLUME /downloads/

#CMD [ "cd", "/downloads/" ]
#CMD [ "/bin/bash", "/instadl.sh" ]
EXPOSE 8888
CMD [ "jupyter-lab", "server", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root" ]
