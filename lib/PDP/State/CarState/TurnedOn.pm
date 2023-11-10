package PDP::State::CarState::TurnedOn;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);

use parent 'PDP::State::CarState::Base';
use PDP::State::CarState::TurnedOff ();
use PDP::State::CarState::Driving ();

sub can_transition_to {
  my ($self, $new_state) = @_;
  return 1 if grep { $new_state->isa($_) } ('PDP::State::CarState::TurnedOff', 'PDP::State::CarState::Driving');
}

sub turn_off {
  my ($self) = @_;

  my $new_state = PDP::State::CarState::TurnedOff->new();

  # Turning off
  $self->context->transition_to($new_state);
}

sub turn_on {
  my $self = shift;
  $self->_not_possible_error(@_);
}

sub drive {
  my ($self) = @_;
  my $new_state = PDP::State::CarState::Driving->new();

  # begin driving
  $self->context->transition_to($new_state);
}

sub accelerate {
  my ($self, $new_speed) = @_;
  $self->_not_possible_error(@_);
  return $self;
}

sub hit_breaks {
  my ($self) = @_;
  $self->_not_possible_error(@_);
  return $self;
}

1;
