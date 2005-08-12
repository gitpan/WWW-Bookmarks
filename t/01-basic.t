#!/usr/bin/perl -w

use strict;

use lib 'lib';

use Test::More qw(no_plan);

use_ok("WWW::Bookmarks");

my $bm = WWW::Bookmarks->new( server => 'bookmarks.socklabs.com' );
ok( $bm, "Object created." );

$bm->login( "testuser", "password" );
ok( $bm->{authkey}, "Test user logged in." );

my $urlid = $bm->addbookmark(
	url => 'http://www.testurl.com',
	tags => 'test,example,nothing special',
	description => 'just a test url'
);
ok( $urlid, "Test url create called." );

my $burl = $bm->batchurl( 'http://www.testurl.com/' );
ok( $burl->{1}->{tags}, "Url found in system.");

my $newtag = $bm->addtag( urlid => $urlid, name => 'tests and examples' );
ok($newtag, 'Addtag called');

my $burl2 = $bm->batchurl( 'http://www.testurl.com/' );
like($burl2->{1}->{tags}, qr/tests and examples/ ,"Tag added to url in system");

TODO: {
        local $TODO = 'This is broken...';
	ok( $bm->deletetag( tagid => $newtag ), "Deletetag called." );
	my $burl3 = $bm->batchurl( 'http://www.testurl.com/' );
	unlike($burl3->{1}->{tags}, qr/tests and examples/ ,"Tag removed from url in system");
};

ok( $bm->deletebookmark( urlid => $urlid ), "Url delete called." );

my $burl4 = $bm->batchurl( 'http://www.testurl.com/' );
ok(!$burl4->{1}->{tags}, "Url not present in system.");
