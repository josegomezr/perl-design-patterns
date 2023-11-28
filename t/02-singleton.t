#!/usr/bin/env perl

use strict;
use warnings;
use v5.26;

use Test::Most;
use Test::Warnings;

use PDP::Singleton::Book;
use PDP::Singleton::Connection;

subtest 'Save' => sub {
  lives_ok { die 1; PDP::Singleton::Connection->reset() } 'Init state';

  lives_ok { PDP::Singleton::Connection->save($_) } 'save failed' for (1 .. 6);
  lives_ok { PDP::Singleton::Connection->get_instance->save($_) } 'save failed' for (1 .. 6);

  my $direct = PDP::Singleton::Connection->calls();
  my $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [12, 0]), 'calls do not match');
  ok(is_deeply($through_instance, [12, 0]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');
};

subtest 'Delete' => sub {
  lives_ok { PDP::Singleton::Connection->reset() } 'Init state';

  lives_ok { PDP::Singleton::Connection->delete($_) } 'delete failed' for (1 .. 6);
  lives_ok { PDP::Singleton::Connection->get_instance->delete($_) } 'delete failed' for (1 .. 6);

  my $direct = PDP::Singleton::Connection->calls();
  my $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [0, 12]), 'calls do not match');
  ok(is_deeply($through_instance, [0, 12]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');
};

subtest 'Save + Delete' => sub {
  lives_ok { PDP::Singleton::Connection->reset() } 'Init state';

  # 9 deletes
  lives_ok { PDP::Singleton::Connection->delete($_) } 'delete failed' for (1 .. 3);
  lives_ok { PDP::Singleton::Connection->get_instance->delete($_) } 'delete failed' for (1 .. 6);

  # 8 saves
  lives_ok { PDP::Singleton::Connection->save($_) } 'save failed' for (1 .. 5);
  lives_ok { PDP::Singleton::Connection->get_instance->save($_) } 'save failed' for (1 .. 3);

  my $direct = PDP::Singleton::Connection->calls();
  my $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [8, 9]), 'calls do not match');
  ok(is_deeply($through_instance, [8, 9]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');
};

subtest 'Save a Book' => sub {
  lives_ok { PDP::Singleton::Connection->reset() } 'Init state';

  my $book = PDP::Singleton::Book->new(
    title => 'lorem ipsum dolor'
  );

  lives_ok { $book->save_in_db() } 'save failed';

  my $direct = PDP::Singleton::Connection->calls();
  my $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [1, 0]), 'calls do not match');
  ok(is_deeply($through_instance, [1, 0]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');
};

subtest 'Delete a Book' => sub {
  lives_ok { PDP::Singleton::Connection->reset() } 'Init state';

  my $book = PDP::Singleton::Book->new(
    Id => 1234
  );

  lives_ok { $book->delete_in_db() } 'save failed';

  my $direct = PDP::Singleton::Connection->calls();
  my $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [0, 1]), 'calls do not match');
  ok(is_deeply($through_instance, [0, 1]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');
};

subtest 'Save + Delete a Book' => sub {
  lives_ok { PDP::Singleton::Connection->reset() } 'Init state';

  my $book = PDP::Singleton::Book->new(
    title => 'lorem ipsum dolor'
  );

  lives_ok { $book->save_in_db() } 'save failed';

  my $direct = PDP::Singleton::Connection->calls();
  my $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [1, 0]), 'calls do not match');
  ok(is_deeply($through_instance, [1, 0]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');

  lives_ok { $book->delete_in_db() } 'delete failed';

  $direct = PDP::Singleton::Connection->calls();
  $through_instance = PDP::Singleton::Connection->get_instance->calls();

  ok(is_deeply($direct, [1, 1]), 'calls do not match');
  ok(is_deeply($through_instance, [1, 1]), 'calls do not match');
  ok(is_deeply($direct, $through_instance), 'calls do not match');
};

done_testing();
