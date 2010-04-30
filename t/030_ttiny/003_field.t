#!perl -w
use strict;
use Test::More;

use Text::Xslate::Compiler;
use Text::Xslate::Parser::TTiny;

my $tx = Text::Xslate::Compiler->new(
    parser => Text::Xslate::Parser::TTiny->new(),
);

my @data = (
    ['[% var.attr %]', 'value'],

    ['[% g.f.x %]',  'gfx'],
    ['[% x.f.g %]',  'xfg'],
    ['[% a.foo %]',  'bar'],

    ['[% ary.0 %]', 10],
    ['[% ary.1 %]', 20],
    ['[% ary.2 %]', 30],
);

{
    package A;
    use Mouse;

    has foo => (
        is => 'rw',
    );
}

foreach my $pair(@data) {
    my($in, $out) = @$pair;

    my $x = $tx->compile_str($in);

    my %vars = (
        var => { attr => 'value' },

        g => { f => { x => 'gfx' } },
        x => { f => { g => 'xfg' } },
        a => A->new(foo => 'bar'),

        ary => [10, 20, 30],

        foo => 'foo',
    );

    is $x->render(\%vars), $out, 'first:' . $in;
    is $x->render(\%vars), $out, 'second';
}

done_testing;