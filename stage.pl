#!/usr/bin/perl
#
use strict;

my ($dh, $toRoll);
my @files;

print "Stage tool\n\nThis tool allows you to push a program from cvswork directory to its stage directory. Point to metafile and will quickly push to stage.\nUsage: ./stage.pl [metafile]\n";

opendir ($dh, "cvswork");
@files = readdir $dh;
closedir $dh;

for(@files) {
	print "[" . $_ . "]\n" unless ($_ eq '..' || $_ eq '.');
}

print "\n\nEnter project to roll in form of [project_name]\n";
$toRoll = <>;
chomp($toRoll);

for(@files) {
	if("[" . $_ . "]" eq $toRoll) {
		print "Attempting to push project " . $_;
		$toRoll =~ s/.com|\]|\[//g;
		print "\nCopying from ./cvswork/$_ to /home/$toRoll/public_html\n";
		`cp -r cvswork/$_/* /home/$toRoll/public_html/`;
		print "\nSuccessfully Rolled $_";
	}
}
	
print "\n\n";
