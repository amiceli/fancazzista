#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use lib './lib/';
use Fancazzista::Scrapper;
use Fancazzista::RedditScrapper;
use Fancazzista::ConfigParser;
use Getopt::Long;
use Fancazzista::Printer;

my $configFilePath;
my $markDownOutput = 0;

GetOptions(
    'config=s' => \$configFilePath, 
    'markdown' => \$markDownOutput, 
);

if ( not defined $configFilePath ) {
    die "Config file path is required";
}

my $configParser = new ConfigParser($configFilePath);
my $config       = $configParser->readConfig();
my @histories    = $configParser->readHistory();

my $scrapper       = new Scrapper();
my $redditScrapper = new RedditScrapper();

my @websites = $scrapper->scrap($config);
my @reddits  = $redditScrapper->scrap($config);

my $printer = new Printer( \@websites, \@reddits, \@histories );

my $output = $printer->setWithMarkdown($markDownOutput)->display();

print $output;

my @articles = ();

for my $item (@websites) {
    my @map = map { $_->{link} } @{ $item->{articles} };

    push @articles, @map;
}

for my $item (@reddits) {
    my @map = map { $_->{link} } @{ $item->{articles} };

    push @articles, @map;
}

$configParser->writeHistory( \@articles )

