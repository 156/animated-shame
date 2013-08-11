#!/usr/bin/perl
#
# usage: cat input.txt | perl le-en.pl > output.txt
#

use Lingua::EN::Tagger;

my $VV = 1;
my %weight;

my $tag_f_prefix = "words_";
my $tag_f_ext = ".txt";

my $p = new Lingua::EN::Tagger;

while (<STDIN>)
{
	chomp;

	push @tagged_text, $p->add_tags($_);
}

foreach(@tagged_text)
{
	my @tags=split(/ /);

	dump_tags(@tags);
}

sub dump_tags
{
	my @tags=shift;

	dump_tag($_) foreach(@tags);
}

sub dump_tag
{
	my $tag=shift;

	print $tag . "\n" if ($VV);

	if ($tag =~ /\<(\S+)\>(\S+)\<\/(\S+)\>/) {
		return if ($1 ne $3); #valid tag/endtag only

		$weight{$2}++;

		write_tag($1, $2);
	}
	
}

sub write_tag
{
	my ($tag_f, $tag) = @_;

	open FD, (">" . $tag_f_prefix . $tag_f . $tag_f_ext); print FD "$tag\n"; close FD;
}
