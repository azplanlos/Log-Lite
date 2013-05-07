package Log::Lite;
use strict;
use warnings;
use POSIX qw(strftime);
use Fcntl qw(:flock);

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(logpath log);
our $VERSION   = '0.05';
our $LOGPATH;

sub logpath {
    my $path = shift;
    if ( substr( $path, 0, 1 ) ne '/' ) {
        $path = $ENV{'PWD'} . "/" . $path;
    }

    $LOGPATH = $path;
    return 1;
}

sub log {
    return 0 unless $_[0];
    my $logtype  = shift;
    my $date_str = strftime "%Y%m%d", localtime;
    my $log      = strftime "%Y-%m-%d %H:%M:%S", localtime;
    foreach (@_) {
        my $str = $_;
        $str =~ s/[\t\r\n]//g if defined $str;
        $log .= "\t" . $str if defined $str;
    }
    $log .= "\n";

    my $logpath = $LOGPATH ? $LOGPATH : 'log';
    my $logfile = $logpath . "/" . $logtype . "_" . $date_str . ".log";
    if ( -d $logpath or mkdir $logpath, 0755 ) {
        open my $fh, ">>", $logfile;
        flock $fh, LOCK_EX;
        print $fh $log;
        flock $fh, LOCK_UN;
        close $fh;
        return 1;
    }
    else {
        print STDERR "error mkdir $logpath";
        return 0;
    }
}

1;
__END__

=head1 NAME

Log::Lite - Log info in local file


=head1 SYNOPSIS

  use Log::Lite qw(logpath log);

  logpath("/tmp/mylogpath"); #defined where log files stored (Optional)
  logpath("mylogpath"); #can use relative path (Optional)

  log("access", "user1", "ip1", "script"); #log in ./log/access_20110206.log
  log("access", "user2", "ip2", "script");  #log in the same file as above 
  log("debug", "some", "debug", "info", "in", "code"); #log in ./log/debug_20110206.log
  log("error", "error information"); # could accept any number of arguments


=head1 DESCRIPTION

Module Feature:

1. auto create file named by the first argument.

2. auto cut log file everyday.

3. thread safety (open-lock-write-unlock-close everytime).


=head1 METHODS

=head2 logpath($path)

Optional. Defined logpath. "./log" by default.

=head2 log($type, $content1, $content2, $content3, ...)

Write information to file.


=head1 AUTHOR

Written by ChenGang, yikuyiku.com@gmail.com

L<http://blog.yikuyiku.com/>


=head1 COPYRIGHT

Copyright (c) 2011 ChenGang.
This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.


=head1 SEE ALSO

L<Log::Log4perl>, L<Log::Minimal>

=cut

