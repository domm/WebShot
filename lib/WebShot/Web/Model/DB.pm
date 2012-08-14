package WebShot::Web::Model::DB;

use strict;
use Moose;
use namespace::autoclean;
extends 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->meta->make_immutable;
1;
