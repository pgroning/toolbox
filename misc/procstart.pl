#!/usr/bin/perl

use strict;
use warnings;
use POSIX qw(strftime);

my $pid = shift;
my $ftime = (stat("/proc/$pid/status"))[9];
my $timestr = strftime "%a %b %e %H:%M:%S %Y", localtime($ftime);

print $timestr,"\n";
