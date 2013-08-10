#!/usr/bin/perl

use AI::NeuralNet::BackProp;

my $file = 'coins.csv';
my @data;

my ($a, $b) = @ARGV or die "$0 <rows> <args split by space>";

$a=$a-1;

my $net = AI::NeuralNet::BackProp->new(2,$a,1);

if(!$net->load('crand.csv')) {

open(my $fh, '<', $file) or die "Can't read file '$file' [$!]\n";

while (my $line = <$fh>) {
    chomp $line;
    
    my @fields = split(/,/, $line);
    my $size = scalar @fields;
    
    my @input, @output;
    my $count;
    
    for ($count = 0; $i < $size; $i++)
    {
        push @input, @field[$i];
    }
    
    push @output, @field[$i+1];
    
    push @data, [\@input, \@output];
}

$net->learn_set(\@data, random=>0, inc		=>	0.2, max		=>	200, error	=>	-1);

$net->save('coins.dat');

my $fb=$net->run(\@data[scalar @data])->[0];

print "$fb\n";
exit;
}

my $fb=$net->run(split(/ /, $b))->[0];

print $fb . "\n";

