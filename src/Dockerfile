FROM ubuntu
MAINTAINER Docker <harleyxiao@foxmail.com>
#RUN apt update
#RUN apt install g++
RUN mkdir /root/myapp/
COPY *.cpp /root/myapp/
COPY *.h /root/myapp/
WORKDIR /root/myapp/
RUN frolvlad/alpine-gcc:g++ --std=c++11 *.cpp *.h -o SolidityCheck
CMD ["./SolidityCheck"]
