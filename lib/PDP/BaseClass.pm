package PDP::BaseClass;

=encoding utf8

=head1 NAME

PDP::BaseClass - Minimal Base class inspired in C<Mojo::Base>.

=head1 SYNOPSIS

  package Example;
  use parent PDP::BaseClass;

  # your methods here...

=head1 DESCRIPTION

It brings a standard constructor for subclasses that allows state to be passed
down as a hash.

Nothing much here, other than fake C<NotImplementedError>.

=cut

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);

=head1 CONSTRUCTORS

C<PDP::BaseClass> implements a simple constructor that accepts a hash of
properties.

=head2 new

Minimal base constructor

=over

=item state

A hash containing the internal properties of an object. When not given it
defaults to an empty hash.

=back

=cut

sub new {
  my $class = shift;
  my $self = bless((@_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}), ref $class || $class);

  return $self;
}


=head1 METHODS

=head2 _not_implemented_error

It's a dumb equivalent to C<raise NotImplementedError> (or equivalent in your
language of choice.

=cut

sub _not_implemented_error {
  my ($self) = @_;
  my ($caller_name, $caller_path, $caller_line, $sub_name) = caller(1);

  $sub_name =~ s/^.*::(.+)$/$1/;

  croak sprintf("Method '%s' not implemented by subclass %s", $sub_name, ref $self);
}

1;
