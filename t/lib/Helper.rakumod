unit module Helper;

sub exe-run(
    :$dir-in!,
    :$dir-out!,
    :$debug,
    ) is export {
    use File::Find;
    my @fin = find :dir($dir-in);
}

sub exe-format(
    :$dir-in!,
    :$dir-out!,
    :$debug,
    ) is export {
    use File::Find;
    my @fin = find :dir($dir-in);
}
