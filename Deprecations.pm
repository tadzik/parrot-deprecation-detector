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
    my @regexes;
    my @deprecations;

    if $file ~~ / '.pir' $ / {
        for $api[0] {
            if $_<detection> && $_<detection><regex>
               && $_<detection><regex><pir> {
                @regexes.push($_<detection><regex><pir>);
            }
        }
    }

    my $fh := pir::new('FileHandle');
    $fh.open($file);
    my $line := 1;
    while $fh.readline -> $l {
        for @regexes -> $regex {
            if $l ~~ / $regex / {
                @deprecations.push("$line: $regex");
            }
        }
        $line++;
    }
    $fh.close;

    return @deprecations;
}

# vim: ft=perl6
