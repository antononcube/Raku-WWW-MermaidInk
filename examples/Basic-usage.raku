#!/usr/bin/env raku
use v6.d;

use WWW::MermaidInk;

my $spec = q:to/END/;
flowchart TD
WL --> |ZMQ|Python --> |ZMQ|WL
WL --> |ZMQ|R --> |ZMQ|WL
END

say mermaid-ink($spec, file => Whatever);

my @edges = [ LISP => 'Julia', LISP => 'R', LISP => 'WL'];

say mermaid-ink(@edges, file => 'outEdges.png');