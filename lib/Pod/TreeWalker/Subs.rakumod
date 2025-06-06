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
    say "DEBUG: input dir:  '$dir-in'" if 1 or $debug;
    say "DEBUG: output dir: '$dir-out'" if 1 or $debug;
    
    use File::Find;
    my @fin = find :dir($dir-in), :type<file>, :name(/'.err' $/);
    for @fin -> $fin {
        # get a string to spurt
        my $s = reformat-errfile $fin, :$debug;
        my $fo = "$dir-out/{$fin.basename}".IO;
        say "DEBUG: See file '$fo'" if 1 or $debug;
        $fo.spurt: $s;
    }
    say "See the reformatted files in directory: '$dir-out':";
}

sub reformat-errfile(
    IO::Path $fin,
    :$debug,
    --> Str
    ) is export {

    # Reformat the *.err files 
    # Note they all have varying number of lines consisting of
    #   : header info
    #   :   'expected'
    #   :   'got'
    #   : trailer info
    # There may be multiple blocks of exp/got depending on how
    # the test was constructed.

    # define a string to spurt after collecting and formatting input
    my $txt = ""; 
    for $fin.lines.kv -> $i, $line is copy {
        # remove leading spaces
        $line ~~ s/^ \h+ //;

        if $line ~~ /'#' \h+ expected / {
            $line .= trim;
            # remove some spaces
            $line ~~ s/'#' \h+/# /;

            # want an extra blank line before expected
            $txt ~= "\n"; # want at least one blank line separator
            $txt ~= "$line\n";
            # want an extra blank line after expected
            $txt ~= "\n"; 
        } 
        elsif $line ~~ /'#' \h+ got / {
            $line .= trim;
            # remove some spaces
            $line ~~ s/'#' \h+/# /;

            $txt ~= "$line\n";
            # want an extra blank line after got
            $txt ~= "\n"; 
        } 
        else {
            $txt ~= "$line\n";
        }
    }
    $txt;
}
