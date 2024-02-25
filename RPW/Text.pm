package RPW::Text;

use strict;
use warnings;


# Print args and a newline
sub printl {
    my $ok = 1;

    for my $arg (@_) {
        $ok = $ok && print($arg);
    }

    return $ok && print("\n");
}

# Escape chars that have special meaning in HTML
sub escape_html_special {
    my ($str, $spc) = @_;
    if (!defined($spc)) { $spc = 0; }

    $str =~ s/&/\&#38;/g;
    $str =~ s/"/\&#34;/g;
    $str =~ s/'/\&#39;/g;
    $str =~ s/</\&#60;/g;
    $str =~ s/>/\&#62;/g;

    if ($spc == 1) {
        $str =~ s/ /\&nbsp;/;
    }

    return $str;
}

# Decode URI
sub uri_decode {
    my ($str) = @_;

    my $idx = 0;
    my $len = length($str);

    while ($idx < $len) {
        if (substr($str, $idx, 1) eq "%") {
            if ($idx + 2 >= $len) {
                die "URI encoding invalid";
            }

            my $code = substr($str, $idx+1, 2);
            my $c = chr(hex($code));

            $str = substr($str, 0, $idx) . $c . substr($str, $idx+3);
            $len = length($str);
        }

        $idx += 1;
    }

    return $str;
}

# Encode URI
sub uri_encode {
    my ($str) = @_;

    my $valid_chr_subref = sub {
        my ($c) = @_;
        my $cc = ord($c);

        if ($cc >= ord('a') and $cc <= ord('z')) {
            return 1;
        } elsif ($cc >= ord('A') and $cc <= ord('Z')) {
            return 1;
        } elsif ($cc >= ord('0') and $cc <= ord('9')) {
            return 1;
        } else {
            for my $cmp (@{[ "_", "-", ":", ",", ";", "+", "#", "." ]}) {
                if ($cc eq $cmp) {
                    return 1;
                }
            }
        }

        return 0;
    };

    my $idx = 0;
    my $len = length($str);

    while ($idx < $len) {
        if (&$valid_chr_subref(substr($str, $idx, 1)) == 0) {
            my $c = substr($str, $idx, 1);
            my $cc = sprintf("%%%02x", ord($c));

            $str = substr($str, 0, $idx) . $cc . substr($str, $idx+1);
            $len = length($str);

            $idx += 2;
        }

        $idx += 1;
    }

    return $str;
}


our @SYMBOLS = (
    "printl",
    "escape_html_special",
    "uri_decode",
    "uri_encode",
);

1;
