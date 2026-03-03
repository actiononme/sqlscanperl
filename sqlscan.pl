#!/usr/bin/env perl

use LWP::UserAgent;
use URI;
use v5.10;
use feature 'say';
use strict;
use warnings;

die "Usage: perl sqlscan.pl <level number> <method>\n" unless @ARGV == 2;
my $Less = $ARGV[0];
my $method = $ARGV[1];

sub scan{
	my $res;
	my $uri;
	my %post_data;

	open my $fh, "<", "payloads/less$Less.txt" or die $!;
	my @payloads = <$fh>;
	chomp @payloads;
	
	%post_data = (uname => $payloads[0],passwd => "123456");

	$uri = URI->new("http://127.0.0.1/Less-" . $Less . "/");

	my $ua = LWP::UserAgent->new(timeout => 5);

	if (lc($method) eq 'get'){
		$uri->query_form(id => $payloads[0]);
		$res = $ua->get($uri)
	}elsif(lc($method) eq 'post'){
		$res = $ua->post($uri,\%post_data)
	}

	print "stauts: " . $res->status_line;
	print "\n";
	print "length: " . length($res->decoded_content);
	print "\n";
	if ($res->decoded_content =~ /name:\s*(\w+)/i){
		print $&;
	}
	print "\n";
	if ($res->decoded_content =~ /Password:\s*(\w+)/i){
		print $&;
	}
}

scan()
