package WebShot::Web::Form::Website;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

has_field 'url' => (
    type=>'Text',
    required=>1,
    apply=>[
        {
            check => qr|^https?://|,
            message => "doesn't look like a url",
        }
    ],
    trim => {
        transform => sub {
            my $string = shift;
            $string=~s|/$||;
            return $string;
        }
    },
);

has_field 'submit' => ( type => 'Submit' );

no HTML::FormHandler::Moose;
1;
