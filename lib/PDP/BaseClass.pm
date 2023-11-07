package PDP::BaseClass;

use strict;
use warnings;
use utf8;
use feature ':5.26';

# Copied from Mojo::Base
sub new {
  my $class = shift;
  my $self = bless((@_ ? @_ > 1 ? {@_} : {%{$_[0]}} : {}), ref $class || $class);

  return $self;
}

1;
