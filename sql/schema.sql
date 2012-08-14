create table website (
	id integer primary key,
	url text not null unique,
	image text,
    processed int not null default 0
);
