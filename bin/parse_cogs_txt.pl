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
        print_members($2);
    } elsif (/^ +(.+)$/) {
        print_members($1);
    } else {
        die $_;
    }
}

sub print_members {
    my ($members) = @_;

    if (not defined $COG or not defined $ORG) {
        die;
    }
    my @members = split(" ", $members);
    for my $member (@members) {
        my $gene = $member;
        my $domain = 0;
        if ($member =~ /^(\S+)_(\d)$/) {
            $gene = $1;
            $domain = $2;
        }
        print "$COG\t$ORG:$gene\t$domain\n";
    }
}
