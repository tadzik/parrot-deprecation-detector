class Deprecations;

INIT {
    pir::load_bytecode("YAML/Tiny.pbc");
}

=begin method

method check($file_to_check, $deprecations_file) 

Scans $file_to_check for deprecations listen in $deprecations_file,
probably Parrot's C<api.yaml>. Returns a list of warnings (strings).

=end method

method check_file($file, $yaml) {
    my $parser := YAML::Tiny.new;
    my $api := $parser.read_string(slurp($yaml));
    my @deprs;
    my @deprecations;

    if $file ~~ / '.pir' $ / {
        for $api[0] {
            if $_<detection> && $_<detection><regex>
               && $_<detection><regex><pir> {
                   my $r := $_<detection><regex><pir>;
                @deprs.push(
                    [Regex::P6Regex::Compiler.compile($r), $r, $_<name>]
                );
            }
        }
    }

    my $fh := pir::new('FileHandle');
    $fh.open($file);
    my $line := 1;
    while $fh.readline -> $l {
        for @deprs -> $regex {
            my $r := $regex[0];
            if $l ~~ / $r / {
                @deprecations.push("$line: { $regex[2] }");
            }
        }
        $line++;
    }
    $fh.close;

    return @deprecations;
}

# vim: ft=perl6
