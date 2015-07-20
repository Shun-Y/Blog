FROM shuny/yesod-stack

#Install yesod application
RUN mkdir -p /blog
WORKDIR /blog
COPY . ./
RUN stack clean && stack build && stack install
ENV PATH /root/.local/bin:$PATH
# RUN cp .stack-work/dist/x86_64-linux/Cabal-1.18.1.5/build/blog/blog ./
