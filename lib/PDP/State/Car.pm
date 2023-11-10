package PDP::State::Car;

=encoding utf8

=head1 NAME

PDP::Car - A minimal example of the State design pattern.

=head1 SYNOPSIS

  package Example;

  use PDP::Car;

  $car = PDP::Car->new();

  # To start: Hit the ignition!
  $car->turn_on();

  # Now drive!
  $car->drive();

  # FASTER!!!
  $car->accelerate(10);

  # STAHP!
  $car->hit_breaks(10);

  # ok ok park... sloowly
  $car->park();

  # aaand stop...
  $car->turn_off();

  # 😎

=head1 DESCRIPTION

C<PDP::Car> is a class representing simple state machine. As shown below:


           x-------[turn off]-------x                  x--[accelerate]--x
           |                        |                  |  x-------------x
           v                        |                  |  v
  * -> TurnedOff --[turn on]---> TurnedOn --[drive]--> Driving
           |                        ^                   | ^------------x
           |                        |                   | x---[break]--x
           |                        x-------[park]------x
           v
           o
=cut

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

# Initial State
use PDP::State::CarState::TurnedOff ();

=head1 CONSTRUCTORS

C<PDP::Car> inherits from L<PDP::BaseClass> and implements default values for
C<state> & C<speed>.

=head2 new

Instantiates a car, it accepts/handles two properties:

=over

=item speed

Speed of the car.

=item state

Current state of the car.

=back

=cut

sub new {
  my $class = shift;
  my $self = $class->SUPER::new(@_);
  # Default Attributes
  $self->{speed} //= 0;
  # Default State
  $self->{state} //= PDP::State::CarState::TurnedOff->new();
  # Feed the context to the state.
  $self->{state}->context($self);
  return $self;
}


=head1 ATTRIBUTE ACCESSORS

All I<Attribute Accessors> here follow the fluent interface, when called without
a value they behave as a getter, when providing a value they behave as a
setter.

=over 1

=back

=head2 speed

The speed of the car.

=cut

sub speed {
  my ($self) = @_;

  if (my $speed = shift) {
    $self->{speed} = $speed;
    return $self;
  }

  return $self->{speed};
}

=head2 state

A state object implementing C<PDP::State::CarState::Base>.

=cut

sub state {
  my $self = shift;

  if (my $state = shift) {
    $self->{state} = $state;
    return $self;
  }

  return $self->{state};
}

=head1 STATE MACHINE HANDLING

=head2 transition_to(new_state)

Changes the car internal state for C<new_state>.

Before performing the change, C<state-E<gt>can_transition_to(new_state)> will be caled
to validate the state change.

C<state-E<gt>can_transition_to(new_state)> will die if the state transition is
invalid. It's the closest thing to an exception I know so far.

=over

=item state

A state object implementing C<PDP::State::CarState::Base>.

=back
=cut

sub transition_to {
  my ($self, $new_state) = @_;

  if ($self->state->can_transition_to($new_state)) {
    $self->state($new_state);
    $new_state->context($self);
    return $self;
  }

  croak sprintf('Cannot transition from %s to %s', ref $self->state, ref $new_state);
}

=head1 STATE MACHINE METHODS

Methods defined below are façades of the C<state>, they're defined in the actor
but implemented in the state.

Each state will execute the appropriate action and transition to a next state if
applicable or die otherwise.


=head2 accelerate(new_speed)

Accelerates the car (increase speed).

=over 2

=item new_speed

Integer: new speed of the car.

=back

=cut

sub accelerate {
  my ($self, $new_speed) = @_;
  return $self->state->accelerate($new_speed);
}

=head2 hit_breaks()

Breaks the car (set speed to 0) to C<new_speed>.

It's called C<hit_breaks> to avoid confusion with C<break> keyword.

=cut

sub hit_breaks {
  my ($self) = @_;
  return $self->state->hit_breaks();
}

=head2 turn_on()

Turns on the car

=cut

sub turn_on {
  my ($self) = @_;
  return $self->state->turn_on();
}

=head2 turn_off()

Turns off the car

=cut


sub turn_off {
  my ($self) = @_;
  return $self->state->turn_off();
}

=head2 drive()

Puts the car in B<DRIVE>

=cut

sub drive {
  my ($self) = @_;
  return $self->state->drive();
}

=head2 park()

Parks the car.

=cut

sub park {
  my ($self) = @_;
  return $self->state->park();
}

1;


