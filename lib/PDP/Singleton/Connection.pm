package PDP::Singleton::Connection;

=encoding utf8

=head1 NAME

C<PDP::Singleton::Connection> - An example of a singleton class

=head1 SYNOPSIS

  use PDP::Singleton::Connection;

  # it's all fake, like the cake
  PDP::Singleton::Connection->save('table', $object);
  PDP::Singleton::Connection->delete('table', $object);

=head1 DESCRIPTION

C<PDP::Singleton::Connection> is an example persistent database connection. It's
instanciated only once and then used through the lifecycle of the object.

This is to mimic a DBAL that receives objects and persist/deletes them from the
DB.

=over 1

=back

=cut

use strict;
use warnings;
use utf8;
use feature ':5.26';
use Carp qw(croak);
use parent 'PDP::BaseClass';

=head1 CONSTRUCTORS

C<PDP::Singleton::Connection> inherits from C<PDP::BaseClass> but redefines the
constructor so it can only be called internally.

Perl has no concept of member visibility like other OOP languages have, this is
the closest simplest approach I found. I'm not sure how private it is, but at
the very least it can be considered "protected".

It just checks that the caller is the current package, and dies if not.

=head2 new

Instantiates a Singleton.

=over 2

=back

=cut

sub new {
  my ($caller_name, $caller_path, $caller_line, $sub_name) = caller(0);

  # Validate that new was called within the package.
  if (__PACKAGE__ ne $caller_name) {
    return croak('Forbidden call to private constructor');
  }

  # Make the object
  my $class = shift;
  my $self = $class->SUPER::new(@_);

  # Initial State
  $self->reset();

  return $self;
}

=head1 ATTRIBUTE ACCESSORS

=over 1

=back

=head2 calls

How many save/delete calls had happened during the lifecycle of our singleton.

Mainly to be able to assert that there's no leak of instances.

=cut

sub calls {
  my ($self) = get_instance(shift);

  return [$self->{save_calls}, $self->{delete_calls}];
}

=head1 SINGLETON METHODS

=over 1

=back

=head2 singleton()

Creates the singleton instance.

This uses a variable L<state> defined variable. This variable will outlive
method calls effectively serving as a persitent storage for our singleton.

Because this method lives inside the package, it has access to C<new> and in
turn can create the instance.

It's confusing at first sight because it reads like an unconditional assignment
to C<$loop> but according to perl docs:

    When combined with variable declaration, simple assignment to state
    variables is executed only the first time. When such statements are
    evaluated subsequent times, the assignment is ignored.

=cut

sub singleton {
  state $loop = shift->new;
}


=head2 get_instance()

Returns the singleton instance.

With some dark magic this method checks if this is being called
in "static-context" (meaning without a $self) and returns C<singleton>, but
when it's called in "object-context" (meaning $obj->get_instance) then it
returns itself.

Thanks to L<ref> this differenciation can be asserted, for future me this reads
as:

IF C<$self> is a reference, then it's an instance of this class, we just return
it. Else return C<singleton>.

A reference is akin to a pointer, it means is not an immediate value but rather
it points to where the actual value resides.

=cut

# Heavily stolen from Mojo::IOLoop, only expanded $_ for a more verbose source.

sub get_instance {
  my ($self) = @_;

  return $self if (ref $self);
  return $self->singleton;
}

=head2 save(table, object)

Saves to the DB.

=cut

sub save {
  my ($self, $table, $object) = (get_instance(shift), @_);
  # Here there'd be something that does DB Queries
  # like:
# "UPDATE $table SET {fieldspec...} where pk = $object->{Id}" when $object->{Id} exists.
  # or
  # INSERT INTO $table {fieldspec...} when $object->{Id} does not exist.
  ++$self->{save_calls};
}

=head2 delete(table, object)

Deletes from the DB

=cut

sub delete {
  my ($self, $table, $object) = (get_instance(shift), @_);
  # Here there'd be something that does DB Queries
  # like:
  # DELETE FROM $table WHERE pk = $object->{Id}
  ++$self->{delete_calls};
}

=head2 reset()

Restarts the DB

Just for the sake of testing. Else all tests will depend on the result of the
previous one and that's just a mess...

=cut

sub reset {
  my ($self) = get_instance(shift);
  $self->{delete_calls} = 0;
  $self->{save_calls} = 0;
}

1;
