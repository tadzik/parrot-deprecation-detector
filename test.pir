# Copyright (C) 2010 Parrot Foundation.
# $Id: $

.sub 'main' :main
    .param pmc args
    $P0 = shift args
    $P0 = shift args # fixme, that's dumb
    $S0 = 'api.yaml'
    
    load_bytecode "nqp-rx.pbc"
    load_bytecode "Deprecations.pbc"
    $P1 = new 'Deprecations'
    $P2 = $P1.'check_file'($P0, $S0)
    $S1 = join "\n", $P2
    say $S1
.end

.sub 'foo' :init
    # ba ba ba
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

