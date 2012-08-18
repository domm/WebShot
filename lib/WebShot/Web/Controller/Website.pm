package WebShot::Web::Controller::Website;
use Moose;
use namespace::autoclean;
use 5.010;

use WebShot::Web::Form::Website;
use WebShot::Screenshot;
use Try::Tiny;
use Log::Any::Adapter;
use Log::Dispatch;
my $log = Log::Dispatch->new( outputs => [
    [ 'File',
      filename  => '/var/log/webshot.log',
      min_level => 'debug',
      newline   => 1,
      mode      => 'append',
    ],
]);
Log::Any::Adapter->set( 'Dispatch', dispatcher => $log );

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/') PathPart('website') CaptureArgs(0) { }

sub add : Chained('base') Args(0) {
    my ( $self, $c ) = @_;

    my $form = $c->stash->{form} = WebShot::Web::Form::Website->new();

    if ( $form->process(
        action => $c->req->uri,
        params => $c->req->params,
    )) {
        try {
            my $url = $form->field('url')->value;
            $log->info("Got URL >$url< from user");

            my $screenshot = WebShot::Screenshot->new(
                root => $c->path_to(qw(root static shots)),
                url => $url,
            );
            $screenshot->take_a_shot;
            $log->info("Took the screenshot for >$url<");

            my $website = $c->model('DB::Website')->create({
                url => $url,
                image => $screenshot->image,
            });
            $log->info("Stored >$url< in DB with id >".$website->id."<");

            $c->res->redirect($c->uri_for($c->controller->action_for('show'),[$website->id]));
            return 0;
        }
        catch {
            die "Error while storing site & grabbing shot: $_";
        }
    }
}

sub list : Chained('base') Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{list} = $c->model('DB::Website')->search_rs( {}, { order_by=>'id desc' });
}

sub mosaic : Chained('base') Args(0) {
    my ( $self, $c ) = @_;
    $c->stash->{list} = $c->model('DB::Website')->search_rs( {
        processed=>1,
    }, { order_by=>'id desc' });
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
