package RPW::HTML;

use strict;
use warnings;

use RPW::Text;

# Element with attributes
sub ea {
    my ($tag, $attributes_hashref, $content) = @_;

    # attributes hash to text
    my $attributes_txt = "";
    if (defined($attributes_hashref)) {
        my %attributes = %{$attributes_hashref};

        for my $attr (keys %attributes) {
            my $val = $attributes{$attr};

            if (!defined($val)) {
                $attributes_txt = $attributes_txt . " $attr";
                next;
            }

            $val =~ s/"/\\"/g;
            $attributes_txt = $attributes_txt . " $attr=\"$val\"";
        }
    }

    if (!defined($content)) {
        return "<$tag$attributes_txt/>";
    }
    return "<$tag$attributes_txt>$content</$tag>";
}

# Element without attributes
sub e {
    my ($tag, $content) = @_;
    return ea($tag, undef, $content);
}

# Set current page title via JS
sub set_title_script {
    my ($title) = @_;
    $title = escape_html_special($title);

    my $code = "
        // Add title element if missing
        if (document.querySelector(\"head > title\") === null) {
            let t = document.createElement(\"title\");
            document.head.appendChild(t);
        }

        // Set title content
        document.querySelector(\"head > title\").innerHTML = '$title';

        // Remove this script tag
        let me = document.querySelector(\"#set-title-script\");
        me.parentElement.removeChild(me);
    ";

    return ea(
        "script", {
            "id" => "set-title-script",
            "type" => "text/javascript",
        }, $code
    );
}

# Margins from div elements (they don't collapse in scroll containers)
sub div_margins {
    my ($left_classes, $top_classes, $right_classes, $bottom_classes, $content) = @_;

    my $fix_subref = sub {
        my ($s) = @_;

        if (defined($s)) {
            $s = " " . $s;
        } else {
            $s = "";
        }

        return $s;
    };

    $left_classes   = &$fix_subref($left_classes);
    $top_classes    = &$fix_subref($top_classes);
    $right_classes  = &$fix_subref($right_classes);
    $bottom_classes = &$fix_subref($bottom_classes);

    return ea(
        "div", {
            "class" => "div-margin-horizontal-container",
        }, ea(
            "div", {
                "class" => "div-margin-horizontal$left_classes",
            }, ""
        ) . ea(
            "div", {
                "class" => "div-margin-vertical-container",
            }, ea(
                "div", {
                    "class" => "div-margin-vertical$top_classes",
                }, ""
            ) . ea(
                "div", {
                    "class" => "div-margin-content",
                },
                $content
            ) . ea(
                "div", {
                    "class" => "div-margin-vertical$bottom_classes",
                }, ""
            )
        ) . ea(
            "div", {
                "class" => "div-margin-horizontal$right_classes",
            }, ""
        )
    );
}

our $br = e("br", undef);

1;
