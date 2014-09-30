#!/usr/bin/env perl
###########################################################################################
#                                                                                         #
# Script     : copy.pl                                                                    #
#                                                                                         #
# Description: This script works in the same way as the linux command 'cp' except that it #
#              skips any '.svn' folders in the destination folder.                        #
#                                                                                         #
# Created by : Per Gröningsson, VNF                                                       #
#                                                                                         #
###########################################################################################

use strict;
use warnings;
use Pod::Usage;

my ($i,$j);
my ($svn,$cmd,$destin,$recursive,$preserve,$skip,$pflag);
my (@input,@source,@svndirs,@flags);

#-----------------------------------------------------------------------------------------

if ($#ARGV < 0) { # if no arguments are given show help text
  pod2usage({-verbose => 2});
}

# Split input for option arguments
$i = 0;
$j = 0;
foreach (@ARGV) {
  if ( !($_=~m/^-/ or $_=~m/^--/) ) { #Check whether argument is an option
    $input[$i] = $_; $i++;
  }
  else {
    $flags[$j] = $_; $j++;
  }
}

# Split source and destination
@source = @input;
$destin = pop @source;

if ($#source > 0 and !(-d $destin) ) { # more than one source folder + destination folder missing  => exit
  $cmd = "\\cp " . join(" ",@ARGV);
  system($cmd);
  exit 1;
}

# Check flags
$recursive = 0;
$preserve = 0;
foreach (@flags) {
  if (lc($_) eq "-r" or "--recursive" =~ /$_/) {# Check if '-r' flag is given
    $recursive = 1;
  }
  if ($_ eq "-p" or "--preserve" =~ /$_/) {# Check if '-p' flag is given
    $preserve = 1;
  }
}


# Search for '.svn' folders at the source directory
$svn = 0;
foreach (@source) {
  $cmd = "\\find $_ -type d -name " . '".svn"';
  @svndirs = `$cmd`;
  if ($#svndirs > -1) {
    $svn = 1;
  }
}

if ($recursive and $svn) {
  print "Source contains ´.svn´ folders. Do you want to skip them [Y/n]? ";
  $skip = <STDIN>;
  chomp $skip; # remove '\n'
  $skip =~ s/^\s+//; # remove leading spaces
  $skip =~ s/\s+$//; # remove trailing spaces

  if (lc($skip) eq "y" or $skip eq "") { # ignore '.svn' folders

    $i = 0;
    foreach (@input) { # remove '/' from folder names
      $_ =~ s/\/+$//;
      $input[$i] = $_; $i++;
    }

    if ($preserve) { # preserve time stamps
      $pflag = "t";
    }
    else {
      $pflag = "";
    }

    if (-d $destin) { # destination folder exists
      $cmd = "\\rsync -a$pflag --exclude='.svn' " . join(" ",@input);
    }
    else {
      $cmd = "\\rsync -a$pflag --exclude='.svn' " . join("/ ",@input);
    }
    system($cmd);
    print "copy: ´.svn´ folders skipped\n"
  }
  elsif ($skip eq "n") {
    $cmd = "\\cp " . join(" ",@ARGV);
    system($cmd); # copy source to destination
  }
  else {
    print "Please enter [Y/n]:\n";
    print "Abort!\n";
  }
}
else {
  $cmd = "\\cp " . join(" ",@ARGV);
  system($cmd); # copy source to destination
}


__END__

=encoding utf8

=head1 NAME

B<copy> - copy files and directories.

=head1 SYNOPSIS

B<copy> [I<OPTIONS>] <SOURCE> <DESTINATION>

=head1 OPTIONS

=over 8

=item B<-r, --recursive>

Copy directories recursively

=item B<-p, --preserve>

Preserve timestamps

=back

=head1 DESCRIPTION

Copy SOURCE to DESTINATION, or multiple SOURCE(s) to DIRECTORY.

Copy works in the same way as the command 'cp' except that the user will be asked if any Subversion
'.svn' folders in the source directory should be skipped.

Note that if '-r' flag is omitted, the command is identical to 'cp'.

=head1 AUTHOR

Written by Per Gröningsson, VNF

=cut
