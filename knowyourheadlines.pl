#!/usr/bin/perl
#
# absolutely no warranty do not use.
#

use Mojo::UserAgent;
use Mojo::Util 'encode';

use Lingua::EN::Tagger;

my %ignore = ();

my $ua = Mojo::UserAgent->new;

my ($pnum) = @ARGV or die "$0 <pages>";

my $titles = '';


$pnum++;

for (my $i=1;$i<$pnum;$i++)
{
	my $search = "http://knowyourmeme.com/page/$i/";

	my $tx = $ua->get($search);

	for my $e ($tx->res->dom('*')->each)
	{
		if ($e->type eq 'a')
		{
			if ($e->{class} eq 'newsfeed-title')
			{
				print $e->{title} . "\n";
			}
		}
	}
}
