package PDP::Singleton::Book;

=encoding utf8

=head1 NAME

PDP::Singleton::Book - An example DB ORM "model".

=head1 SYNOPSIS

  use PDP::Singleton::Book;

  # it's all fake, like the cake
  my $book = PDP::Singleton::Book->new(
    title => 'lorem ipsum dolor'
  );

  # Persist it
  $book->save_in_db();

  # Delete it
  $book->delete_in_db();

=head1 DESCRIPTION

It represent a book that we can save and delete from the DB.

=cut

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

use PDP::Singleton::Connection ();

=head2 _db()

B<PRIVATE> just a shortcut for C<PDP::Singleton::Connection-E<gt>get_instance()>.

Yeah I save characters in weird places...

=cut

sub _db {
  return PDP::Singleton::Connection->get_instance();
}

=head2 save_in_db()

Saves the book to the DB.

=cut

sub save_in_db {
  my ($self) = @_;

  $self->_db->save('user', $self);
}

=head2 delete_in_db()

Deletes the book from the DB.

=cut

sub delete_in_db {
  my ($self) = @_;

  $self->_db->delete('user', $self);
}

1;
