use Test::More;
use DBIx::Simple::DataSection;

BEGIN {
    eval { require DBD::SQLite; 1 }
        or plan skip_all => 'DBD::SQLite required';
    eval { DBD::SQLite->VERSION >= 1 }
        or plan skip_all => 'DBD::SQLite >= 1.00 required';

    use_ok('DBIx::Simple');
}

# In memory database! No file permission troubles, no I/O slowness.
# http://use.perl.org/~tomhukins/journal/31457 ++

my $db = DBIx::Simple::DataSection->connect('dbi:SQLite:dbname=:memory:', '', '', { RaiseError => 1 });
ok($db);
ok($db->query_by_sql('create.sql'));
ok($db->query_by_sql('insert1.sql', qw(a b c)));
is_deeply([ $db->query_by_sql('select.sql')->flat ], [ qw(a b c) ]);
ok($db->query_by_sql('insert2.sql', qw(d e f)));


done_testing;

__DATA__
@@ create.sql
CREATE TABLE xyzzy (FOO, bar, baz)

@@ insert1.sql
INSERT INTO xyzzy (FOO, bar, baz) VALUES (?, ?, ?)

@@ select.sql
SELECT * FROM xyzzy ORDER BY foo

@@ insert2.sql
INSERT INTO xyzzy VALUES (??)

