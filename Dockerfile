# This file creates a container that runs a InstaPy on Raspberry Pi
#
# Author: Preetham Lokesh
# Date 15/01/2021
#
# Originally from: https://github.com/preethaml7/raspberrypi-instapy
#

FROM balenalib/raspberrypi3-python:3.7.4-build
MAINTAINER Preetham Lokesh <preetham.l@icloud.com>

WORKDIR /code

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.23.0/geckodriver-v0.23.0-arm7hf.tar.gz \
    && tar -xvzf geckodriver-v* \
    && chmod +x geckodriver \
    && cp geckodriver /usr/local/bin/

RUN rm -rf geckodriver*

RUN python3 -m ensurepip --upgrade
RUN pip3 install --upgrade pip

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
      wget \
      gcc \
      g++ \
      tmux \
      xvfb \
      firefox-esr \
    && wget -O '/tmp/requirements.txt' https://raw.githubusercontent.com/InstaPy/instapy-docker/master/requirements.txt \
    && pip3 install --no-cache-dir -U -r /tmp/requirements.txt \
    && pip3 install future pyvirtualdisplay
    && apt-get purge -y --auto-remove \
      gcc \
      g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/requirements.txt \
    # Disabling geckodriver log file
    && sed -i "s#browser = webdriver.Firefox(#browser = webdriver.Firefox(service_log_path=os.devnull,#g" /usr/local/lib/python3.7/site-packages/instapy/browser.py \
    && sed -i "159s#a\[text#button\[text#g" /usr/local/lib/python3.7/site-packages/instapy/xpath_compile.py

CMD ["python", "docker_quickstart.py"]
