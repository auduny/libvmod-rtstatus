=============
vmod_rtstatus
=============


.. image:: https://secure.travis-ci.org/aondio/libvmod-rtstatus.png
   :alt: Travis CI badge
   :target: http://travis-ci.org/aondio/libvmod-rtstatus


-------------------------------
Varnish Real-Time Status Module
-------------------------------

:Author: Arianna Aondio
:Date: 2014-07-03
:Version: 1.0

SYNOPSIS
========

import rtstatus;

DESCRIPTION
===========

A vmod that lets you query your Varnish server for a JSON or Prometheus 
output of the internal varnish counters. With the accompanied VCL code,

visiting the URL /rtstatus.json on the Varnish server will produce an
application/json response of the following format::

    {
	"Timestamp" : "Thu, 24 Jul 2014 10:27:10 GMT",
	"Varnish_Version" : "varnish-3.0.5 revision 8213a0b",
	"Backend": {"name":"default", "value": "healthy"},
	"Director": {"name":"simple", "vcl_name":"default"},
	
	"client_conn": {"descr": "Client connections accepted", "value": "1},
	"LCK.cli.locks": {type": "LCK", "ident": "cli", "descr": "Lock Operations", "value": "15},
	"VBE.default(127.0.0.1,,8080).happy": {type": "VBE", "ident": "default(127.0.0.1,,8080)", "descr": "Happy health probes", "value": "0},
    }

FUNCTIONS
=========

rtstatus
--------

Prototype::

         rtstatus( )

Return value
	STRING

INSTALLATION
============
The source tree is based on autotools to configure the building, and
does also have the necessary bits in place to do functional unit tests
using the varnishtest tool.

Usage::

 ./configure VARNISHSRC=DIR [VMODDIR=DIR]

`VARNISHSRC` is the directory of the Varnish source tree for which to
compile your vmod. Both the `VARNISHSRC` and `VARNISHSRC/include`
will be added to the include search paths for your module.

Optionally you can also set the vmod install directory by adding
`VMODDIR=DIR` (defaults to the pkg-config discovered directory from your
Varnish installation).

Make targets:

* make - builds the vmod
* make install - installs your vmod in `VMODDIR`
* make check - runs the unit tests in ``src/tests/*.vtc``

In your VCL you could then use this vmod along the following lines::

    import rtstatus;

    sub vcl_recv {
        if (req.url == "/rtstatus.json" || req.url == "/rtstatus.html") {
            return (synth(200));
        }
        if (req.url == "/metrics") {
            return (synth(200));
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



COPYRIGHT
=========

This document is licensed under the same license as the
libvmod-rtstatus project. See LICENSE for details.

* Copyright (c) 2014 Varnish Software
