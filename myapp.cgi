#!/usr/bin/perl

use strict;
# Modules
use CGI qw(:standard);
use Sys::Hostname;

my $query= new CGI;
my $msg = $query->param('m');
my $timestamp = localtime(time);
my $host = hostname();

print "Content-type: text/plain\n\n";
print "Hello! This is $host \n";


if(defined($msg)){
print "message is $msg\n";
open(LOGFILE, '>>' ,"/var/log/mylogs/cgilog.txt") or print STDERR "[$0]Cant open log file :( $!";
print LOGFILE "[$timestamp :: $host :: $ENV{'REMOTE_ADDR'}] Message: $msg\n";
close(LOGFILE);
}else{

print "Use param m to persist message to file, like [url]?=hejsan\n";

};

