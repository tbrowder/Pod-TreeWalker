#!/usr/bin/env raku

my %h = :key1<a>, :key2<b>;
my @e;
@e.push(%h.raku);
say dd @e;
say @e.raku;
say @e.head.raku;
