use utf8;
package WebShot::Schema::Result::Website;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';
__PACKAGE__->load_components("TimeStamp", "InflateColumn::DateTime", "PK");
__PACKAGE__->table("website");
__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "url",
  { data_type => "text", is_nullable => 0 },
  "image",
  { data_type => "text", is_nullable => 1 },
  "processed",
  { data_type => "int", default_value => 0, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("url_unique", ["url"]);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-08-14 23:48:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:KF+c88kXvoiWWnqrAueSGA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
