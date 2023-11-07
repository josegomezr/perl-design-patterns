#!/usr/bin/env perl

use strict;
use warnings;
use v5.26;

use Test::Most;
use Test::Warnings;

use PDP::Car;
my $car = PDP::Car->new();

subtest 'Car - turn on' => sub {
  throws_ok { $car->turn_off() } qr/Can't turn off a car that's turned off!/, 'it cannot turn off!';
  isa_ok($car->state, 'PDP::State::TurnedOff', 'state did not changed');

  lives_ok { $car->turn_on() } 'it can turn on!';
  isa_ok($car->state, 'PDP::State::TurnedOn', 'state changed');
};

subtest 'Car - turn off' => sub {
  throws_ok { $car->turn_on() } qr/Can't turn on a car that's turned on!/, 'it cannot turn on!';
  isa_ok($car->state, 'PDP::State::TurnedOn', 'state did not changed');

  lives_ok { $car->turn_off() } 'it can turn off!';
  isa_ok($car->state, 'PDP::State::TurnedOff', 'state changed');
};

subtest 'Car - drive + park' => sub {
  lives_ok { $car->turn_on() } 'it can turn on!';

  isa_ok($car->state, 'PDP::State::TurnedOn', 'state changed');

  lives_ok { $car->drive() } 'it can start driving!';

  isa_ok($car->state, 'PDP::State::Driving', 'state changed');
  is($car->speed, 0, 'speed starts at 0');

  lives_ok { $car->accelerate(10) } 'it can accelerate';

  isa_ok($car->state, 'PDP::State::Driving', 'state did not change');
  is($car->speed, 10, 'speed is now 10');

  lives_ok { $car->hit_breaks() } 'it can break';

  isa_ok($car->state, 'PDP::State::Driving', 'state did not change');
  is($car->speed, 0, 'speed is now 0');

  lives_ok { $car->park() } 'it can break';

  isa_ok($car->state, 'PDP::State::TurnedOn', 'state changed');

};

done_testing();
