package Printer;

use strict;
use warnings;
use Term::ANSIColor;
use Data::Dumper;
use Term::ReadKey;

sub new {
    my $class = shift;

    my $self = { 
        websites => $_[0], 
        reddits => $_[1], 
        histories => $_[2], 
        withMarkdown => 0,
    };

    bless $self, $class;

    return $self;
}

sub setWithMarkdown {
    my $self = shift;
    my $withMarkdown = shift;

    $self->{withMarkdown} = $withMarkdown;

    return $self;
}

sub printSub {
    my $self  = shift;
    my $limit = shift;

    my $line = "";
    for ( $a = 0 ; $a < $limit ; $a = $a + 1 ) {
        $line .= "-";
    }

    $line .= "\n";

    return $line;
}

sub isInHistories {
    my $self      = shift;
    my $link      = shift;
    my @histories = @{ $self->{histories} };

    $link =~ s/^\s+|\s+$//g;

    return grep( /^$link/i, @histories );
}

sub display {
    my ($self) = @_;
    my ( $wchar ) = GetTerminalSize();

    my @websites  = @{ $self->{websites} };
    my @reddits  = @{ $self->{reddits} };
    my @histories = @{ $self->{histories} };

    my $output = '';

    my @list = (@websites, @reddits);

    foreach (@list) {
        my $showSection = 0;

        foreach ( @{ $_->{articles} } ) {
            my $isRead = $self->isInHistories($_->{link});

            if (!$isRead) { $showSection += 1;}
        }

        if ($showSection >= 1) {
            if ($self->{withMarkdown} && defined $_->{url}) {
                $output .= sprintf "[%s](%s)", $_->{name}, $_->{url};
            } else {
                $output .= $_->{name};
            }

            $output .= "\n";
            $output .= "\n";

            foreach ( @{ $_->{articles} } ) {
                my $link   = $_->{link};
                my $text   = $_->{text};
                my $isRead = $self->isInHistories($link);

                $text =~ s/^\s+|\s+$//g;

                if ( !$isRead ) {
                    my $cutText = sprintf "%.*s", $wchar - 10, $text;

                    if ($self->{withMarkdown}) {
                        $output .= sprintf(" - [%s](%s)", $cutText, $_->{link});
                    } else {
                        $output .= $cutText;
                    }

                    $output .= "\n";
                }
            }

            $output .= "\n";
        }
    }

    return $output;
}

1;
