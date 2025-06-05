unit module Pod::TreeWalker::Subs;

sub exe-run(
    :$dir-in!,
    :$dir-out!,
    :$debug,
    ) is export {
    # Runs the test files in the /t directory with this command:
    #   for @fin -> $fin {
    #       my $n = $fin.basename;
    #       $n ~~ s/'.rakutest' $//;
    #       my $fout = "$fout-dir/$n.err";
    #       "raku -I. $fin 2> $fout";
    say "DEBUG: input dir:  '$dir-in'" if 0 or $debug;
    say "DEBUG: output dir: '$dir-out'" if 0 or $debug;

    use File::Find;
    my @fin = find :dir($dir-in), :type<file>, :name(/'.rakutest' $/);
    for @fin -> $fin {
        my $n = $fin.basename;
        $n ~~ s/'.rakutest' $//;
        my $fout = "$dir-out/$n.err".IO;
        shell "raku -I. $fin 2> $fout 1> /tmp";
    }
    say "See the run results in directory: '$dir-out':";
}

sub exe-format(
    :$dir-in!,
    :$dir-out!,
    :$debug,
    ) is export {
    # Uses the test files in the /Errout directory 
    #   and attempts to reformat them into a form
    #   that is easy to detect errors with a visual
    #   scan. 
    # Converted files are output to directory /Fmtout.
    # 
    #   for @fin -> $fin {
    #       my $n = $fin.basename;
    #       $n ~~ s/'.rakutest' $//;
    #       my $fout = "$fout-dir/$n.err";
    #       Process the input file...
    #       place the output file in dir $dir-out
    say "DEBUG: input dir:  '$dir-in'" if 0 or $debug;
    say "DEBUG: output dir: '$dir-out'" if 0 or $debug;
    
    use File::Find;
    my @fin = find :dir($dir-in), :type<file>, :name(/'.rakutest' $/);
    for @fin -> $fin {
    }
    say "See the formatted files in directory: '$dir-out':";

}
