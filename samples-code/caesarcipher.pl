#!/usr/bin/env perl
use 5.030;
use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case pass_through);

sub main {
    my ($decode, $encode);
    my $key = 3;

    my $options_are_valid = GetOptions(
        "decode=s" => \$decode,
        "encode=s" => \$encode,
        "key=i"    => \$key
    );

    if (!$options_are_valid) {
        print STDERR "Error: invalid options\n";
        return 1;
    }

    if (defined $encode and defined $decode) {
        print STDERR "Error: use either --encode or --decode, not both\n";
        return 1;
    }

    my %number_of_letter = (map { chr(96 + $_) => $_ } 1 .. 26);
    my %letter_of_number = reverse %number_of_letter;

    if (defined $encode) {
        my @tokens;

        for my $character (split //, lc $encode) {
            if (!exists $number_of_letter{$character}) {
                push @tokens, $character;
                next;
            }

            my $position = $number_of_letter{$character} - 1;
            my $shifted  = ($position + $key) % 26 + 1;

            push @tokens, $shifted;
        }

        print join("-", @tokens), "\n";
        return 0;
    }

    if (defined $decode) {
        my @characters;

        for my $token (split /-/, $decode) {
            if ($token !~ /^[0-9]+$/) {
                push @characters, $token;
                next;
            }

            my $position = $token - 1;
            my $shifted  = ($position - $key) % 26 + 1;

            push @characters, $letter_of_number{$shifted};
        }

        print join("", @characters), "\n";
        return 0;
    }

    print <<'USAGE';
Usage: caesar-cipher.pl <option> <string>

Options:
    --encode    string to encode
    --decode    string to decode
    --key       positions to shift the alphabet, defaults to 3
USAGE

    return 1;
}

exit main();
