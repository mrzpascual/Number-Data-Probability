#!/usr/bin/perl

# This script is for number research only.
# Probability study.

use strict;
use warnings;
use LWP 5.64;

# Record/ log files.
my $NUMBER_FILE_LOG = "/machine_head/usr/x30232/number_file.log";
my $REPORT_FILE_LOG = "./report_email.tmp.fr"; my @numbers;

sub recordNumbers {
	my @groupOfNumbers = @_;
	open(OUT, ">>$NUMBER_FILE_LOG") || die "Can not open $NUMBER_FILE_LOG";
		foreach my $in_ (@groupOfNumbers ){
			$in_ =~s/&#48;|&#x30;/0/mg;
			$in_ =~s/&#49;|&#x31;/1/mg;
			$in_ =~s/&#50;|&#x32;/2/mg;
			$in_ =~s/&#51;|&#x33;/3/mg;
			$in_ =~s/&#52;|&#x34;/4/mg;
			$in_ =~s/&#53;|&#x35;/5/mg;
			$in_ =~s/&#54;|&#x36;/6/mg;
			$in_ =~s/&#x37;|&#55;/7/mg;
			$in_ =~s/&#56;|&#x38;/8/mg;
			$in_ =~s/&#57;|&#x39;/9/mg;
			$in_ =~s/&#45;|&#x2d;/-/mg;
			if( $in_ =~ /Philippine Lotto Winning Number:.+?(\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2})/ ) {
				print OUT $1."\n";
			}
		}
	close(OUT);
}

sub webLWP {
my $url = 'http://philippine-lotto-results.com/645-mega-lotto';
my $browser = LWP::UserAgent->new;
my $response = $browser->get($url,
 'User-Agent' => 'Mozilla/4.76 [en] (Win98; U)',  'Accept' => 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, image/png, */*',  'Accept-Charset' => 'iso-8859-1,*,utf-8',  'Accept-Language' => 'en-US',);
 
recordNumbers( $response->content );
	
}

sub processLog{
    my @outfile = @_;
        open(OUT,">>$REPORT_FILE_LOG") || die "Cannot open file $REPORT_FILE_LOG";
          foreach my $out_ (@outfile){
            print OUT $out_."\n";
          }
        close(OUT);
}

sub readFile{
  my $infile=shift;
  my $lines;
    local($/, *FILE);
    $/=undef;
      open(FILE, $infile) || die "Cannot open file $infile";
        $lines=<FILE>;
      close(FILE);
    return $lines;
}

sub sendReport{
    my $sendmail = '/usr/lib/sendmail';
    open(MAIL, "|$sendmail -oi -t");
      print MAIL "To: mrzpascual\@gmail.com\n";
      print MAIL "Subject: Number Probability Report";
      print MAIL "\n";
      foreach my $report (readFile($REPORT_FILE_LOG)){
        print MAIL "$report\n";
      }
      print MAIL "";
    close(MAIL);
}

&webLWP;
my @report_mail;
my %lottoNumbers;
push(@report_mail, "NUMBER COMBINATION HISTORY ##############"); open (IN, "<$NUMBER_FILE_LOG") || die "Can't open file"; while(<IN>){
  push(@report_mail, $_);
  push(@numbers, split("-", $_));
}
close(IN);

foreach my $num (1..45) {
my $num_count = 0;
  foreach my $i (@numbers) {
    $i=~s/\n//gm;
    if ($i == $num){
      $num_count++;
    }
  }
  $lottoNumbers{$num} = $num_count;
}

sub hashValueDescendingNum {
   $lottoNumbers{$b} <=> $lottoNumbers{$a}; }

my @descendingResults;
my $countSet=0;
push(@descendingResults, sort hashValueDescendingNum(keys %lottoNumbers)); push(@report_mail, "NUMBERS STATS SUMMARY ##############"); foreach my $ky (@descendingResults){
  my $pipe;
  push(@report_mail, "_______________________");
  push(@report_mail, "Number: $ky");
  foreach my $it (1..$lottoNumbers{$ky}){
    $pipe = $pipe."|";
  }
  push(@report_mail, "Count: $lottoNumbers{$ky}");
  if(defined $pipe){
    push(@report_mail, "Progress: $pipe");
  } else {
    push(@report_mail, "Progress: <void>");
  }
  $countSet++;
}

push(@report_mail, "_______________________"); push(@report_mail, "Draw count: $countSet"); push(@report_mail, "_______________________"); my (@setNums1, @setNums2); my @top12 = ($descendingResults[0], $descendingResults[1], $descendingResults[2], $descendingResults[3], $descendingResults[4], $descendingResults[5], $descendingResults[6], $descendingResults[7], $descendingResults[8], $descendingResults[9], $descendingResults[10], $descendingResults[11]);

push(@report_mail, "--------------------------------------------------- test numbers ---"); push(@report_mail, "NUMBER PROBABILITY TEST ##############"); push(@report_mail, '(2 sets of random numbers based from the top 12 results)'); while(@top12){
  my $dresults = @top12;
  my $random = int rand($dresults);
  my $set1_len=@setNums1;
  my $set2_len=@setNums2;

    if ($set1_len <= 5) {
      push(@setNums1, splice(@top12, $random, 1));
    } else {
      push(@setNums2, splice(@top12, $random, 1));
    }
}

my $line1="";
foreach my $set1 (@setNums1){
  $line1=$line1." ".$set1;
}
push(@report_mail, $line1);

my $line2="";
foreach my $set2 (@setNums2){
  $line2=$line2." ".$set2;
}
push(@report_mail, $line2);

sleep(2);
processLog(@report_mail);
&sendReport;

sleep(2);
`rm $REPORT_FILE_LOG`;

