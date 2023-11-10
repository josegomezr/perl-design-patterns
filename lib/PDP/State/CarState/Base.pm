package PDP::State::CarState::Base;

=encoding utf8

=head1 NAME

C<PDP::State::CarState::Base> - Abstract Base State Class for C<PDP::State::Car>

=head1 DESCRIPTION

This is the abstract base class for all states in the State Pattern example.

=cut


use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::State::BaseState';

=head1 STATE MACHINE METHODS

These are the reflection of the Actor methods that will be handled by each
concrete state.

Since this is the abstract class, all behavior will raise our equivalent of
C<NotImplementedError>.

=cut


=head2 accelerate(new_speed)

Accelerates the car (increase speed).

=over 2

=item new_speed

Integer: new speed of the car.

=back

=cut

sub accelerate {
  my ($self, $new_speed) = @_;
  $self->_not_implemented_error(@_);
}


=head2 hit_breaks()

Breaks the car (set speed to 0) to C<new_speed>.

It's called C<hit_breaks> to avoid confusion with C<break> keyword.

=cut

sub hit_breaks {
  my ($self) = @_;
  $self->_not_implemented_error(@_);
}

=head2 turn_on()

Turns on the car

=cut

sub turn_on {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

=head2 turn_off()

Turns off the car

=cut

sub turn_off {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

=head2 drive()

Puts the car in B<DRIVE>

=cut

sub drive {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

=head2 park()

Parks the car.

=cut

sub park {
  my $self = shift;
  $self->_not_implemented_error(@_);
}

1;
