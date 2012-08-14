package WebShot::Web::Controller::Website;
use Moose;
use namespace::autoclean;
use 5.010;

use HTML::FormHandler;

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/') PathPart('website') CaptureArgs(0) { }

sub add : Chained('base') Args(0) {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form} = HTML::FormHandler->new(
        field_list=> [
            url => { type=>'Text', required=>1, apply=>[ {
                check => qr|^https?://|,
                message => "doesn't look like a url",
            }] },
            submit => 'Submit',
        ]
    );

    if ( $form->process(
        action => $c->req->uri,
        params => $c->req->params,
    )) {
        warn "FORM PROCESSED";
        
        my $website = $c->model('DB::Website')->create({
            url => $form->field('url')->value,
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
    $c->res->body("show " . $c->stash->{item});
}

__PACKAGE__->meta->make_immutable;
1;
