use Animated::Shame;

use Getopt::Std;

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

my $opts = {
	'h' => 'http://www.reddit.com/.rss'
};

my $shame = Animated::Shame->new();

getopt('h', $opts);

my $output = $shame->input({
	urls => [$opts->{h}],
	verbose => 1,
	transform => $transform_to_subreddit,
	get => [qw/title description url/]
});

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
