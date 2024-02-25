package RPW::Spawn;

use strict;
use warnings;


# Spawn a process and read its stdout
sub spawn_read {
    my ($command) = @_;

    my $fh;
    if (!defined(open($fh, "-|", $command))) {
        return [1, ""];
    }

    my $output;
    {
        local $/;
        $output = <$fh>;
    }

    close($fh) || warn "close: $!";
    return [0, $output];
}

# Spawn a process and write to stdin
sub spawn_write {
    my ($command, $input) = @_;
    if (!defined($input)) { $input = ""; }

    my $fh;
    if (!defined(open($fh, "|-", $command))) {
        return 1;
    }

    print $fh $input;

    close($fh) || warn "close: $!";
    return 0;
}

# Escape shell characters by putting them in single quotes
sub escape_shell {
    my ($str) = @_;
    $str =~ s/'/\\''\\'/;
    return "'$str'";
}


our @SYMBOLS = (
    "spawn_read",
    "spawn_write",
    "escape_shell",
);

1;
