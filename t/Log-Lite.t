use Test::More tests => 2;
BEGIN { use_ok('Log::Lite') };

use Log::Lite qw(log);
log('test', '123456789', 'abcdefg');
my @files = glob("log/*");
my $file = shift @files;
open my $fh,"<",$file;
my $content = <$fh>;
close $fh;
unlink $file;

like($content, qr/\d{4}\-\d{2}\-\d{2}\s+\d{2}\:\d{2}\:\d{2}\s+123456789\s+abcdefg/, 'content');
