package PDP::State::BaseState;

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

our @EXPORT = qw(context can_transition_to turn_on turn_off drive park);

sub _not_possible_error {
  my ($self) = @_;
  my ($caller_name, $caller_path, $caller_line, $sub_name) = caller(1);

  $sub_name =~ s/^.*::(.+)$/$1/;

  croak sprintf("cannot %s in %s", $sub_name, ref $self);
}

sub context {
  my $self = shift;

  if (my $context = shift) {
    $self->{context} = $context;
    return $self;
  }

  return $self->{context};
}

sub can_transition_to {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

sub turn_on {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

sub turn_off {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

sub drive {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

sub park {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

sub accelerate {
  my ($self, $new_speed) = @_;
  $self->_not_implemented_error(@_);
}

sub hit_breaks {
  my ($self) = @_;
  $self->_not_implemented_error(@_);
}

1;
