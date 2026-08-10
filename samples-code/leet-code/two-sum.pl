#!/usr/bin/env perl

use strict;
use warnings;

sub main {
    my @numbers = (3, 2, 4);
    my $target  = 6;

    my %index_of_seen_number;
    my @indices;

    for my $index (0 .. $#numbers) {
        my $current    = $numbers[$index];
        my $complement = $target - $current;

        if (exists $index_of_seen_number{$complement}) {
            @indices = ($index_of_seen_number{$complement}, $index);
            last;
        }

        $index_of_seen_number{$current} = $index;
    }

    if (!@indices) {
        print "no solution\n";
        return 0;
    }

    print "[" . join(", ", @indices) . "]\n";

    return 0;
}

exit main();
