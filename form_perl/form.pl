#!/usr/bin/perl
use strict;
use warnings;
use utf8;

print "Content-type: text/html\n\n";
print "<html lang='en'><head><title>FORM..</title></head>";
print "<body>";
print "<h1 align='center'>Hello!</h1><hr>";
print "<form action = 'handler.pl' method ='post' align='center'>";
print "<b>Your name: </b>";
print "<input name='user_name' value='' size=20>";
print "<p><input type='submit' value='Registration '></p>";
print "</form>";
print "</body></html>";
#print $!;