FROM varnish:stable

run apt update
run apt-get install -y build-essential libtool autoconf git varnish-dev docutils-common curl wget

