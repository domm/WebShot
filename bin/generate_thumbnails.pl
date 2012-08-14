#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use FindBin;
use lib "$FindBin::Bin/../lib";

use WebShot::Script::GenerateThumbnails;
WebShot::Script::GenerateThumbnails->new_with_options->run;

