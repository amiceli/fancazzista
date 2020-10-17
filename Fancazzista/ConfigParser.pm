package ConfigParser;

use strict;
use warnings;
use JSON;

sub new {
    my $class = shift;

    my $self = { 'path' => shift, 'config' => {} };

    bless $self, $class;

    return $self;
}

sub readConfig {
    my $self = shift;

    my $json_text = do {
        open( my $json_fh, "<:encoding(UTF-8)", $self->{path} );
        local $/;
        <$json_fh>;
    };

    $self->{config} = decode_json $json_text;
}

sub getHistoryFilename {
    my $filename = $ENV{HOME} . '/.fancazzista';

    return $filename;
}

sub readHistory {
    my $self     = shift;
    my $filename = $self->getHistoryFilename();

    unless ( -e $filename ) {
        open FH, ">", $filename;
        close FH;
    }

    open( FH, '<', $filename ) or die $!;

    my @histories = <FH>;

    close(FH);

    return @histories;
}

sub writeHistory {
    my $self     = shift;
    my @articles = @{ $_[0] };
    my $filename = $self->getHistoryFilename();

    open( FH, '>', $filename ) or die $!;

    foreach (@articles) {
        print FH $_, "\n";
    }

    close(FH);
}
1;
