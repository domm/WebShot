package WebShot::Thumbnail;
use Moose;
use Imager;

has 'size' => (is=>'ro',isa=>'Int',default=>'32');
has 'list' => (is=>'ro',isa=>'DBIx::Class::ResultSet',required=>1);
has 'root' => (is=>'ro',isa=>'Path::Class::Dir',required=>1);

sub thumbnail {
    my $self = shift;

    my $list = $self->list;
    while (my $item = $list->next) {
        my $image = Imager->new;
        my $src = $self->root->file('shots',$item->image);
        $image->read(file=>$src->stringify) || die "Cannot read: $src".$image->errstr;
        my $scaled = $image->scale(xpixels => $self->size) || die "Cannot scale $src: ".$image->errstr;
        $scaled->write(file=>$self->root->file('thumbnails',$item->image)->stringify);

        $item->update({processed=>1});
    }
}

__PACKAGE__->meta->make_immutable;
1;
