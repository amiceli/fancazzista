#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use lib './lib/';
use Fancazzista::Scrap;
use ConfigParser;
use Getopt::Long;
use Printer;

my $configFilePath;
my $markDownOutput = 0;
my $htmlOutput     = 0;

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
my @list         = Fancazzista::Scrap::scrapContent($config);

my $printer = new Printer( \@list, \@histories );

my $output = $printer->withMarkdown($markDownOutput)->display();

print $output;

my @articles = ();

for my $item (@list) {
    my @map = map { $_->{link} } @{ $item->{articles} };

    push @articles, @map;
}

$configParser->writeHistory( \@articles )

