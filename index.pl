#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use Fancazzista::Scrapper;
use Fancazzista::ConfigParser;
use Getopt::Long;
use Fancazzista::Printer;
use Data::Dumper;

my $configFilePath;

GetOptions( 'config=s' => \$configFilePath, );

if ( not defined $configFilePath ) {
    die "Config file path is required";
}

my $configParser = new ConfigParser($configFilePath);
my $config       = $configParser->readConfig();
my @histories    = $configParser->readHistory();

my $scrapper = new Scrapper();
my @websites = $scrapper->scrap($config);

my $printer = new Printer( \@websites, \@histories );

my $output = $printer->display();

print $output;

my @articles = ();

for my $item (@websites) {
    my @map = map { $_->{link} } @{ $item->{articles} };

    push @articles, @map;
}

$configParser->writeHistory( \@articles )

