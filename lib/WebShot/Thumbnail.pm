package WebShot::Thumbnail;
use Moose;
use Imager;

has 'size' => ( is => 'ro', isa => 'Int', default => '32' );
has 'root' => ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );

sub thumbnail_resultset {
    my ( $self, $rs ) = @_;

    while ( my $item = $rs->next ) {
        $self->thumbnail_item($item);
    }
}

sub thumbnail_item {
    my ( $self, $item ) = @_;
    my $image  = Imager->new;
    my $src    = $self->root->file( 'shots', $item->image );
    my $target = $self->root->file( 'thumbnails', $item->image );

    $image->read( file => $src->stringify ) || die "Cannot read: $src" . $image->errstr;
    my $scaled = $image->scale( xpixels => $self->size ) || die "Cannot scale $src: " . $image->errstr;
    $scaled->write( file => $target->stringify) || die "Cannot write to $target: " . $image->errstr;

    $item->update( { processed => 1 } );
}

__PACKAGE__->meta->make_immutable;
1;
