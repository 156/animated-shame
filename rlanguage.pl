use Animated::Shame;

use Getopt::Long;
use MongoDB;
use POSIX;

use strict;
use warnings;

sub get_subreddit {
	my $output = shift;

	my @top_urls = keys %{$output->{url}};
	my $shame = Animated::Shame->new();
	for my $top_url (@top_urls) {
		my $clean_url = $top_url;
		$clean_url =~ tr/./;/;
		warn $clean_url;
		$output->{url}->{$clean_url} = delete $output->{url}->{$top_url};
		$output->{url}->{$clean_url}->{url_comments} = map {
			my $orig = $_;
			my $rss = $orig . '.rss';
			my $comments = $shame->input({
				urls => [$rss],
				get => ['description'],
				verbose => 1,
				transform => sub {
					my $output = shift;	
					for my $top_url (@top_urls) {
						my $clean_url = $top_url;
						$clean_url =~ tr/./;/;
						$output->{url}->{$clean_url} = delete $output->{url}->{$top_url};
					}
					return $output;
				}
			});			
		 	{$orig => $comments};
		} @{$output->{url}->{$clean_url}->{url}};
	}

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

sub write_to_mongodb {
	my $output = shift;
    my $connection = MongoDB::Connection->new(host => 'localhost', port => 27017);
    my $database   = $connection->get_database( 'reddit_data' );
	my $now 	   = strftime "%FT%T", localtime $^T;
    my $collection = $database->get_collection( "$now" );
    my $id         = $collection->insert($output);
}

my $shame = Animated::Shame->new();
my $output = $shame->input(prepare_options());
$output = get_subreddit($output);
write_to_mongodb($output);
