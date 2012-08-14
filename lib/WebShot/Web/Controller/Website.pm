package WebShot::Web::Controller::Website;
use Moose;
use namespace::autoclean;
use 5.010;

use WebShot::Web::Form::Website;
use WebShot::Screenshot;

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/') PathPart('website') CaptureArgs(0) { }

sub add : Chained('base') Args(0) {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form} = WebShot::Web::Form::Website->new();

    if ( $form->process(
        action => $c->req->uri,
        params => $c->req->params,
    )) {
        my $url = $form->field('url')->value;

        my $screenshot = WebShot::Screenshot->new(
            root => $c->path_to(qw(root static shots)),
            url => $url,
        );
        $screenshot->take_a_shot;

        my $website = $c->model('DB::Website')->create({
            url => $url,
            image => $screenshot->image,
        });

        $c->res->redirect($c->uri_for($c->controller->action_for('show'),[$website->id]));
        return 0;
    }
}

sub load : Chained('base') CaptureArgs(1) PathPart('') {
    my ( $self, $c, $id ) = @_;
    $c->stash->{item} = $c->model('DB::Website')->find($id);
    die "No website with id $id found" unless $c->stash->{item};
}

sub show : Chained('load') Args(0) {
    my ( $self, $c ) = @_;
}

__PACKAGE__->meta->make_immutable;
1;
