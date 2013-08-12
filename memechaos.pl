#!/usr/bin/perl
#
# usage: cat input-tagged.txt | perl memechaos.pl > output.txt
#
use Lingua::EN::Tagger;
use List::MoreUtils qw(uniq);
use Getopt::Long;

my $p = new Lingua::EN::Tagger;
my $verbose = 0;
my $tagged_threshold = 0.99;
my $tagged_minimum = 3;
my $candidate_threshold = 0.999;
my $candidate_minimum = 5;

my %opts = ( 
	verbose => \$verbose,
	tagged_threshold => \$tagged_threshold,
	tagged_minimum => \$tagged_minimum,
	candidate_threshold => \$candidate_threshold,
	candidate_minimum => \$candidate_minimum
);
GetOptions(\%opts, 'verbose!', 'tagged_threshold=i', 'tagged_minimum=i', 'candidate_threshold=i', 'candidate_minimum=i');

while (<STDIN>)
{
	chomp;

	my $tag_text = $p->add_tags($_);

	push @tagged_text, $tag_text;
}

@tagged_text = uniq(@tagged_text);

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

my @meme_candidates = ();
while (scalar @meme_candidates < $tagged_minimum) {
	foreach(@tagged_text)
	{
		next if (rand() < $tagged_threshold);
		print STDERR "Entering...\n" if ($verbose);
		my @tags=split(/ /);
		my $tagged_text = $_;
	
		foreach $tag (@tags)
		{
			if ($tag =~ /\<(\S+)\>(\S+)\<\/(\S+)\>/) {
				next if ($1 ne $3);
	
				my $tag = $3;
				my $untag = $2;
				foreach my $word (@$1)
				{
					print STDERR "--\n" if ($verbose);
					my $tagged_text_n = $tagged_text;
					print STDERR $tagged_text_n . "\n" if ($verbose);
					$tagged_text_n =~ s/\<(\S+)\>$untag\<\/(\S+)\>/\<$tag\>$word\<\/$tag\>/g;
					push @meme_candidates, $tagged_text_n;
					#print $tagged_text_n . "\n";
					if ($verbose) {
						print STDERR "$untag, $word\n";
						print STDERR "--\n";
					}
				}
	
			}
		}
	}
}

@meme_candidates = uniq(@meme_candidates);
my $added = 0;
while ($added <= $candidate_minimum) {
	foreach $candidate (@meme_candidates) {
		my $chance = rand; # between 1 and 10
		if ($chance > $candidate_threshold) {
			print STDERR "$added: $chance > $threshold: $candidate\n" if ($verbose);
			print "$candidate\n";
			$added++;
		}
	}
}
