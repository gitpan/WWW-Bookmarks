use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME	 => "WWW::Bookmarks",
	VERSION_FROM => 'lib/WWW/Bookmarks.pm',
	PREREQ_PM    =>  {
		'XMLRPC::Lite' => "0.60",
		'XML::Simple' => "2.14",
		'Test::More' => "0.01",
	},
	AUTHOR       => 'Nick Gerakines <nick@socklabs.com>',
	ABSTRACT     => 'WWW::Bookmarks is an xmlrpc interface to bookmarks servers'
);

sub MY::libscan {
  my $path = $_[1];
  return '' if $path =~ /\B\.svn\b/;
  return $path;
}
