package PDP::State::BaseState;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

sub context {
  my $self = shift;

  if (my $context = shift) {
    $self->{context} = $context;
    return $self;
  }

  return $self->{context};
}

sub can_transition_to {
  croak 'Method "can_transition_to" not implemented by subclass';
}

sub turn_on {
  croak 'Method "turn_on" not implemented by subclass';
}

sub turn_off {
  croak 'Method "turn_off" not implemented by subclass';
}

sub drive {
  croak 'Method "drive" not implemented by subclass';
}

sub park {
  croak 'Method "park" not implemented by subclass';
}

1;
