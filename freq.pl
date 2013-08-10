# some ripped from perlmonks / unknown
# input should be tolower

my %count = ();
my %stopwords;

open FD, "stopwords.txt";

while (<FD>)
{
	chomp;
	$stopwords{$_}=1;
}

close FD;

while (<STDIN>)
{
	foreach (split(' ', $_))
	{
		next() if(stopword($_));
		++$count{$_};
	}
}

my @lines = ();
my ($w, $c);

push(@lines, sprintf("%7d %s\n", $c, $w)) while (($w, $c) = each(%count));

print sort { $b cmp $a } @lines;

sub stopword
{
	my ($word) = @_;
	return -1 if(exists($stopwords{$_}));
	return 0;
}
