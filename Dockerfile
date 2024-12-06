FROM        dokken/centos-8
COPY        mongodb-org-4.2.repo /etc/yum.repos.d/mongodb-org-4.2.repo
RUN         yum install -y unzip git jq mysql mongodb-org-shell
RUN         curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip && ./aws/install && rm -rf aws*
COPY        run.sh /tmp/run.sh
ENTRYPOINT  ["bash", "/tmp/run.sh"]