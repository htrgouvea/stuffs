#!/usr/bin/env perl

use 5.030;
use strict;
use warnings;
use open qw(:std :encoding(UTF-8));
use Encode qw(decode_utf8);
use Getopt::Long qw(:config no_ignore_case pass_through);

sub main {
    my $reverse_words = 0;

    my $options_are_valid = GetOptions(
        "words" => \$reverse_words
    );

    if (!$options_are_valid) {
        print STDERR "Error: invalid options\n";
        return 1;
    }

    my $text = decode_utf8(join(" ", @ARGV));

    if (!length $text) {
        print "Usage: reverse-text.pl [--words] <string>\n";
        return 1;
    }

    if ($reverse_words) {
        my @words = reverse split /\s+/, $text;

        print join(" ", @words), "\n";
        return 0;
    }

    print scalar reverse($text), "\n";

    return 0;
}

exit main();
