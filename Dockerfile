FROM shuny/yesod-stack

#Install yesod application
RUN mkdir -p /blog
WORKDIR /blog
COPY . ./
RUN stack build
ENV PATH /root/.local/bin:$PATH
