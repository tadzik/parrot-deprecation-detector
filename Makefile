Deprecations.pbc: Deprecations.pm
	parrot-nqp --target=pir Deprecations.pm > Deprecations.pir
	parrot -o Deprecations.pbc Deprecations.pir

run: Deprecations.pbc
	parrot test.pir test.pir

clean:
	rm -f Deprecations.pbc Deprecations.pir
