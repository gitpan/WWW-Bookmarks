package WWW::Bookmarks;

use strict;
use warnings;

use XMLRPC::Lite;
use XML::Simple;
use Data::Dumper;

use vars qw($VERSION);
$VERSION = "0.01";

=head1 NAME

WWW::Bookmarks - An XMLRPC interface to any Bookmarks server

=head1 SYNOPSIS

  use WWW::Bookmarks;
  my $bm = WWW::Bookmarks->new(
    server => 'bookmarks.socklabs.com'
  );

  $bm->login('joe average', 'n0tgonnatell');
  
  my $urlid = $bm->addbookmark(
    url => 'http://www.testurl.com',
    tags => 'test,example,nothing special',
    description => 'just a test url'
  );
  my $newtag = $bm->addtag( urlid => $urlid, name => 'tests and examples' );
  
  my $url = $bm->batchurl( 'http://www.testurl.com/' );
  
  $bm->deletebookmark( urlid => $urlid );

=head1 DESCRIPTION

This module takes advantage of the extensive xmlrpc interface provided by
public Bookmarks servers and allows registered users to interact with the
site just as they would normally.

The Bookmarks XMLRPC API dicates that all user based functionality requires
an authkey provided by the server during the login call. In the METHODS
section each item will state if it requires an authkey.

=head2 NOTE

This is a beta version of the module with very few of the API functions
implimented. Please make note of this for future releases.

=head1 METHODS

=over 4

=item new

This function instantiates a WWW::Bookmarks object. The arguments that can be
passed are limited to server.

=item login

This function initiates a user session by providing an authkey for a username
and password.

=item addbookmark

This function creates a new bookmark on the provided server. An authkey is
required.

  Required Args:
  url
  tags, seperated by comma

  Optional Args:
  description
  private
  spam
  adult

=item deletebookmark

This function deletes a given bookmark from the provided server. An authkey is
required.

  Required Args:
  urlid

=item addtag

This function adds a tag to a bookmark. An authkey is required.

  Required Args:
  urlid
  name

=item deletetag

This function deletes a specific tag from a bookmark. An authkey is required.

  Required Args:
  tagid

=item batchurl

This function allows users to do batch lookups of urls. By passing along an
array of urls it will return a hash of urls, having keys as the place of the
url in the passed array, with information on the url. Currently the returned
value only provides tags, but it could provide entire url xml blocks in the
near future.

  Requires:
  urls, as array. - ['http://www.google.com/', 'http://bookmarks.socklabs.com/tag/favorite', 'svn://bookmarks.socklabs.com/svn/www/trunk/Build.PL']

=cut

sub new {
	my ($self, %args) = @_;
	$args{server} = 'bookmarks.socklabs.com' unless ($args{server} && $args{server} ne '' );
	bless {
		conn => 'http://'.$args{server}.'/xmlrpc',
		server => $args{server},
		call => 'Bookmarks.XMLRPC',
	}, $self;
}

sub login {
	my ($self, $username, $password) = @_;
	$self->{authkey} = XMLRPC::Lite->proxy( $self->{conn} )->call( $self->{call}.'.authuser', login => $username, password => $password )->result;
}

sub addbookmark {
	my ($self, %args) = @_;
	die 'Missing authkey' unless ($self->{authkey});
	die 'Missing Arguments' unless ($args{url} && $args{tags});
	my $result = XMLRPC::Lite->proxy( $self->{conn} )->call( $self->{call}.'.addbookmark', authkey => $self->{authkey}, %args )->result;
	return $result;
}

sub deletebookmark {
	my ($self, %args) = @_;
	die 'Missing authkey' unless ($self->{authkey});
	die 'Missing Arguments' unless ( $args{urlid} );
	my $result = XMLRPC::Lite->proxy( $self->{conn} )->call( $self->{call}.'.deletebookmark', authkey => $self->{authkey}, %args )->result;
	return $result;
}

sub batchurl {
	my ($self, @urls) = @_;
	my $result = XMLRPC::Lite->proxy( $self->{conn} )->call( $self->{call}.'.batchurl', @urls )->result;
	return $result;
}

sub addtag {
	my ($self, %args) = @_;
	my $result = XMLRPC::Lite->proxy( $self->{conn} )->call( $self->{call}.'.addtag', authkey => $self->{authkey}, %args )->result;
	return $result;
}

# TODO: This is broken, needs fixing.
sub deletetag {
	my ($self, %args) = @_;
	my $result = XMLRPC::Lite->proxy( $self->{conn} )->call( $self->{call}.'.deletetag', authkey => $self->{authkey}, %args )->result;
	return $result;
}

1;

=head1 AUTHOR

Nick Gerakines E<lt>F<nick@socklabs.com>E<gt>

=head1 COPYRIGHT

Copyright (C) 2005, Nick Gerakines

This module is free software; you can redistribute it or modify it
under the same terms as Perl itself.

=cut
