package TAP::Formatter::GitHubAction;

use strict;
use warnings;
use base 'TAP::Formatter::File';

# My file, my terms.
my $TRIPHASIC_REGEX = qr/\s*Failed test( '(?<test_name>[^']+)'\n\s*#\s+)? at (?<filename>.+) line (?<line>\d+)\.\n(?<context_msg>[\w\W]*)/;

sub open_test {
  my ($self, $description, $parser) = @_;
  my $session = $self->SUPER::open_test($description, $parser);

  # We'll use the parser as a vessel, afaics there's one parser instance per
  # parallel job.

  # We'll keep track of all output of a test with this.
  $parser->{_fail_msgs} = [''];

  # In an ideal world, we'd just need to listen to `comment` and that should
  # suffice, but `throws_ok` & `lives_ok` report via `unknown`...
  # But this is real life...
  my $handler = sub {
    my $result = shift;

    # on every "failed test", start a new buffer.
    push(@{$parser->{_fail_msgs}}, '') if $result->raw =~ /Failed test/;

    # Don't save the last message, it's useless.
    return if $result->raw =~ /Looks like/;
    return unless $result->raw =~ /^\s*#/;
    # save the message.
    $parser->{_fail_msgs}[-1] .= $result->raw . "\n";
  };

  $parser->callback(comment => $handler);
  $parser->callback(unknown => $handler);

  return $session;
}

sub summary {
  my ($self, $aggregate, $interrupted) = @_;

  $self->SUPER::summary($aggregate, $interrupted);

  my $total = $aggregate->total;
  my $passed = $aggregate->passed;

  return if ($total == $passed && !$aggregate->has_problems);

  for my $test ($aggregate->descriptions) {
    my ($parser) = $aggregate->parsers($test);

    next if $parser->passed == $parser->tests_run && !$parser->exit;

    my $failures_per_line = {};
    # First pass, aggregate errors in the same line into a single error.
    # This is mostly cosmetic not to spam the UI that hard.
    for my $line (@{$parser->{_fail_msgs}}) {
      # Skip anything that doesn't look like our TRIPHASIC REGEX
      next unless $line =~ qr/$TRIPHASIC_REGEX/m;
      # Extract all variables
      my ($line, $fail_message, $context_msg) = ($+{line}, $+{test_name} // 'fail test', $+{context_msg});
      $failures_per_line->{$line} //= ();

      # Eat up any trailing whitespace
      chomp($context_msg);
      # Remove indentation before the #
      $context_msg =~ s/^\s*//gm;

      $fail_message = "- $fail_message";
      if ($context_msg) {
        # Indent
        $context_msg =~ s/^/    /gm;
        # Encode all newlines
        $context_msg =~ s/\n/%0A/g;
        # Render a block
        $fail_message .= "%0A    --- START OF CONTEXT ---";
        $fail_message .= "%0A$context_msg";
        $fail_message .= "%0A    --- END OF CONTEXT ---";
      }

      push(@{$failures_per_line->{$line}}, $fail_message);
    }

    # Second pass: Print the aggregations
    for my $line (keys %$failures_per_line) {
      my $message = join("%0A%0A", @{$failures_per_line->{$line}});

      my $log_line = sprintf(
        "::error file=%s,line=%s,title=Failed Tests::%s",
        $test, $line, $message
      );
      $self->_output("$log_line\n");
    }
  }
}

1;
