#!/usr/bin/perl -w

use warnings;
use strict;

open QR,"$ARGV[0]";
while(<QR>){
	chomp(my $line=$_);
	$line=~s/>//;
	$line=~/([\w\-|\.]+)\s+/;
	my $title = $1;
	$/=">";
	chomp(my $seq=<QR>);
	$seq=~s/\s+//g;
	my $len=length($seq);
	print "$title\t$len\n";
	$/="\n";
}
close QR;
