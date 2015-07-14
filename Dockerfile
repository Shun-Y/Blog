FROM fpco/stack-build

#Install yesod application
RUN cabal update
RUN stack install yesod-bin cabal-install --install-ghc
RUN apt-get install libpq-dev
RUN mkdir -p /blog
WORKDIR /blog
COPY . ./
RUN stack build
