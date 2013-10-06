#!/usr/bin/perl
#
use strict;

my ($dh, $toRoll);
my @files;
my @metaFile;
my $type    = $ARGV[0];
my $numArg  = $#ARGV + 1;
my $CVSWORK = "/home/ec2-user/gitroot";


print "Roll tool 2.0\n\nThis tool allows you to push a program from cvswork directory to its web directory\nUsage: ./rolltool.pl\n" if($type eq '-h');

opendir ($dh, $CVSWORK);
@files = readdir $dh;
closedir $dh;

print "\nAvailable projects:\n";
for(@files) {
	print  $_ . "\n" unless ($_ eq '..' || $_ eq '.');
	if($_ eq $type) {
		auto_roll($type);
	}
}
manual_roll();

sub auto_roll($) {
	my $toRoll = shift();
	for(@files) {
		if( $_  eq $toRoll) {
			my $source = $_;
			print "Attempting to push project " . $_;
			$toRoll =~ s/.com|\]|\[//g;
			open FILE, "<$CVSWORK/$_/meta" or die $!;
			while (<FILE>) {
				@metaFile = split('=', $_);
				if( $metaFile[0] eq 'prod'){
					my $dest = $metaFile[1];
					print "\nCopying from $CVSWORK/$source to $dest\n";
					`cp -r $CVSWORK/$source/* $dest`;
					print "\nSuccessfully Rolled $_";
				}
			}
		}
	}
	print "\n\n";
	exit(0);
}

sub manual_roll {
	print "\n\nEnter project to roll in form of project_name\n";
	$toRoll = <STDIN>;
	chomp($toRoll);

	for(@files) {
		if( $_  eq $toRoll) {
			my $source = $_;
			print "Attempting to push project " . $_;
			$toRoll =~ s/.com|\]|\[//g;
			open FILE, "<$CVSWORK/$_/meta" or die $!;
			$type = 'prod' if($numArg ==0);
			while (<FILE>) {
				@metaFile = split('=', $_);
					if( $metaFile[0] eq $type){
						my $dest = $metaFile[1];
						print "\nCopying from $CVSWORK/$source to $dest\n";
						`cp -r $CVSWORK/$source/* $dest`;
						print "\nSuccessfully Rolled $_";
					}
			}
		}
	print "\n\n";
	}
}
	
