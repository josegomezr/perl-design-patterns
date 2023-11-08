#!/usr/bin/env perl

use strict;
use warnings;
use v5.26;

use Test::Most;
use Test::Warnings;

use PDP::Car;
use PDP::State::BaseState;
use PDP::State::TurnedOff;
use PDP::State::TurnedOn;
use PDP::State::Driving;

# Enumerate all states here
my @states = qw(
  PDP::State::BaseState PDP::State::TurnedOff PDP::State::TurnedOn
  PDP::State::Driving
);

# Define here all methods for states & actors.
my @common_interface_methods = qw(
  turn_on turn_off drive park
);

my @state_methods = ('can_transition_to', @common_interface_methods);
my @actor_methods = ('transition_to', @common_interface_methods);

subtest 'Interface' => sub {
  # Validate
  can_ok('PDP::Car', @actor_methods);
  map { can_ok($_, @state_methods) } @states;
};

subtest 'Base State Interface' => sub {
  my $state = PDP::State::BaseState->new();

  foreach my $method (@state_methods) {
    throws_ok {
      $state->$method();
    } qr/Method '$method' not implemented by subclass PDP::State::BaseState/, 'Subclass must define method!';
  }
};

subtest 'Car - turn on' => sub {
  {
    my $car = PDP::Car->new();
    throws_ok {
      $car->turn_off();
    } qr/cannot turn_off in PDP::State::TurnedOff/, 'it cannot turn_off!';
    isa_ok($car->state, 'PDP::State::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::Car->new();
    throws_ok {
      $car->drive();
    } qr/cannot drive in PDP::State::TurnedOff/, 'it cannot drive!';
    isa_ok($car->state, 'PDP::State::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::Car->new();
    throws_ok {
      $car->park();
    } qr/cannot park in PDP::State::TurnedOff/, 'it cannot park!';
    isa_ok($car->state, 'PDP::State::TurnedOff', 'state did not change');
  }

  {
    my $car = PDP::Car->new();
    lives_ok {
      $car->turn_on();
    } 'it can turn on!';
    isa_ok($car->state, 'PDP::State::TurnedOn', 'state changed');
  }

};

subtest 'Car - turn off' => sub {
  {
    my $car = PDP::Car->new(state => PDP::State::TurnedOn->new());
    throws_ok {
      $car->turn_on();
    } qr/cannot turn_on in PDP::State::TurnedOn/, 'it cannot turn_on!';
    isa_ok($car->state, 'PDP::State::TurnedOn', 'state did not change');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::TurnedOn->new());
    throws_ok {
      $car->park();
    } qr/cannot park in PDP::State::TurnedOn/, 'it cannot park!';
    isa_ok($car->state, 'PDP::State::TurnedOn', 'state did not change');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::TurnedOn->new());
    lives_ok {
      $car->drive();
    } 'it can drive!';
    isa_ok($car->state, 'PDP::State::Driving', 'state changed');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::TurnedOn->new());
    lives_ok {
      $car->turn_off();
    } 'it can turn off!';
    isa_ok($car->state, 'PDP::State::TurnedOff', 'state changed');
  }
};

subtest 'Car - drive' => sub {
  {
    my $car = PDP::Car->new(state => PDP::State::Driving->new());
    throws_ok {
      $car->turn_off();
    } qr/cannot turn_off in PDP::State::Driving/, 'it cannot turn off!';
    isa_ok($car->state, 'PDP::State::Driving', 'state did not change');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::Driving->new());
    throws_ok {
      $car->turn_on();
    } qr/cannot turn_on in PDP::State::Driving/, 'it cannot turn on!';
    isa_ok($car->state, 'PDP::State::Driving', 'state did not change');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::Driving->new());
    throws_ok {
      $car->drive();
    } qr/cannot drive in PDP::State::Driving/, 'it cannot drive!';
    isa_ok($car->state, 'PDP::State::Driving', 'state did not change');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::Driving->new());
    lives_ok {
      $car->park();
    } 'it can park!';
    isa_ok($car->state, 'PDP::State::TurnedOn', 'state changed');
  }

  {
    my $car = PDP::Car->new(state => PDP::State::Driving->new());
    lives_ok {
      $car->accelerate(10);
    } 'it can accelerate!';
    isa_ok($car->state, 'PDP::State::Driving', 'state did not change');
  }
};

done_testing();
