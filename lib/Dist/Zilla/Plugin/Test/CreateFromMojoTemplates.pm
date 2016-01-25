package Dist::Zilla::Plugin::Test::CreateFromMojoTemplates;

use strict;
use 5.10.1;

# VERSION
# ABSTRACT: Create Mojolicious tests from a custom template format (deprecated)

use Moose;
use File::Find::Rule;
use namespace::autoclean;
use Path::Tiny;
use MojoX::CustomTemplateFileParser;

use Dist::Zilla::File::InMemory;
with 'Dist::Zilla::Role::FileGatherer';

has directory => (
    is => 'ro',
    isa => 'Str',
    default => sub { 'examples/source/' },
);
has filepattern => (
    is => 'ro',
    isa => 'Str',
    default => sub { '^\w+-\d+\.mojo$' },
);

sub gather_files {
    my $self = shift;
    my $arg = shift;

    my $test_template_path = (File::Find::Rule->file->name('template.test')->in($self->directory))[0];
    my $test_template = path($test_template_path)->slurp;

    my @paths = File::Find::Rule->file->name(qr/@{[ $self->filepattern ]}/)->in($self->directory);
    foreach my $path (@paths) {

        my $contents = MojoX::CustomTemplateFileParser->new(path => path($path)->absolute->canonpath, output => ['Test'])->to_test;
        my $filename = path($path)->basename(qr{\.[^.]+});

        my $file = Dist::Zilla::File::InMemory->new(
            name => "t/$filename.t",
            content => $test_template . $contents,
        );
        $self->add_file($file);

    }

    return;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 SYNOPSIS

  ; In dist.ini
  [Test::CreateFromMojoTemplates]
  directory = examples/source
  filepattern = ^\w+-\d+\.mojo$

=head1 DESCRIPTION

B<Deprecated>. See L<Dist::Zilla::Plugin::Stenciller::Mojolicious> instead.

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates creates tests by parsing a custom file format
containg Mojolicious templates and the expected rendering. See L<MojoX::CustomTemplateFileParser> for details.

It looks for files in a given C<directory> (by default C<examples/source>) that matches C<filepattern> (by default C<^\w+-\d+\.mojo$>).

If you have many files you can also create a C<template.test> (currently hardcoded) file. Its content will be placed at the top of all created test files.

=cut
