package Printer;

use strict;
use warnings;
use Term::ANSIColor;
use Data::Dumper;
use Term::ReadKey;
use feature 'state';

state $SIZE = 20;

sub new {
    my $class = shift;

    my $self = { 
        websites => $_[0], 
        reddits => $_[1], 
        histories => $_[2], 
    };

    bless $self, $class;

    return $self;
}

# sub setWebsites {
#     my $self     = shift;
#     my @websites = @{ $_[0] };

#     $self->{websites} = @websites;

#     return $self;
# }

# sub setHistories {
#     my $self      = shift;
#     my @histories = shift;

#     $self->{histories} = @histories;

#     return $self;
# }

sub printPadding {
    my $self = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();
    my $padding = ( $wchar - ( $wchar - $SIZE ) ) / 2;
    my $line    = "";

    for ( $a = 0 ; $a < $padding ; $a = $a + 1 ) {
        $line .= " ";
    }

    return $line;
}

sub printLine {
    my $self = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    my $line = $self->printPadding();

    $line .= "┌";
    for ( $a = 0 ; $a < $wchar - $SIZE ; $a = $a + 1 ) {
        $line .= "─";
    }
    $line .= "┐";

    $line .= "\n";

    return $line;
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

sub printEndLine {
    my $self = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    my $line = $self->printPadding();

    $line .= "└";
    for ( $a = 0 ; $a < $wchar - $SIZE ; $a = $a + 1 ) {
        $line .= "─";
    }
    $line .= "┘";

    $line .= "\n";

    return $line;
}

sub printBorder {
    my $self    = shift;
    my $minimal = shift;
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    my $line = $self->printPadding();

    $line .= "│";
    for ( $a = 0 ; $a < $wchar - $SIZE ; $a = $a + 1 ) {
        $line .= " ";
    }
    $line .= "│";
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
    my ( $wchar, $hchar, $wpixels, $hpixels ) = GetTerminalSize();

    my @websites  = @{ $self->{websites} };
    my @reddits  = @{ $self->{reddits} };
    my @histories = @{ $self->{histories} };

    my $output = '';

    my @list = (@websites, @reddits);

    foreach (@list) {
        my $count = ( $wchar - $SIZE - length( $_->{name} ) - 1 );
        $output .= $self->printLine();

        $output .= $self->printPadding();
        $output .= "│ ";
        $output .= $_->{name};

        for ( my $i = 0 ; $i < $count ; $i++ ) {
            $output .= ' ';
        }
        $output .= "│";
        $output .= "\n";

        $output .= $self->printEndLine();

        $output .= "\n";

        foreach ( @{ $_->{articles} } ) {
            $output .= $self->printPadding();

            my $link   = $_->{link};
            my $text   = $_->{text};
            my $isRead = $self->isInHistories($link);

            $text =~ s/^\s+|\s+$//g;

            if ( !$isRead ) {
                $output .= sprintf "  - %.*s", ( $wchar - $SIZE - 3 ), $text;
                $output .= "\n";
            }
        }

        $output .= "\n";
    }

    return $output;
}

1;
