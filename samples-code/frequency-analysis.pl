#!/usr/bin/env perl

use 5.030;
use strict;
use warnings;

sub main {
    my $text = join(" ", @ARGV);

    if (!length $text) {
        print "Usage: frequency-analysis.pl <string>\n";
        return 1;
    }

    my %count_of_letter;
    my $total_letters = 0;

    for my $character (split //, lc $text) {
        if ($character !~ /^[a-z]$/) {
            next;
        }

        $count_of_letter{$character}++;
        $total_letters++;
    }

    if (!$total_letters) {
        print "No letters found\n";
        return 1;
    }

    my @letters_by_frequency = sort {
        $count_of_letter{$b} <=> $count_of_letter{$a} or $a cmp $b
    } keys %count_of_letter;

    for my $letter (@letters_by_frequency) {
        my $count      = $count_of_letter{$letter};
        my $percentage = 100 * $count / $total_letters;

        printf "%s  %4d  %5.1f%%\n", $letter, $count, $percentage;
    }

    return 0;
}

exit main();
