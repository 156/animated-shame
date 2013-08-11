#!/usr/bin/perl
#
# usage: cat input-tagged.txt | perl memechaos.pl > output.txt
#
use Lingua::EN::Tagger;
use List::MoreUtils qw(uniq);

my $p = new Lingua::EN::Tagger;

while (<STDIN>)
{
	chomp;

	my $tag_text = $p->add_tags($_);

	push @tagged_text, $tag_text;
}

foreach(@tagged_text)
{
	my @tags=split(/ /);
	my $tagged_text = $_;

	foreach $tag (@tags)
	{
		if ($tag =~ /\<(\S+)\>(\S+)\<\/(\S+)\>/) {
			next if ($1 ne $3);
		
			push @$1, $2;
		}
	}

}

foreach(@tagged_text)
{
	my @tags=split(/ /);
	my $tagged_text = $_;

	foreach $tag (@tags)
	{
		if ($tag =~ /\<(\S+)\>(\S+)\<\/(\S+)\>/) {
			next if ($1 ne $3);

			my $untag = $2;

			foreach (@$1)
			{
				my $tagged_text_n = $tagged_text;

				$tagged_text_n =~ s/$untag/$_/g;
				print $tagged_text_n . "\n";
			}

		}
	}
}
