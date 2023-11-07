package PDP::Car;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

# Copied from Mojo::Base
sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  $self->{speed} //= 0;
  $self->{state} //= PDP::State::TurnedOff->new()->context($self);
  return $self;
}

sub transition_to {
  my ($self, $new_state) = @_;

  if ($self->state->can_transition_to($new_state)) {
    $self->state($new_state);
    $new_state->context($self);
    return $self;
  }

  croak sprintf('Cannot transition from %s to %s', ref $self->state, ref $new_state);
}

# Does this needs a context wrapper, or can it live here?
sub speed {
  my ($self) = @_;
  return $self->{speed};
}

sub accelerate {
  my ($self, $new_speed) = @_;
  $self->{speed} += $new_speed;
  return $self;
}

sub hit_breaks {
  my ($self, $new_speed) = @_;
  $self->{speed} = 0;
  return $self;
}

sub state {
  my $self = shift;

  if (my $state = shift) {
    $self->{state} = $state;
    return $self;
  }

  return $self->{state};
}


sub turn_on {
  my ($self) = @_;
  return $self->state->turn_on();
}

sub turn_off {
  my ($self) = @_;
  return $self->state->turn_off();
}

sub drive {
  my ($self) = @_;
  return $self->state->drive();
}

sub park {
  my ($self) = @_;
  return $self->state->park();
}

1;
