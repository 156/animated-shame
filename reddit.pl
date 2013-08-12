use XML::RSS::Parser::Lite;
use LWP::Simple;

($url) = @ARGV or die "$0 <url of reddit rss>";

my $xml = get($url);
my $rp = new XML::RSS::Parser::Lite;

$rp->parse($xml);
        
print "Got RSS Index [" . $rp->count() . "]\n";
print "Getting Titles and Descriptions [";
my @titles, @descriptions, @urls, @comments;

for (my $i = 0; $i < $rp->count(); $i++) {
    my $it = $rp->get($i);
    push @titles, $it->get('title');
    push @descriptions, $it->get('description');
    push @urls, $it->get('url');
    print ".";
}

print "]\n";

open TITLES, ">titles.txt";
open DESC, ">desc.txt";
open URLS, ">urls.txt";


foreach (@titles) { print TITLES $_ . "\n"; }
foreach (@descriptions) { print DESC $_ . "\n"; }

foreach (@urls) {
print URLS $_ . "\n";
my $xmla = get($_.".rss");
my $rpa = new XML::RSS::Parser::Lite;

$rpa->parse($xmla);

for (my $i = 0; $i < $rpa->count(); $i++) {
my $ita = $rpa->get($i);
push @comments, $ita->get('description');
}

}

close TITLES;
close DESC;
close URLS;

open COMMENTS, ">comments.txt";

foreach (@comments) { print COMMENTS $_ . "\n"; }

close COMMENTS;
