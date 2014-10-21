#!/usr/bin/perl

use strict;
use warnings;

my $pid = shift;

my $pstart = `ls -l /proc/$pid/status | awk '{print \$6,\$7,\$8}'`;
$pstart =~ s/\n//;
print $pstart,"\n";

