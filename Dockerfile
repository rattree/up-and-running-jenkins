#FROM  centos:8
FROM centos:7
LABEL maintainer="rukender" \
      description="The Lacework CLI helps you manage the Lacework cloud security platform"

#RUN yum update -y
COPY ./LICENSE /
RUN curl https://raw.githubusercontent.com/lacework/go-sdk/master/cli/install.sh | bash
