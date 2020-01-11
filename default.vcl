#
# This is an example VCL file for Varnish.
#
# It does not do anything by default, delegating control to the
# builtin VCL. The builtin VCL is called when there is no explicit
# return statement.
#
# See the VCL chapters in the Users Guide for a comprehensive documentation
# at https://www.varnish-cache.org/docs/.

# Marker to tell the VCL compiler that this VCL has been written with the
# 4.0 or 4.1 syntax.
vcl 4.1;

import std;
import rtstatus;
import directors;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "127.0.0.1";
    .port = "8080";
}

backend backend_2 {
    .host = "127.0.0.1";
    .port = "8081";
}

backend backend_3 {
    .host = "195.88.55.16";
    .port = "80";
}

sub vcl_init {
    new director_1 = directors.round_robin();
    director_1.add_backend(backend_2);
    director_1.add_backend(backend_3);
}

sub vcl_backend_response {
    # Happens after we have read the response headers from the backend.
    #
    # Here you clean the response headers, removing silly Set-Cookie headers
    # and other mistakes your backend does.
}

sub vcl_deliver {
    # Happens when we have all the pieces we need, and are about to send the
    # response to the client.
    #
    # You can do accounting or modifying the final object here.
}
sub vcl_recv {
    if (req.url == "/rtstatus.json" || req.url == "/rtstatus.html") {
        return (synth(200));
    }
    if (req.url == "/metrics") {
        return (synth(200));
    }
    if (req.url == "/testurl") {
        set req.backend_hint = director_1.backend();
    }
}

sub vcl_synth {
    if (req.url == "/rtstatus.json") {
	    rtstatus.synthetic_json();
	    return (deliver);
    }
    if (req.url == "/metrics") {
	    rtstatus.synthetic_prom();
	    return (deliver);
    }
    if (req.url == "/rtstatus.html") {
	    rtstatus.synthetic_html();
	    return (deliver);
    }
}
