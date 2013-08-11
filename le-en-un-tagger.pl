#!/usr/bin/perl
#
# usage: cat input.txt | perl untag.pl > output.txt
#
while (<STDIN>)
{
	my @tags=split(/ /);
	foreach $tag (@tags)
	{
		if ($tag =~ /\<(\S+)\>(\S+)\<\/(\S+)\>/) {
			next if ($1 ne $3);
			print "$2 ";
		}
	}
	print "\n";
}
