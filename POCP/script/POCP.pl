#!/usr/bin/perl -w
use warnings;
use strict;
use Getopt::Long;
my ($prolen1,$prolen2,$fblast,$sblast,$res);
GetOptions(
	'fpro=s' => \$prolen1,
	'spro=s' => \$prolen2,
	'fbla=s' => \$fblast,
	'sbla=s' => \$sblast,
	'res=s' => \$res,
);

die(&usage()) if (!$prolen1 && !$prolen2 && !$fblast && $sblast);
$res ||="./POCP.result.txt";
sub conserve{
	my ($querylength,$blastfile)=@_;
	my ($con_pro,%query,$total_pro);
	open PL,"$querylength";
	while(<PL>){
		chomp;
		my @arr=split /\t/,;
		$query{$arr[0]}=$arr[1];
	}
	close PL;
	$total_pro=keys(%query);
	my %hit;
	$con_pro=0;
	open BL,"$blastfile";
	while(<BL>){
		chomp;
		my @arr=split /\t/,;
		next unless $arr[2]>40;
		if(exists $query{$arr[0]}){
			next unless $arr[3]/$query{$arr[0]}>0.5;
			next if exists $hit{$arr[0]};
			$hit{$arr[0]}=1;
			$con_pro++;
		}
	}
	close BL;
	return ($con_pro,$total_pro);
}
my ($c1,$t1)=&conserve($prolen1,$fblast);
my ($c2,$t2)=&conserve($prolen2,$sblast);
open RES,">$res";
print RES "Genome1:\nConserved Protein:$c1\nTotal Protein:$t1\nGenome2:\nConserved Protein:$c2\nTotal Protein:$t2\nPOCP:",($c1+$c2)/($t1+$t2)*100,"%\n";
close RES;




