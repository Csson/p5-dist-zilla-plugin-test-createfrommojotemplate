package Dist::Zilla::Plugin::Test::CreateFromMojoTemplates;

use strict;
use 5.10.1;
our $VERSION = '0.01';

use Moose;
use File::Find::Rule;
use namespace::sweep;
use Moose::Util::TypeConstraints;
use Path::Tiny;

use Dist::Zilla::File::InMemory;
with ('Dist::Zilla::Role::FileGatherer',
      'Dist::Zilla::Role::FileMunger');

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
has content => (
    is => 'ro',
    isa => 'ArrayRef',
);

has _file => (
    is => 'rw',
    isa => role_type('Dist::Zilla::Role::File'),
);

sub gather_files {
    my $self = shift;
    my $arg = @_;

    my @files = File::Find::Rule->file->name(qr/@{[ $self->filepattern ]}/)->in($self->directory);
    foreach my $file (@files) {
        my $contents = path($file)->slurp;

        $self->add_file($self->_file(
            Dist::Zilla::File::InMemory->new(
                name => $file,
                content => $contents,
            )
        ));
    }

    return;

}

sub munge_file {
    my $self = shift;
    my $file = shift;

    return if $file->name !~ m{^@{[ $self->directory ]}};

    (my $filename = $file->name) =~ s{\.mojo$}{.t};
    $filename =~ s{.*/([^/]*$)}{t/$1};
    warn '>>>>> filename >>>>' . $filename;
    $file->name($filename);

    warn '<<<< new filename >>>>>' . $file->name;

    return;
}




1;

__END__

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates - Create tests from custom templates

=head1 SYNOPSIS

  use Dist::Zilla::Plugin::Test::CreateFromMojoTemplates;

=head1 DESCRIPTION

Dist::Zilla::Plugin::Test::CreateFromMojoTemplates is

=head1 AUTHOR

Erik Carlsson E<lt>info@code301.comE<gt>

=head1 COPYRIGHT

Copyright 2014- Erik Carlsson

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
