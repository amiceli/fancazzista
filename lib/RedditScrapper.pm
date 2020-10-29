package RedditScrapper;

use strict;
use warnings;
use LWP::UserAgent;
use HTTP::Request;
use JSON;
use Encode qw(encode);
use Data::Dumper;

sub new {
    my $class = shift;

    my $self = {};

    bless $self, $class;

    return $self;
}

sub scrap {
    my $self   = shift;
    my $config = shift;

    my @subreddits = ();

    foreach ( @{ $config->{subreddits} } ) {
        my @posts = $self->getPosts($_);

        push @subreddits, {
            name => $_->{name},
            url => "https://www.reddit.com/r/" . $_->{name},
            articles => \@posts
        };
    }

    return @subreddits;
}

sub getPosts {
    my $self    = shift;
    my $subreddit = shift;

    my $base = "https://www.reddit.com/r/";
    my $url = $base . $subreddit->{name} . "/new.json?limit=" . ($subreddit->{limit} || 5);
    my $r      = HTTP::Request->new( 'GET', $url);
    my $ua       = LWP::UserAgent->new();
    my $response = $ua->request($r);

    my @subreddits = ();

    if ( $response->is_success ) {
        my $responseContent = decode_json $response->decoded_content;
        my @children = @{ $responseContent->{data}->{children} };

        foreach (@children) {
            my $text = $_->{data}->{title};
            $text =~ s/^\s+|\s+$//g;

            push @subreddits, {
                text => encode( 'utf8', $text), link => $_->{data}->{url}
            };
        }
    } else {
        die $response->status_line;
    }

    return @subreddits;
}

1;
