FROM gcs:halley

RUN cp -R /opt/gcs/makefiles /work/gcsop/ 

ADD --chown=gcsop:control data/fastdds.mk /work/gcsop/makefiles
ADD --chown=gcsop:control data/gcs.mk /work/gcsop/makefiles

ADD --chown=gcsadm:control  ext/yamlcpp_0.7.0 /opt/gcs/ext/yamlcpp_0.7.0
ADD --chown=gcsadm:control  ext/rabbitmq_c_0.11.0 /opt/gcs/ext/rabbitmq_c_0.11.0/

ADD --chown=gcsadm:control  makefiles/rabbitmqconfig.mk /opt/gcs/makefiles/rabbitmqconfig.mk
ADD --chown=gcsadm:control  makefiles/yamlcppconfig.mk /opt/gcs/makefiles/yamlcppconfig.mk

COPY patches/* /root/

RUN patch /opt/gcs/tools/nrp /root/nrp.patch
RUN patch /opt/gcs/makefiles/gcs.mk /root/gcs.mk.patch
RUN patch /opt/gcs/tools/functions/fnmk.cpp.module /root/fnmk.cpp.module.patch

RUN mkdir -p /work/gcsop/src_java/gtc/AL/Service/MonitorManager && mkdir -p /work/gcsop/src_c++/gtc/DSL && mkdir -p /work/gcsop/src_c++/gtc/DSL/CK
 
ADD --chown=gcsop:control  modules/service /work/gcsop/src_java/gtc/AL/Service/MonitorManager/service
ADD --chown=gcsop:control  modules/DCF /work/gcsop/src_c++/gtc/DSL/CK/DCF
ADD --chown=gcsop:control  modules/Server_Kit /work/gcsop/src_c++/gtc/DSL/Server_Kit
ADD --chown=gcsop:control  modules/DAF /work/gcsop/src_c++/gtc/DSL/DAF

RUN patch /work/gcsop/src_c++/gtc/DSL/DAF/DAF.l/CORBAContext.cpp /root/CORBAContext.patch


USER gcsop
ENV LOGNAME gcsop
ADD list /home/gcsop
RUN /opt/gcs/tools/nrp -p linux -s bash -X /opt/gcs/tools/nmk -l /home/gcsop/list

USER root
RUN yum -y install centos-release-scl 
RUN yum -y install devtoolset-8-gcc devtoolset-8-gcc-c++ cmake3 asio-devel tinyxml2-devel && yum clean all

SHELL [ "/usr/bin/scl", "enable", "devtoolset-8" ]
RUN gcc --version 

RUN mkdir /opt/fastdds_ws && cd /opt/fastdds_ws && git clone https://github.com/eProsima/Fast-CDR.git && mkdir Fast-CDR/build && cd Fast-CDR/build && cmake3 .. && make && make install
RUN cd /opt/fastdds_ws && git clone https://github.com/eProsima/foonathan_memory_vendor.git && mkdir foonathan_memory_vendor/build && cd foonathan_memory_vendor/build && cmake3 .. && make && make install
RUN cd /opt/fastdds_ws && git clone https://github.com/eProsima/Fast-DDS.git && mkdir Fast-DDS/build && cd Fast-DDS/build && cmake3 .. && make && make install
RUN cd /opt/fastdds_ws && git clone --recursive https://github.com/eProsima/Fast-DDS-Gen.git 

ADD --chown=gcsop:control  modules/DGCSTypesFastDDS /work/gcsop/src_c++/gtc/DGCSTypesFastDDS
ADD --chown=gcsop:control  modules/MonitorManagerIntegrationService /work/gcsop/src_c++/gtc/MonitorManagerIntegrationService

USER gcsop
ENV LOGNAME gcsop
ADD list.plus /home/gcsop

RUN /opt/gcs/tools/nrp -p linux -s bash -X /opt/gcs/tools/nmk -l /home/gcsop/list.plus



RUN mkdir /work/gcsop/etc/config/MonitorManagerIntegrationService && cp /work/gcsop/src_c++/gtc/MonitorManagerIntegrationService/MonitorManagerIntegrationService/profiles/MonitorManagerIntegrationService.profile /work/gcsop/etc/profiles/MonitorManagerIntegrationService.profile 

ADD --chown=gcsop:control  modules/MonitorManagerIntegrationService/TelemetryList.yml /work/gcsop/etc/config/MonitorManagerIntegrationService

ADD --chown=gcsop:control  etc/global.cfg /work/gcsop/etc/global.cfg


CMD ["/bin/bash", "-c", "/opt/gcs/tools/nrp -p linux -s bash -f /work/gcsop/etc/global.cfg -X /work/gcsop/src_c++/gtc/MonitorManagerIntegrationService/MonitorManagerIntegrationService/examples/runMonitorManagerIntegrationService.p/linux.O/runMonitorManagerIntegrationService -update"]









