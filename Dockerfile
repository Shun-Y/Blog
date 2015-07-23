FROM blog_web:latest

#build new image
COPY . ./
RUN stack clean && stack build && stack install
ENV PATH /root/.local/bin:$PATH
# VOLUME /blog
