return {
    name => 'WebShot',
    disable_component_resolution_regex_fallback => 1,
    'View::TT' => {
        INCLUDE_PATH => [
                WebShot::Web->path_to( 'root', 'templates' ),
            ],
            TEMPLATE_EXTENSION => ".tt",
            WRAPPER            => 'site/wrapper.tt',
            ERROR              => 'error.tt',
            TIMER              => 0,
            render_die         => 1,
            ENCODING           => 'utf-8',
    },
    'Model::DB'=>{
        schema_class=>'WebShot::Schema',
        connect_info=>'dbi:SQLite:dbname='.WebShot::Web->path_to('root','webshot.db'),
    },
};
