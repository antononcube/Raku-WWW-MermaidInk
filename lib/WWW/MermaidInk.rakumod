use v6.d;

use HTTP::Tiny;
use Base64;

unit module WWW::MermaidInk;

proto sub mermaid-ink(Str $spec, |) is export {*}

multi sub mermaid-ink(Str $spec, :$file is copy = '') {

    # Process file
    if $file.isa(Whatever) { $file = $*CWD ~ '/out.png'; }
    die 'The argument $file is expected to be a (valid file) string, file handle, or Whatever.'
    unless $file ~~ Str || $file ~~ IO::Handle;

    # Make URL
    my $url = "https://mermaid.ink/img/{encode-base64($spec):str}";

    # Retrieve
    my $resp = HTTP::Tiny.get: $url;

    if $resp<success> && $file {
        # Export
        spurt $file, $resp.<content>;
    }

    return $resp;
}

multi sub mermaid-ink(@edges where @edges.all ~~ Pair, :$file is copy = '', :$directive is copy = Whatever ) {
    my $spec = 'graph';
    if $directive ~~ Str {
        $spec ~= " $directive";
    }

    for @edges -> $e {
        $spec ~= "\n{$e.key} --> {$e.value}";
    }

    return mermaid-ink($spec, :$file);
}