package WebShot::Screenshot;
use Moose;
use namespace::autoclean;

use Glib ':constants';
use Gtk3 -init;
use Gtk3::WebKit qw(:xpath_results :node_types);
use Cairo::GObject;
use Path::Class;

has 'url' => (is=>'ro',required=>1);
has 'root' => (is=>'ro',isa=>'Path::Class::Dir',required=>1);
has 'file' => (is=>'ro',isa=>'Path::Class::File',required=>1,lazy_build=>1);
sub _build_file {
    my $self = shift;
    return $self->root->file($self->image);
}
has 'image' => (is=>'ro',isa=>'Str',required=>1,lazy_build=>1);
sub _build_image {
    my $self = shift;
    my $image = $self->url;
    $image=~s|^https?://||;
    $image=~s/\W/_/g;
    $image=~s/_+/_/g;
    $image=~s/_$//g;
    $image=~s/^_//g;
    $image.='.png';
    return $image;
}
has 'size' => (is=>'ro',isa=>'Int',default=>1024);

sub take_a_shot {
    my $self = shift;

    my $view = Gtk3::WebKit::WebView->new();
    $view->signal_connect('notify::load-status' => sub {
        return unless $view->get_uri and ($view->get_load_status eq 'finished');

        my $grab_screenshot_cb = sub {
            grab_screenshot($self, $view);
        };
        Glib::Timeout->add(300, $grab_screenshot_cb);
    });
    $view->load_uri($self->url);

    my $window = Gtk3::OffscreenWindow->new();
    $window->set_default_size($self->size, $self->size);

    $window->add($view);
    $window->show_all();

    Gtk3->main();
    return 0;
}

sub grab_screenshot {
    my ($self, $view ) = @_;

    my ($left, $top, $width, $height) = (0, 0, 0, 0);
    if (!$width and !$height) {
        ($width, $height) = ($view->get_allocated_width, $view->get_allocated_height);
    }

    my $surface = Cairo::ImageSurface->create(argb32 => $self->size, $self->size);
    my $cr = Cairo::Context->create($surface);
    $cr->translate(-0, -0);
    $view->draw($cr);
    $surface->write_to_png($self->file->stringify);

    Gtk3->main_quit();
}

__PACKAGE__->meta->make_immutable;
1;
