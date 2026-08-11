#!/usr/bin/env perl

use 5.030;
use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case pass_through);

sub main {
    my ($decode, $encode);

    my $options_are_valid = GetOptions(
        "decode=s" => \$decode,
        "encode=s" => \$encode
    );

    if (!$options_are_valid) {
        print STDERR "Error: invalid options\n";
        return 1;
    }

    if (defined $encode and defined $decode) {
        print STDERR "Error: use either --encode or --decode, not both\n";
        return 1;
    }

    my $alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    if (defined $encode) {
        my $bits = unpack("B*", $encode);
        my $missing_bits = (6 - length($bits) % 6) % 6;

        $bits .= "0" x $missing_bits;

        my @characters;

        while (length $bits) {
            my $chunk = substr($bits, 0, 6, "");

            push @characters, substr($alphabet, oct("0b$chunk"), 1);
        }

        my $encoded = join("", @characters);
        my $missing_characters = (4 - length($encoded) % 4) % 4;

        print $encoded, "=" x $missing_characters, "\n";
        return 0;
    }

    if (defined $decode) {
        my $encoded = $decode;

        $encoded =~ s/\s+//g;
        $encoded =~ s/=+$//;

        my $bits = "";

        for my $character (split //, $encoded) {
            my $value = index($alphabet, $character);

            if ($value < 0) {
                print STDERR "Error: invalid base64 character '$character'\n";
                return 1;
            }

            $bits .= sprintf("%06b", $value);
        }

        my $usable_length = length($bits) - length($bits) % 8;

        print pack("B*", substr($bits, 0, $usable_length)), "\n";
        return 0;
    }

    print <<'USAGE';
Usage: base64.pl <option> <string>

Options:
    --encode    string to encode
    --decode    string to decode
USAGE

    return 1;
}

exit main();
