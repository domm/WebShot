package WebShot::Thumbnail;
use Moose;
use Imager;
use Log::Any qw($log);
use Try::Tiny;

has 'size' => ( is => 'ro', isa => 'Int', default => '32' );
has 'root' => ( is => 'ro', isa => 'Path::Class::Dir', required => 1 );

sub thumbnail_resultset {
    my ( $self, $rs ) = @_;

    $log->infof( "Starting to thumbnail %i images", $rs->count );
    while ( my $item = $rs->next ) {
        $self->thumbnail_item($item);
    }
}

sub thumbnail_item {
    my ( $self, $item ) = @_;
    my $src    = $self->root->file( 'shots', $item->image );
    my $target = $self->root->file( 'thumbnails', $item->image );

    try {
        my $image  = Imager->new;
        $image->read( file => $src->stringify )              || die "Cannot read: $src" . $image->errstr;
        my $scaled = $image->scale( xpixels => $self->size ) || die "Cannot scale $src: " . $image->errstr;
        $scaled->write( file => $target->stringify)          || die "Cannot write to $target: " . $image->errstr;
        $item->update( { processed => 1 } );
        $log->infof(
            "Thumbnailed image >%i< from %s to %s",
            $item->id, $src->stringify, $target->stringify
        );
    }
    catch {
        $log->errorf(
            "Error while generate thumbnail for image >%i<: %s",
            $item->id, $_
        );
    };
}


__PACKAGE__->meta->make_immutable;
1;
