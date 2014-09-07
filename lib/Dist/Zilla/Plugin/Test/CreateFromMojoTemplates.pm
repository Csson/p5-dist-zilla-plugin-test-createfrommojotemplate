package Dist::Zilla::Plugin::Test::CreateFromMojoTemplates;

use strict;
use 5.10.1;
our $VERSION = '0.01';

use Moose;
use File::Find::Rule;
use namespace::sweep;
use Mojo::Template;
use Path::Tiny;

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

    my $test_template = (File::Find::Rule->file->name('tempate.test')->in($self->directory))[0];

    my @paths = File::Find::Rule->file->name(qr/@{[ $self->filepattern ]}/)->in($self->directory);
    foreach my $path (@paths) {
        
        my $contents = prepare($test_template, $path);

        $path =~ s{\.mojo$}{.t};
        $path =~ s{.*/([^/]*$)}{t/$1};

        my $file = Dist::Zilla::File::InMemory->new(
            name => $path,
            content => $test_template . $contents,
        );
        $self->add_file($file);
    }
    return;
}

sub prepare {
    my $test_template = shift;
    my $path = shift;
    my @lines = split /\n/ => path($path)->slurp;

    (my $filename = $path) =~ s{.*/([^/]*$)}{$1};
    (my $baseurl = $filename) =~ s{^([^.]+)\.}{$1};
    $baseurl =~ s{-}{_};

    my $info = parse_source(@lines);

    my @parsed = join "\n" => @{ $info->{'head_lines'} };
    my $templater = Mojo::Template->new;

    my $testcount = 0;
    foreach my $test (@{ $info->{'tests'} }) {
        ++$testcount;
        push @parsed => join "\n" => @{ $test->{'lines_before'} };
        push @parsed => sprintf '@@ %s_%d.html.ep' => $baseurl, $testcount;
        push @parsed => $templater->render(join "\n" => @{ $test->{'lines_template'} });
        push @parsed => join "\n" => @{ $test->{'lines_after'} };
    }

    return join '' => @parsed;

}

sub parse_source {
    my @lines = @_;

    my $test_start = '==TEST(?: EXAMPLE)(?: (\d+)?)==';
    my $template_separator = '----';

    my $environment = 'head';

    my $info = {
        head_lines => [],
        tests      => []
    };
    my $test = {};

    LINE:
    while(my $line = @lines) {
        chomp $line;

        if($environment eq 'head') {
            if($line =~ qr/$test_start/) {
                $test = reset_test();
                $test->{'test_number'} = $1;

                push @{ $info->{'head_lines'} } => '',
                $environment = 'test_before_template';

                next LINE;
            }
            push @{ $info->{'head_lines'} } => $line;
            next LINE;
        }
        if($environment eq 'test_before_template') {
            if($line eq $template_separator) {
                push @{ $test->{'lines_before'} } => '';
                $environment = 'template';
                next LINE;
            }
            push @{ $test->{'lines_before'} } => $line;
            next LINE;
        }
        if($environment eq 'template') {
            if($line eq $template_separator) {
                # No need to push empty line to the template
                $environment = 'test_after_template';
                next LINE;
            }
            push @{ $test->{'lines_template'} } => $line;
            next LINE;
        }
        if($environment eq 'test_after') {
            if($line =~ qr/$test_start/) {
                push @{ $test->{'lines_after'} } => '';
                push @{ $info->{'tests'} } => $test;
                $test = reset_test();
                $test->{'test_number'} = $1;

                $environment = 'test_before_template';

                next LINE;
            }
            push @{ $test->{'lines_after'} } => $line;
            next LINE;
        }
    }
    push @{ $info->{'tests'} } => $test;

    return $info;
}

sub reset_test {
    return {
        lines_before => [],
        lines_template => [],
        lines_after => [],
        test_number => undef,
    };
}

__PACKAGE__->meta->make_immutable;



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
