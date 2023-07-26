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
    if (/^_______$/ or /^$/) {
        $COG = undef;
        $ORG = undef;
    } elsif (/^\[[A-Z]+\] (COG\d+) .*$/) {
        print "# $_\n";
        $COG = $1;
    } elsif (/^  ([A-Za-z]{3}):  (.+)$/) {
        $ORG = $1;
        print_genes($2);
    } elsif (/^ +(.+)$/) {
        print_genes($1);
    } else {
        die $_;
    }
}

sub print_genes {
    my ($genes) = @_;

    if (not defined $COG or not defined $ORG) {
        die;
    }
    my @genes = split(" ", $genes);
    for my $gene (@genes) {
        print "$COG $ORG:$gene\n";
    }
}

