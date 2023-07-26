#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: $PROGRAM [COGs.txt]
";

my %OPT;
getopts('', \%OPT);

my $COG;
my $ORG;
while (<>) {
    chomp;
    if (/^_______$/) {
    } elsif (/^$/) {
    } elsif (/^\[[A-Z]\] (COG\d+) .*$/) {
        print "# $_\n";
        $COG = $1;
    } elsif (/  ([A-Za-z]{3}):  (.+)$/) {
        $ORG = $1;
        my $genes = $2;
        print_genes($genes);
    } elsif (/ +(.+)$/) {
        my $genes = $1;
        print_genes($genes);
    } else {
        die;
    }
}

sub print_genes {
    my ($genes) = @_;

    unless (defined $COG) {
        die;
    }
    unless (defined $ORG) {
        die;
    }
    my @genes = split(" ", $genes);
    for my $gene (@genes) {
        print "$COG $ORG:$gene\n";
    }
}

