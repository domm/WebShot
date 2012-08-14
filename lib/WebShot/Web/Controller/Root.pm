package WebShot::Web::Controller::Root;
use Moose;
use namespace::autoclean;
use 5.010;

use HTML::FormHandler::Model::DBIC;

BEGIN { extends 'Catalyst::Controller' }
__PACKAGE__->config( namespace => '' );

sub index : Path : Args(0) {
    my ( $self, $c ) = @_;
}

sub default : Path {
    my ( $self, $c ) = @_;

    $c->res->status(404);
    $c->stash->{error}    = 'Not Found: ' . $c->req->uri;
    $c->stash->{template} = 'error.tt';
}

sub end : ActionClass('RenderView') {
    my ( $self, $c ) = @_;

    if ( my @errors = @{ $c->error } ) {
        foreach ( @{ $c->error } ) {
            $c->log->error($_);
        }

        $c->stash->{error}    = $c->error;
        $c->stash->{template} = 'error.tt';
        $c->error(0);
        $c->res->status(500);
    }
}

__PACKAGE__->meta->make_immutable;
1;
