#!/usr/bin/perl
#
# usage: cat input.txt | perl le-en-tagger.pl > output.txt
#

use Lingua::EN::Tagger;

my $p = new Lingua::EN::Tagger;

while (<STDIN>)
{
	print $p->add_tags($_) . "\n";
}
