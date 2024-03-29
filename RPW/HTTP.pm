package RPW::HTTP;

use strict;
use warnings;


use RPW::Text;

our $NL = "\r\n";

sub parse_url_params {
    my ($path) = @_;

    if (index($path, "?") == -1) { return {}; }

    $path =~ s/^[^?]*\?//;
    my @params_arr = split(quotemeta("&"), $path);

    my %params;
    for my $param (@params_arr) {
        my ($key, $val) = split("=", $param, 2);
        $params{$key} = RPW::Text::uri_decode($val);
    }

    return \%params;
}

sub allowed_methods {
    my ($arrref_methods) = @_;
    my @methods = @{$arrref_methods};
    my $env_method = $ENV{"REQUEST_METHOD"};

    for my $method (@methods) {
        if ($method eq $env_method) {
            return;
        }
    }
    exit(1);
}

sub print_headers {
    my ($headers_hashref) = @_;
    if (!defined($headers_hashref)) { return; }

    my %headers = %{$headers_hashref};
    for my $key (keys %headers) {
        my $val = $headers{$key};

        RPW::Text::printl("$key: $val");
    }
    RPW::Text::printl();
}


our @SYMBOLS = (
    "parse_url_params",
    "allowed_methods",
    "print_headers",
    "NL",
);

1;
