package PDP::State::Driving;

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

sub park {
  my ($self) = @_;
  my $new_state = PDP::State::TurnedOn->new();

  # Turning on!
  $self->context->transition_to($new_state);
}

sub turn_off {
  my $self = shift;
  $self->_not_possible_error(@_);
}

sub turn_on {
  my $self = shift;
  $self->_not_possible_error(@_);
}

sub drive {
  my $self = shift;
  $self->_not_possible_error(@_);
}

1;
