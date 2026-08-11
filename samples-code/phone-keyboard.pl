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

    my %letters_of_digit = (
        2 => "abc",
        3 => "def",
        4 => "ghi",
        5 => "jkl",
        6 => "mno",
        7 => "pqrs",
        8 => "tuv",
        9 => "wxyz",
        0 => " "
    );

    my %presses_of_letter;

    for my $digit (keys %letters_of_digit) {
        my @letters = split //, $letters_of_digit{$digit};

        for my $position (0 .. $#letters) {
            $presses_of_letter{$letters[$position]} = $digit x ($position + 1);
        }
    }

    my %letter_of_presses = reverse %presses_of_letter;

    if (defined $encode) {
        my @tokens;

        for my $character (split //, lc $encode) {
            if (!exists $presses_of_letter{$character}) {
                push @tokens, $character;
                next;
            }

            push @tokens, $presses_of_letter{$character};
        }

        print join("-", @tokens), "\n";
        return 0;
    }

    if (defined $decode) {
        my @characters;

        for my $token (split /-/, $decode) {
            if (!exists $letter_of_presses{$token}) {
                push @characters, $token;
                next;
            }

            push @characters, $letter_of_presses{$token};
        }

        print join("", @characters), "\n";
        return 0;
    }

    print <<'USAGE';
Usage: phone-keypad.pl <option> <string>

Options:
    --encode    string to encode
    --decode    string to decode
USAGE

    return 1;
}

exit main();
