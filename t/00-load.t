#!/usr/bin/perl -w

use strict;
use lib 'lib';
use Test::More qw(no_plan);
use_ok("WWW::Bookmarks");

my $bm = WWW::Bookmarks->new( server => 'bookmarks.socklabs.com' );
ok($bm, "have WWW::Bookmarks");
