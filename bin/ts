#!/usr/bin/perl
use POSIX qw/strftime/;
while (<STDIN>) { s/(\d{10})/strftime("[[%a %b %d %Y %H:%M:%S]]",localtime($1))/eg; print }
