package PDP::BaseClass;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);

# Copied from Mojo::Base
sub new {
  my $class = shift;
  my $self = bless((@_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}), ref $class || $class);

  return $self;
}

sub _not_implemented_error {
  my ($self) = @_;
  my ($caller_name, $caller_path, $caller_line, $sub_name) = caller(1);

  $sub_name =~ s/^.*::(.+)$/$1/;

  croak sprintf("Method '%s' not implemented by subclass %s", $sub_name, ref $self);
}

1;
