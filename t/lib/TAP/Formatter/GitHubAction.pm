package TAP::Formatter::GitHubAction;

use strict;
use warnings;
use base 'TAP::Formatter::File';

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

    my $log_line = sprintf("::error file=%s,title=Testcase failed::Tests: %s", $test, $parser->tests_run);

    if (scalar $parser->failed > 0) {
      $log_line .= sprintf(' -- Failed: %s', scalar $parser->failed);
    }

    if (scalar $parser->todo_passed > 0) {
      $log_line .= sprintf(' -- TODO: %s', scalar $parser->todo_passed);
    }

    if (scalar $parser->parse_errors > 0) {
      $log_line .= sprintf(' -- Parse Error: %s', scalar $parser->parse_errors);
    }

    $log_line .= ' -- See the logs for more details';

    $self->_output("$log_line\n");
  }
}

1;
