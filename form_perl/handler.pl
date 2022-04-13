#!/usr/bin/perl
#use strict;
use warnings;
#use utf8;
use DBI;
#require "./bootstrap.min.css";
#require "./function.pl";

print "Content-Type: text/html; charset = utf-8\n\n";

# 2. Read and parse input from the web form
receive_form_data();

# 3. Save the user input data in a file
write_to_log ();

print "<h3>\n ". $input{'user_name'} . " (" . $input{'user_address'} . ") , thank you for registration!</h3>\n";

## 4. DATABASE ##
database ();


### EXECUTABLE FUNCTIONS ###

sub receive_form_data {

    my ($buffer, $input);
    my $time = localtime();

    if ($ENV{'REQUEST_METHOD'} eq 'POST') {
      read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
    }
    else {
      $buffer = $ENV{'QUERY_STRING'};
    }

    my @pairs = split(/&/, $buffer);

    foreach my $pair (@pairs) {
      my ($name, $value) = split(/=/, $pair);
      $value =~ tr/+/ /;
      $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
      $value =~ s/<!--(.|\n)*-->//g;
      $input{$name} = $value;
    }

}

sub write_to_log {
    my $file_path = "/var/www/work/form_perl/log.txt";
    open (my $data, '>>', $file_path)  || print $!."\n";
    print $data "Name: " . $input{'user_name'}." Address: ".$input{'user_address'}. " Date: ". $time . "\n";
    close $data;
}

sub database {

        # Credentials of DATABASE
    my $host = "localhost"; # MySQL-сервер
    #my $port = "80"; # порт, на который открываем соединение
    my $user = "root"; # имя пользователя
    my $pass = "Warner/12345"; # пароль
    my $db = "testDB"; # имя базы данных -

    my ($dbh,$stn,$rc,$ref);
    my $user_name = $input{'user_name'};
    my $user_address = $input{'user_address'};

    # соединение
    $dbh = DBI->connect("DBI:mysql:$db:$host", $user,$pass);

        # Save data to DATABASE

    # готовим запрос
    $sth = $dbh->prepare("INSERT INTO customers (name, address) VALUES ('$user_name', '$user_address')");
    # исполняем запрос
    $sth->execute;
    $rc = $sth->finish;  # закрываем

    # готовим запрос
    $sth = $dbh->prepare("SELECT * FROM customers");
    # исполняем запрос
    $sth->execute;

    print "<br>";

        # Show data from DATABASE

    print "<!doctype html>";
    print "<html lang=\"en\">";
        print "<head>";
    #        print "<meta http-equive=\"Content-type\" content = \"text/html; charset=utf-8\">";
            print "<meta charset=\"utf-8\">";
            print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">";
    #        print "<link href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css\" rel=\"stylesheet\" integrity=\"sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3\" crossorigin=\"anonymous\">";
            print "<link href=\"bootstrap.min.css\" rel=\"stylesheet\">";
            print "<title>List of customers</title>";
        print "</head>";

        print "<body>";
            print "<h2 class = \"text-center text-success text-wrap\"> Список користувачів </h2>";

                while ($ref = $sth->fetchrow_arrayref) {
                #print "<br> $$ref[1], $$ref[2];\n"; # печатаем результат
                        print "<div class=\"container\">";
                            print "<div class=\"row\">";

                                print "<div class=\"card col-md-3\">";
                                print "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"60\" height=\"60\" fill=\"currentColor\" class=\"bi bi-person-square\" viewBox=\"0 0 16 16\">";
                                    print "<path d=\"M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z\"/>";
                                    print "<path d=\"M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm12 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1v-1c0-1-1-4-6-4s-6 3-6 4v1a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12z\"/>";
                                print "</svg>";

                                print "<h5 class=\"fs-6 lh-1\"><a href=\"http://www.google.com\">$$ref[1]</a></h5>";
                                    print "<button type=\"button\" class=\"btn btn-light p-0 text-wrap\">Кабінет</button>";
                                    print "<p class=\"fs-6 lh-1\">$$ref[2]</p>";
                            print "</div>";
                        print "</div>";
                }
    #        print "<script src=\"https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js\" integrity=\"sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p\" crossorigin=\"anonymous\"></script>";
            print "<script src=\"bootstrap-5.1.3/js/bootstrap.bundle.min.js\" integrity=\"sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p\" crossorigin=\"anonymous\"></script>";

       print "</body>";
    print "</html>";

    $rc = $sth->finish;  # закрываем
    $rc = $dbh->disconnect; # соединение

}