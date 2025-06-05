#!/usr/bin/env raku

my $tdir-in = "t".IO.d;
my $err-out = "errout".IO.d;
my $fmt-out = "fmtout".IO.d;

if not @*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} run | format [debug]

    run:
        Reads test files in '/t', executes the
        tests with err output to '/errout'.

    format:
        Manipulates the input file to put it into
        a format to enable easy visual inspection of
        test output to see differences between "given" 
        and "expected."

        Outputs the new formatted file to '/fmtout'

    HERE
    exit;
}


