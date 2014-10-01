#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my ($infile, $outfile, $srtfile);

# Read the options
GetOptions('infile=s'                  => \$infile,
	   'outfile=s'                 => \$outfile,
	   'srtfile=s'                 => \$srtfile
	  );

# Find charset or .srt file
my $tline = `file -bi $srtfile`;
my @tarr = split("=",$tline);
my $charset = $tarr[1];
$charset =~ s/\s$//;
print "Identified character set to $charset\n";

if (!($charset eq "utf-8")) {
  system("iconv -f $charset -t UTF-8 $srtfile -o utf8.txt");
  print "Converted .srt file to utf-8\n";
}

system("nice -n10 mkvmerge -o $outfile $infile --language \"0:swe\" --track-name \"0:Svensk text\" -s 0 -D -A utf8.txt --sub-charset \"0:UTF8\"");
print ".srt file added to $outfile\n";
