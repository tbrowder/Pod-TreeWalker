unit module Pod::TreeWalker::Subs;

sub exe-run(
    IO::Path :$dir-in!,
    IO::Path :$dir-out!,
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
        shell "raku -I./lib $fin 2> $fout 1> /dev/null"; # stdout to the bit bucket
    }
    say "See the run results in directory: '$dir-out':";
}

sub exe-format(
    IO::Path :$dir-in!,
    IO::Path :$dir-out!,
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
        my $fo = reformat-errfile $fin, :$debug;
        shell "mv $fo $dir-out";
    }
    say "See the formatted files in directory: '$dir-out':";
}

sub reformat-errfile(
    IO::Path $fin,
    :$debug,
    --> IO::Path
    ) is export {
    # Reformat the *.err files 
    my $txt = ""; # the string to spurt
    for $fin.lines.kv -> $i, $line {
        
    }

}
