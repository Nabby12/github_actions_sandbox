FROM python:3.9

RUN apt-get update 1> /dev/null && apt-get install -y less vim curl unzip sudo 1> /dev/null

# aws cli v2 install
# https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/install-cliv2-linux.html
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" 1> /dev/null
RUN unzip awscliv2.zip 1> /dev/null
RUN sudo ./aws/install 1> /dev/null

# jq install
RUN sudo apt -y install jq 1> /dev/null

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
