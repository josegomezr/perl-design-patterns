#!/usr/bin/env perl

use strict;
use warnings;
use v5.26;

use Test::Most;
use Test::Warnings;

use PDP::State::Car;
use PDP::State::CarState::Base;
use PDP::State::CarState::TurnedOff;
use PDP::State::CarState::TurnedOn;
use PDP::State::CarState::Driving;

# Enumerate all states here
my @states = qw(
  PDP::State::CarState::Base PDP::State::CarState::TurnedOff PDP::State::CarState::TurnedOn
  PDP::State::CarState::Driving
);

# Define here all methods for states & actors.
my @common_interface_methods = qw(
  turn_on turn_off drive park accelerate hit_breaks
);

my @state_methods = ('can_transition_to', @common_interface_methods);
my @actor_methods = ('transition_to', @common_interface_methods);

subtest 'Interface' => sub {
  # Validate
  can_ok('PDP::State::Car', @actor_methods);
  map { can_ok($_, @state_methods) } @states;
};

subtest 'Base State Interface' => sub {
  my $state = PDP::State::CarState::Base->new();

  foreach my $method (@state_methods) {
    throws_ok {
      $state->$method();
    } qr/Method '$method' not implemented by subclass PDP::State::CarState::Base/, 'Subclass must define method!';
  }
};

subtest 'Car - Inital State: Turned Off' => sub {
  {
    my $car = PDP::State::Car->new();
    throws_ok {
      $car->turn_off();
    } qr/cannot turn_off in PDP::State::CarState::TurnedOff/, 'it cannot turn_off!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new();
    throws_ok {
      $car->drive();
    } qr/cannot drive in PDP::State::CarState::TurnedOff/, 'it cannot drive!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new();
    throws_ok {
      $car->park();
    } qr/cannot park in PDP::State::CarState::TurnedOff/, 'it cannot park!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new();
    throws_ok {
      $car->accelerate();
    } qr/cannot accelerate in PDP::State::CarState::TurnedOff/, 'it cannot accelerate!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new();
    throws_ok {
      $car->hit_breaks();
    } qr/cannot hit_breaks in PDP::State::CarState::TurnedOff/, 'it cannot hit_breaks!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOff', 'state did not change');
  }

};
done_testing();
exit;

subtest 'Car - turn off' => sub {
  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    throws_ok {
      $car->turn_on();
    } qr/cannot turn_on in PDP::State::CarState::TurnedOn/, 'it cannot turn_on!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOn', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    throws_ok {
      $car->park();
    } qr/cannot park in PDP::State::CarState::TurnedOn/, 'it cannot park!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOn', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    lives_ok {
      $car->drive();
    } 'it can drive!';
    isa_ok($car->state, 'PDP::State::CarState::Driving', 'state changed');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    lives_ok {
      $car->turn_off();
    } 'it can turn off!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOff', 'state changed');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    throws_ok {
      $car->accelerate();
    } qr/cannot accelerate in PDP::TurnedOn::Driving/, 'it cannot accelerate!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOn', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    throws_ok {
      $car->hit_breaks();
    } qr/cannot hit_breaks in PDP::TurnedOn::Driving/, 'it cannot hit_breaks!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOn', 'state did not change');
  }

};

subtest 'Car - drive' => sub {
  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::Driving->new());
    throws_ok {
      $car->turn_off();
    } qr/cannot turn_off in PDP::State::CarState::Driving/, 'it cannot turn off!';
    isa_ok($car->state, 'PDP::State::CarState::Driving', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::Driving->new());
    throws_ok {
      $car->turn_on();
    } qr/cannot turn_on in PDP::State::CarState::Driving/, 'it cannot turn on!';
    isa_ok($car->state, 'PDP::State::CarState::Driving', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::Driving->new());
    throws_ok {
      $car->drive();
    } qr/cannot drive in PDP::State::CarState::Driving/, 'it cannot drive!';
    isa_ok($car->state, 'PDP::State::CarState::Driving', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::Driving->new());
    lives_ok {
      $car->park();
    } 'it can park!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOn', 'state changed');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::Driving->new());
    lives_ok {
      $car->accelerate(10);
    } 'it can accelerate!';
    isa_ok($car->state, 'PDP::State::CarState::Driving', 'state did not change');
  }

  {
    my $car = PDP::State::Car->new(state => PDP::State::CarState::TurnedOn->new());
    throws_ok {
      $car->hit_breaks();
    } 'it can hit_breaks!';
    isa_ok($car->state, 'PDP::State::CarState::TurnedOn', 'state did not change');
  }
};

done_testing();
