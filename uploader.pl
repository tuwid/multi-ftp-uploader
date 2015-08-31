use Socket 'inet_aton';
use Net::FTP;
# cpan install Net::FTP
my $debug = 1;

my $ftp_user = 'anonymous';
my $ftp_pass = 'lajeogzim';

my $local_file = 'test.txt';
my $remote_path = '/upload';

my $start_ip = '192.168.1.10';
my $end_ip = '192.168.1.100';


sub ftp_upload {
	my $ip = @_[0];
	if($debug) {
		print "Uploading $local_file to IP: $ip \n";
	}

	$ftp = Net::FTP->new($ip, Timeout=>1800, Passive=>1, Debug=>$debug ) or die "Cannot connect to $ip: $@";
	$ftp->login("$ftp_user",'$ftp_pass') or die "Cannot login ", $ftp->message;
	# ktu mund te behet me NEXT,
	$ftp->cwd("$remote_path") or die "Cannot change working directory ", $ftp->message;
	$ftp->put($local_file) or die "Upload failed ", $ftp->message;
	#$ftp->ls;
	$ftp->quit;
}


my @ips = map { sprintf "%vi", pack "N", $_ } unpack("N",inet_aton($start_ip)) .. unpack("N",inet_aton($end_ip));
foreach(@ips){
	#print $_."\n";
	ftp_upload("$_");
}

# public free testing ftp server
#ftp_upload("speedtest.tele2.net");
