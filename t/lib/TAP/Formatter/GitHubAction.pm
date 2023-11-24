package TAP::Formatter::GitHubAction;

use strict;
use warnings;
use base 'TAP::Formatter::File';

# My file, my terms.
my $TRIPHASIC_REGEX = qr/\s*Failed test( '(?<test_name>[^']+)'\n\s*#\s+)? at (?<filename>.+) line (?<line>\d+)/;

sub open_test {
  my ($self, $description, $parser) = @_;
  my $session = $self->SUPER::open_test($description, $parser);

  # We'll use the parser as a vessel, afaics there's one parser instance per
  # parallel job.

  # We'll keep track of all output of a test with this.
  $parser->{_fail_msgs} = [''];

  # In an ideal world, we'd just need to listen to `comment` and that should
  # suffice, but `throws_ok` & `lives_ok` report via `unknown`...
  # So we'll capture simply all output and regex filter later.
  $parser->callback(ALL => sub {
    my $result = shift;
    # on every "failed test", start a new buffer.
    push (@{$parser->{_fail_msgs}}, '') if $result->raw =~ /Failed test/;

    # Don't save the last message, it's useless.
    return if $result->raw =~ /Looks like/;
    # save the message.
    $parser->{_fail_msgs}[-1] .= $result->raw . "\n";
  });

  return $session;
}

sub summary {
  my ($self, $aggregate, $interrupted) = @_;
  
  $self->SUPER::summary($aggregate, $interrupted);

  my $total = $aggregate->total;
  my $passed = $aggregate->passed;

  if ($total == $passed && !$aggregate->has_problems) {
    return;
  }

  for my $test ($aggregate->descriptions) {
    my ($parser) = $aggregate->parsers($test);

    next if $parser->passed == $parser->tests_run && !$parser->exit;

    for my $line (@{$parser->{_fail_msgs}}){
      next unless $line =~ qr/$TRIPHASIC_REGEX/m;
      my ($line, $fail_message) = ($+{line}, $+{test_name} // 'failed test');
      
      my $log_line = sprintf("::error file=%s,line=%s::%s", $test, $line, $fail_message);
      $self->_output("$log_line\n");
    }
  }
}

1;
