#!/usr/bin/perl -w
use strict;
use File::Basename;
use Getopt::Std;
my $PROGRAM = basename $0;
my $USAGE=
"Usage: cat GENE_LIST | $PROGRAM domain.fa > gene.fa
";

my %OPT;
getopts('', \%OPT);

if (!@ARGV) {
    print STDERR $USAGE;
    exit 1;
}
my ($FASTA) = @ARGV;

open(FASTA, "$FASTA") || die "$!";
my $GENE;
my $DOMAIN;
my %HASH;
while (<FASTA>) {
    chomp;
    if (/^>(\S+)_(\d)$/) {
        ($GENE, $DOMAIN) = ($1, $2);
    } elsif (/^>(\S+)$/) {
        ($GENE, $DOMAIN) = ($1, 1);
    } else {
        update_hash($GENE, $DOMAIN, $_);
    }
}
close(FASTA);

while (<STDIN>) {
    chomp;
    if (/^[A-Za-z]{3}:(\S+)/) {
        my $gene = $1;
        if ($HASH{$gene}) {
            print ">$_\n";
            print_seq($gene);
        } else {
            die;
        }
    }
    
}

################################################################################
### Function ###################################################################
################################################################################

sub update_hash {
    my ($gene, $domain, $seq) = @_;

    if ($HASH{$gene}{$domain}) {
        $HASH{$gene}{$domain} .= $seq;
    } else {
        $HASH{$gene}{$domain} = $seq;
    }
}

sub print_seq {
    my ($gene) = @_;

    my $seq = "";
    for my $domain (sort {$a <=> $b} keys(%{$HASH{$gene}})) {
        $seq .= $HASH{$gene}{$domain};
    }

    # new line every 70 characters
    $seq =~ s/(.{70})/$1\n/g;
    print "$seq\n";
}
