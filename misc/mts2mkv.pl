#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use POSIX;
#use File::Copy;

my ($url, $ifolder, $ifile, $ofolder, $ofile, $eofile);
my (@ofile_array, @eofile_array);

#$ifolder = "$ENV{'HOME'}/Videos/AVCHD/BDMV/STREAM";
$ifolder = "/media/$ENV{'USER'}/CAM_SD/PRIVATE/AVCHD/BDMV/STREAM";
$ofolder = "$ENV{'HOME'}/Videos/camcorder";
print $ifolder;

#Create output folders
mkdir($ofolder) unless(-d $ofolder);
my $eofolder = $ofolder . "/" . "encode";
mkdir($eofolder) unless(-d $eofolder);


opendir (DIR, $ifolder) or die $!;

while (my $file = readdir(DIR)) {
    next if !($file =~ m/.?\.MTS$/);
    print $file,"\n";
    $ifile =  $ifolder ."/". $file;

    my $date = POSIX::strftime( 
	"%Y%m%d_%H%M%S", 
	localtime( 
	    ( stat $ifile )[9]
	)
	);

    $ofile = $ofolder ."/". $date . ".mkv";
    $eofile = $eofolder ."/". $date . ".mkv";
    push(@ofile_array,$ofile);
    push(@eofile_array,$eofile);
    #my $eofile = $ofolder ."/". "encode" ."/". $date . ".mkv";

# Change container from mts to mkv:
    system("mkvmerge $ifile -o $ofile 1>/dev/null 2>&1");
# Modify timestamp of file:
    system("touch -r $ifile $ofile");
    print "File exported to $ofile\n";
}

my $i = 0;
foreach (@ofile_array) {

    $ofile = $ofile_array[$i];
    $eofile = $eofile_array[$i];
    $i++;

# Lossy encoding. horizontal max pixels=720, audio passthrough, subtitle passthrough:
#    system("HandBrakeCLI -i $ofile -o $eofile -e x264 -q 20 -E copy -Y 720 -s 1 --subtitle-default 1>/dev/null 2>&1");
    print "Encoding file\n";
    system("avconv -i $ofile -s hd720 -map 0 -c:v libx264 -crf 21 -pre:v slow -c:a copy -c:s copy $eofile 1>/dev/null 2>&1");
# Modify timestamp of file:
    system("touch -r $ofile $eofile");
    print "Encoded file saved as $eofile\n";
}
