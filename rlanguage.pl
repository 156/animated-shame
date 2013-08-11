use Animated::Shame;

use Getopt::Long;

use strict;
use warnings;

my $transform_to_subreddit = sub {
	my $output = shift;

	my $urls = [map {$_ . '.rss'} @{$output->{url}}];
	my $shame = Animated::Shame->new();
	my $desc = $shame->input({
		urls => $urls,
		get => ['description'],
		verbose => 1
	});
	$output->{comment} = $desc->{description};

	return $output;
};


sub prepare_options {
	my @host = ();
	my $verbose = '';
	my $subreddit = '';
	
	GetOptions ('verbose+' => \$verbose,
				'host=s{1,}' => \@host,
				'subreddit+' => \$subreddit
				);

	die("Not enough hosts") if (scalar @host == 0);

	my $shame_options = {
		urls => [@host],
		verbose => $verbose,
		get => [qw/title description url/] 
	};
	
	# assume we're downloading the main reddit rss
	if (!$subreddit) {
		$shame_options->{transform} = $transform_to_subreddit;
	}

	return $shame_options;
}

sub write_to_file {
	my $output = shift;

	open TITLES, ">titles.txt";
	open DESC, ">desc.txt";
	open URLS, ">urls.txt";
	open COMMENTS, ">comments.txt";
	
	my @titles = @{$output->{title}};
	my @descriptions = @{$output->{description}};
	my @urls = @{$output->{url}};
	my @comments = @{$output->{comment}};
	
	foreach (@titles) { print TITLES $_ . "\n"; }
	foreach (@descriptions) { print DESC $_ . "\n"; }
	foreach (@urls) { print URLS $_ . "\n"; }
	foreach (@comments) { print COMMENTS $_ . "\n"; }
	
	close TITLES;
	close DESC;
	close URLS;
	close COMMENTS; 
}

my $shame = Animated::Shame->new();
my $output = $shame->input(prepare_options());
write_to_file($output);
