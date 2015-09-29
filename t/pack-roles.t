#!/usr/bin/perl 

use strict;
use warnings;

use Test::More tests => 1;

use Moose::Util qw' with_traits';

{
    package Bar;
    use Moose::Role;
    has y => ( is => 'ro', default => 2 );
}

{
    package Foo;
    use Moose;
    use MooseX::Storage;

    with Storage( base => 'SerializedClass', traits => [ 'WithRoles' ] );

    has x => (
        is => 'ro',
        default => 3,
    );

}

my $x = with_traits( 'Foo', 'Bar' )->new;

my $packed = $x->pack;

is_deeply $packed => {
    '__CLASS__' => 'Foo',
    '__ROLES__' => [ qw/ Bar / ],
    x => 3,
    y => 2,
}, 'packed';

my $y = Foo->unpack($packed);

is $y->x => 3;
is $y->y => 2;




