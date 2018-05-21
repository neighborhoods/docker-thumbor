FROM python:2
WORKDIR /usr/src/app
VOLUME /data

RUN awk '$1 ~ "^deb" { $3 = $3 "-backports"; print; exit }' /etc/apt/sources.list > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y autoremove && \
    apt-get install -y --no-install-recommends \
        python-numpy \
        python-opencv \
        git \
        curl \
        libdc1394-22 \
        libjpeg-turbo-progs \
        graphicsmagick \
        libgraphicsmagick++3 \
        libgraphicsmagick++1-dev \
        libgraphicsmagick3 \
        libboost-python-dev \
        gifsicle \
        ffmpeg

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip==9.0.3 && pip install --no-cache-dir -r requirements.txt

COPY conf/thumbor.conf.tpl thumbor.conf.tpl
ENV PYTHONPATH /usr/lib/python2.7/site-packages:/usr/local/lib/python2.7/site-packages
COPY entrypoint.sh /

EXPOSE 8000


ENTRYPOINT ["/entrypoint.sh"]
CMD ["thumbor"]