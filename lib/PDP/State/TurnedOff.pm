package PDP::State::TurnedOff;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::State::BaseState';
use PDP::State::TurnedOn;

sub can_transition_to {
  my ($self, $new_state) = @_;
  return 1 if $new_state->isa('PDP::State::TurnedOn');
}

sub turn_on {
  my ($self) = @_;
  my $new_state = PDP::State::TurnedOn->new();

  # Turning on!
  $self->context->transition_to($new_state);
}

sub turn_off {
  croak "Can't turn off a car that's turned off!";
}

sub drive {
  croak "Can't drive a car that's turned off!";
}

sub park {
  croak "Can't park a car that's turned off!";
}

1;
