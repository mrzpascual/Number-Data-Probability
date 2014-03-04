#!/usr/bin/perl
# Traffic priority road detection
# Traffic simulation study (demo)

# Decalare the intersection lanes as A, B, C, and D
my (@roadA, @roadB, @roadC, @roadD);

sub interSection{
  # Traffic / fill the roads with vehicles!
  push(@roadA, vehicleGenerator());
  push(@roadB, vehicleGenerator());
  push(@roadC, vehicleGenerator());
  push(@roadD, vehicleGenerator());
  # Detect the length of the traffic
  my $rdA=@roadA;
  my $rdB=@roadB;
  my $rdC=@roadC;
  my $rdD=@roadD;
  # Print each volume and the name of the lanes
  print "\nTraffic count on North road :".$rdA;
  print "\nTraffic count on East road  :".$rdB;
  print "\nTraffic count on South road :".$rdC;
  print "\nTraffic count on West road  :".$rdD;
  print "\nlist priorities\n";

  # Simulate traffic
  # Flag equal volume
  my $flag=0;
  # Activate top value
  my $top=0;
  foreach my $volume (my @priority=setPriority($rdA, $rdB, $rdC, $rdD)){
    my $go=int($volume/2);
	if ($rdA==$volume && $flag!=1) {
	  if($priority[0]==$volume && $top!=1){	  
	  logReport("North");
	  $top=1;
	  }
	  print "\n Go signal on North bound\n";
	  sleep($go);
	  while($volume > $go){
		splice(@roadA,$volume);
		$volume=$volume-1;
		print $volume."  ";
	  }
      
	  $flag=1;
	} elsif ($rdB==$volume && $flag!=2) {
	  if($priority[0]==$volume && $top!=1){
	  logReport("East");
	  $top=1;
	  }
	  print "\n Go signal on East bound\n";
	  sleep($go);
	  while($volume > $go){
	    splice(@roadB,$volume);
	    $volume=$volume-1;
		print $volume."  ";
	  }
	  
	  $flag=2;
	} elsif ($rdC==$volume && $flag!=3) {
	  if($priority[0]==$volume && $top!=1){
	  logReport("South");
	  $top=1;
	  }
	  print "\n Go signal on South bound\n";
	  sleep($go);
	  while($volume > $go){
	    splice(@roadC,$volume);
	    $volume=$volume-1;
		print $volume."  ";
	  }
	  
	  $flag=3;
	} elsif ($rdD==$volume && $flag!=4) {
	  if($priority[0]==$volume && $top!=1){
	  logReport("West");
	  $top=1;
	  }
	  print "\n Go signal on West bound\n";
	  sleep($go);
	  while($volume > $go){
	    splice(@roadD,$volume);
	    $volume=$volume-1;
		print $volume."  ";
	  }
	  
	  $flag=4;
	} else {
	  print "This road is empty?!";
	  $flag=0;
	}
	sleep(2);
	print "\n";
  }
  sleep(2);
  $flag=0;
  print "\n\n Graphical report of heavy traffic\n";
  graphChart();
  # Loop
  print "\n\nAnother set of vehicles are added on the traffic cycle...\n";
  print "Traffic build up...\n\n";
  interSection();
}

sub vehicleGenerator{ 
  my $vehicleCount=int rand(20);
  my @vehicle=(1..$vehicleCount);  
  return @vehicle;
}

sub setPriority{
  my @sort=@_;
  my @priority= sort { $b <=> $a } @sort;
  return @priority;
}

sub logReport{
  our $report="trafreport.txt";
  my ($bound)=shift;
  my ($lines, $num);
  local($/, *FILE);
  $/=undef;
  open(FILE, $report) || die "Cannot open file $report";
  $lines=<FILE>;
  $lines=~m/$bound:([0-9]+)/;
  $num=$1+1;
  $lines=~s/$bound:([0-9]+)/$bound:$num/gm;
	  open(OUT, ">$report") || die "Cannot open file $report";
	    print OUT $lines;
      close(OUT);
  close(FILE);
  
}

sub graphChart{
  our $report="trafreport.txt";
  local($/, *FILE);
  $/=undef;
  my $display;
  open(FILE, $report) || die "Cannot open file $report";
  $display=<FILE>;
  $display=~m/North:([0-9]+)/;
  my $north=$1;
  print "North     ";
  foreach my $line (1..$north){
     print "|";
  }
  print "\n";
  $display=~m/East:([0-9]+)/;
  my $east=$1;
  print "East      ";
  foreach my $line (1..$east){
     print "|";
  }
  print "\n";
  $display=~m/South:([0-9]+)/;
  my $south=$1;
  print "South     ";
  foreach my $line (1..$south){
     print "|";
  }
  print "\n";
  $display=~m/West:([0-9]+)/;
  my $west=$1;
  print "West      ";
  foreach my $line (1..$west){
     print "|";
  }
  print "\n";
  close(FILE);
}

interSection();