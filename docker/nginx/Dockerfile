FROM nginx:alpine

RUN apk --update add openssl openssl-dev python3 python3-dev py3-pip libffi-dev gcc musl-dev curl \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y  \
    && source /root/.cargo/env \
    && pip3 install --upgrade pip setuptools wheel \
    && pip3 install --upgrade pycparser cffi dns-lexicon certbot certbot-dns-sakuracloud \
    && rustup self uninstall -y \
    && rm -rf /var/cache/apk/* \
    && rm -rf /root/.cache

ADD ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./docker/nginx/fastcgi.conf /etc/nginx/fastcgi.conf
ADD ./docker/nginx/server.conf /etc/nginx/conf.d/default.conf

ADD ./docker/nginx/dummy_server.crt /root/dummy_server.crt
ADD ./docker/nginx/dummy_server.csr /root/dummy_server.csr
ADD ./docker/nginx/dummy_server.key /root/dummy_server.key

RUN ln -nfs /root/dummy_server.crt /etc/nginx/server.crt \
    && ln -nfs /root/dummy_server.key /etc/nginx/server.key

ADD ./docker/nginx/startup.sh /root/startup.sh
RUN sed -i 's/\r//' /root/startup.sh