package Log::Lite;
use strict;
use warnings;
use POSIX qw(strftime);
use Fcntl qw(:flock);
use vars qw(@ISA @EXPORT_OK $VERSION);

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(log);

our $VERSION = '0.01';

sub log
{
    return 0 unless $_[0];
    my $logtype = shift;
    my $date_str = strftime "%Y%m%d", localtime;
    my $log = strftime "%Y-%m-%d %H:%M:%S", localtime;
    foreach (@_) 
    {
        my $str = $_;
        $str =~ s/[\t\r\n]//g;
        $log .= "\t".$str;
    }
    $log .= "\n";

    mkdir "log",0755 unless -d "log";
    my $logfile = "log/".$logtype."_".$date_str.".log";

    open my $fh,">>",$logfile;
    flock $fh,LOCK_EX;
    print $fh $log;
    flock $fh,LOCK_UN;
    close $fh;
}

1;
__END__

=head1 NAME

Log::Lite - log info in local file


=head1 SYNOPSIS

  use Log::Lite qw(log);
  log("access", "user1", "ip1", "script"); #log in ./log/access_20110206.log
  log("access", "user2", "ip2", "script");  #log in the same file as above 
  log("debug", "some", "debug", "info", "in", "code"); #log in ./log/debug_20110206.log
  log("error", "error information"); # could accept any number of arguments


=head1 DESCRIPTION

This module helps log information on disk.

1. auto create a file named by the first argument when call the sub fisrt time.

2. auto cut log file everyday.

3. thread safety.


=head1 AUTHOR

Written by ChenGang, yikuyiku.com@gmail.com

L<http://blog.yikuyiku.com/>


=head1 COPYRIGHT

Copyright (c) 2011 ChenGang.
This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.


=head1 SEE ALSO

L<Log::Log4perl>, L<Log::Minimal>

=cut

