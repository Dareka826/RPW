package RPW;

use strict;
use warnings;

use File::Basename;
use lib dirname(__FILE__) . "/ModYoink";

use ModYoink;

use RPW::Spawn;
use RPW::Text;
use RPW::HTTP;
use RPW::HTML;

ModYoink::yoink_symbols("RPW", "RPW::Spawn");
ModYoink::yoink_symbols("RPW", "RPW::Text");
ModYoink::yoink_symbols("RPW", "RPW::HTTP");
ModYoink::yoink_symbols("RPW", "RPW::HTML");

1;
