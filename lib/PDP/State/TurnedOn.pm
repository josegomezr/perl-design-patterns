package PDP::State::TurnedOn;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);

use parent 'PDP::State::BaseState';
use PDP::State::TurnedOff;
use PDP::State::Driving;

sub can_transition_to {
  my ($self, $new_state) = @_;
  return 1 if grep { $new_state->isa($_) } ('PDP::State::TurnedOff', 'PDP::State::Driving');
}

sub turn_on {
  croak "Can't turn on a car that's turned on!";
}

sub turn_off {
  my ($self) = @_;

  my $new_state = PDP::State::TurnedOff->new();

  # Turning off
  $self->context->transition_to($new_state);
}

sub drive {
  my ($self) = @_;
  my $new_state = PDP::State::Driving->new();

  # begin driving
  $self->context->transition_to($new_state);
}

sub park {
  croak "Can't park a car that's turned on!";
}

1;
