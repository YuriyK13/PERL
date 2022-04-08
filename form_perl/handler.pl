#!/usr/bin/perl
#use strict;
use warnings;
use utf8;

print "Content-Type: text/html\n\n";

# 2. Read and parse input from the web form

my $buffer;
my $time = localtime();

if ($ENV{'REQUEST_METHOD'} eq 'POST') {
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
} else {
$buffer = $ENV{'QUERY_STRING'};
}

my @pairs = split(/&/, $buffer);
my $input;

foreach my $pair (@pairs) {
  (my $name, my $value) = split(/=/, $pair);
  $value =~ tr/+/ /;
  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
  $value =~ s/<!--(.|\n)*-->//g;
  $input{$name} = $value;
}

# 3. Save the user input in a file

my $file_path = "/var/www/work/form_perl/log.txt";

open (my $data, '>>', $file_path)  || print $!."\n";
print $data "Name: " . $input{'user_name'}. " Date: ". $time . "\n";
close $data;

print "\n" . $input{'user_name'} . ", thank you for registration!\n";

# Send a message back to the user
#print "<h3>Спасибо, что заполнили форму</h3>\n";



