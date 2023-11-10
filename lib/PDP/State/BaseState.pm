package PDP::State::BaseState;

=encoding utf8

=head1 NAME

PDP::State::BaseState - Abstract Base State Class

=head1 DESCRIPTION

It defines the state transition framework and the interface for concrete states
to implement.

=cut

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

our @EXPORT = qw(context can_transition_to turn_on turn_off drive park);

=head1 ATTRIBUTE ACCESSORS

=head2 context

Sets or retrieves the current state context.

=cut

sub context {
  my $self = shift;

  if (my $context = shift) {
    $self->{context} = $context;
    return $self;
  }

  return $self->{context};
}

=head1 STATE MACHINE HANDLING

=head2 _not_possible_error

It's a dumb equivalent to a C<raise RuntimeError> (or equivalent in your
language of choice) to be raised when the actor tries to perform an "impossible
operation" or "invalid operation".

It's just not to write the same-ish error message all over again tbh.

=cut

sub _not_possible_error {
  my ($self) = @_;
  my ($caller_name, $caller_path, $caller_line, $sub_name) = caller(1);

  $sub_name =~ s/^.*::(.+)$/$1/;

  croak sprintf("cannot %s in %s", $sub_name, ref $self);
}

=head2 can_transition_to

Defines a state transition, it's to be defined by subclasses to control how to
transition from the current state to the next one.

When a transition is not possible, it's expected to die (akin to an exception)
otherwise the actor will swap states and re-feed the context.

This is the key piece to abstract away complex if clauses. The actor just asks
to the state if it can move on to the next state, and the logic for that is
abstracted in each state.

See C<PDP::State::Driving> for a complete example of performing and blocking
transitions.

=over 2

=item state

A state object implementing C<PDP::State::BaseClass>.

=back
=cut

sub can_transition_to {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

1;
