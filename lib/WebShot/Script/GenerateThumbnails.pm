package WebShot::Script::GenerateThumbnails;
use Moose;
with qw(MooseX::Getopt);
use MooseX::Types::Path::Class;
use WebShot::Schema;
use WebShot::Thumbnail;

has 'root' =>
  ( is => 'ro', isa => 'Path::Class::Dir', coerce => 1, required => 1 );
has 'all' => ( is => 'ro', isa => 'Bool', default => 0 );
has 'schema' => (
    is         => 'ro',
    isa        => 'DBIx::Class::Schema',
    required   => 1,
    lazy_build => 1
);

sub _build_schema {
    my $self = shift;
    return WebShot::Schema->connect(
        "dbi:SQLite:dbname=" . $self->root->file('webshot.db') );
}

sub run {
    my $self = shift;

    my $list = $self->schema->resultset('Website');
    if ( !$self->all ) {
        $list = $list->search( { processed => 0 } );
    }

    my $runner = WebShot::Thumbnail->new(
        root => $self->root->subdir('static')
    );
    $runner->thumbnail_resultset($list);
}

__PACKAGE__->meta->make_immutable;
1;
