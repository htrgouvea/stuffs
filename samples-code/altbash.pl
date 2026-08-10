#!/usr/bin/env perl
use 5.030;
use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case pass_through);

sub main {
    my ($decode, $encode);

    GetOptions(
        "decode=s" => \$decode,
        "encode=s" => \$encode
    );

    my %number_of_letter = (map { chr(96 + $_) => $_ } 1 .. 26);
    $number_of_letter{" "} = " ";

    my %letter_of_number = reverse %number_of_letter;

    if (defined $encode and defined $decode) {
        print STDERR "Error: use either --encode or --decode, not both\n";
        return 1;
    }

    if (defined $encode) {
        my @tokens;

        for my $character (split //, lc $encode) {
            my $token = $character;

            if (exists $number_of_letter{$character}) {
                $token = $number_of_letter{$character};
            }

            push @tokens, $token;
        }

        print join("-", @tokens), "\n";
        return 0;
    }

    if (defined $decode) {
        my @characters;

        for my $token (split /-/, $decode) {
            my $character = $token;

            if (exists $letter_of_number{$token}) {
                $character = $letter_of_number{$token};
            }

            push @characters, $character;
        }

        print join("", @characters), "\n";
        return 0;
    }

    print <<'USAGE';
Usage: altbash.pl <option> <string>

Options:
    --encode    string to encode
    --decode    string to decode
USAGE

    return 1;
}

exit main();
