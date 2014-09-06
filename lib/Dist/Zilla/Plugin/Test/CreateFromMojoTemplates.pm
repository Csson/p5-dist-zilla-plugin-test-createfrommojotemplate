package Dist::Zilla::Plugin::Test::CreateFromMojoTemplates;

use strict;
use 5.10.1;
our $VERSION = '0.01';

use Moose;
use File::Find::Rule;
use namespace::sweep;

use Dist::Zilla::File::InMemory;
with 'Dist::Zilla::Role::FileGatherer';

has directory => (
    is => 'ro',
    isa => 'Str',
    default => sub { 'examples/source' },
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

sub gather_files {
	my $self = shift;
	my $arg = @_;

	my @files = File::Find::Rule->file->name(qr/$self/);

	warn '<<<<';

	return;

}

sub 


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
