# NAME

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates - Create tests from custom [Mojolicious](https://metacpan.org/pod/Mojolicious) templates

# SYNOPSIS

    ; In dist.ini
    [Test::CreateFromMojoTemplates]
    directory = examples/source
    filepattern = ^\w+-\d+\.mojo$

# DESCRIPTION

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates creates tests by parsing a custom file format
containg Mojolicious templates and the expected rendering. See [MojoX::CustomTemplateFileParser](https://metacpan.org/pod/MojoX::CustomTemplateFileParser) for details.

It looks for files in a given `directory` (by default `examples/source`) that matches `filepattern` (by default `^\w+-\d+\.mojo$`).

If you have many files you can also create a `template.test` (currently hardcoded) file. Its content will be placed at the top of all created test files.

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT

Copyright 2014- Erik Carlsson

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO
