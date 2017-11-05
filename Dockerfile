FROM debian:jessie

# Install pygments (for syntax highlighting)
RUN apt-get -qq update \
    && DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends python-pygments git-core unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install hugo
ENV HUGO_VERSION 0.30.2
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit

ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}.tar.gz /usr/local/
RUN tar xzf /usr/local/${HUGO_BINARY}.tar.gz -C /tmp/ \
    && cp /tmp/hugo /usr/local/bin/hugo \
    && rm /usr/local/${HUGO_BINARY}.tar.gz

# Create working directory
RUN mkdir /usr/share/blog
ADD https://github.com/soifou/hugo-test/archive/master.zip /tmp/
RUN unzip /tmp/master.zip -d /usr/share/blog/ && rm /tmp/master.zip
WORKDIR /usr/share/blog/hugo-test-master

# Expose default hugo port
EXPOSE 1313

# Automatically build site
ONBUILD ADD . /usr/share/blog/hugo-test-master

# By default, serve site
ENV HUGO_BASE_URL http://www.francois-fleur.fr
CMD /usr/local/bin/hugo server -s /usr/share/blog/hugo-test-master --baseUrl=${HUGO_BASE_URL} --watch --appendPort=false --bind=0.0.0.0