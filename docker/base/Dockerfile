FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y wget

RUN echo "deb http://huttenhower.sph.harvard.edu/biobakery-shop/deb-packages / " >> /etc/apt/sources.list
RUN wget -O- "http://huttenhower.sph.harvard.edu/biobakery-shop/deb-packages/biobakery.asc" | apt-key add -
RUN apt-get update


