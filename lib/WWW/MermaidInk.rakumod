use v6.d;

use HTTP::Tiny;
use Base64;

unit module WWW::MermaidInk;

proto sub mermaid-ink(Str $spec, |) is export {*}

multi sub mermaid-ink(Str $spec, :$file is copy = '', Str :$format = 'asis') {

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

    given $format {
        when $_.lc ∈ <base64 b64_json> {
            return $resp.<content>.&encode-base64(:str);
        }
        when $_.lc ∈ <md-image image-md markdonw> {
            return '![](data:image/png;base64,' ~ $resp.<content>.&encode-base64(:str) ~ ')';
        }
        default { return $resp; }
    }
}

multi sub mermaid-ink(@edges where @edges.all ~~ Pair, :$file is copy = '', Str :$format = 'asis', :$directive is copy = Whatever ) {
    my $spec = 'graph';
    if $directive ~~ Str {
        $spec ~= " $directive";
    }

    for @edges -> $e {
        $spec ~= "\n{$e.key} --> {$e.value}";
    }

    return mermaid-ink($spec, :$file, :$format);
}