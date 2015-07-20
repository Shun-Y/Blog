FROM shuny/yesod-stack

#Install yesod application
RUN mkdir -p /blog
WORKDIR /blog
COPY . ./
RUN stack clean && stack build && stack install
ENV PATH /root/.local/bin:$PATH
