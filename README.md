# NAME

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates - Create Mojolicious tests from a custom template format (deprecated)

![Requires Perl unknown](https://img.shields.io/badge/perl-unknown-brightgreen.svg) [![Travis status](https://api.travis-ci.org/Csson/p5-dist-zilla-plugin-test-createfrommojotemplate.svg?branch=master)](https://travis-ci.org/Csson/p5-dist-zilla-plugin-test-createfrommojotemplate) 

# VERSION

Version 0.0701, released 2016-01-25.

# SYNOPSIS

    ; In dist.ini
    [Test::CreateFromMojoTemplates]
    directory = examples/source
    filepattern = ^\w+-\d+\.mojo$

# DESCRIPTION

**Deprecated**. See [Dist::Zilla::Plugin::Stenciller::Mojolicious](https://metacpan.org/pod/Dist::Zilla::Plugin::Stenciller::Mojolicious) instead.

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates creates tests by parsing a custom file format
containg Mojolicious templates and the expected rendering. See [MojoX::CustomTemplateFileParser](https://metacpan.org/pod/MojoX::CustomTemplateFileParser) for details.

It looks for files in a given `directory` (by default `examples/source`) that matches `filepattern` (by default `^\w+-\d+\.mojo$`).

If you have many files you can also create a `template.test` (currently hardcoded) file. Its content will be placed at the top of all created test files.

# SOURCE

[https://github.com/Csson/p5-dist-zilla-plugin-test-createfrommojotemplate](https://github.com/Csson/p5-dist-zilla-plugin-test-createfrommojotemplate)

# HOMEPAGE

[https://metacpan.org/release/Dist-Zilla-Plugin-Test-CreateFromMojoTemplates](https://metacpan.org/release/Dist-Zilla-Plugin-Test-CreateFromMojoTemplates)

# AUTHOR

Erik Carlsson <info@code301.com>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2016 by Erik Carlsson.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
