#!/usr/bin/perl
# Script: secretome_workflow.pl
# Description: Runs through a series of programs for secretome prediction in Fungi 
# Author: Steven Ahrendt
# email: sahrendt0@gmail.com
##################################
# Generates a shell script which can be used to run through secretome prediction
###################################
# Program order (doi ref: 10.4172/jpb.1000133)
#  signalp
#  tmhmm (only keep those with no TM prediction
#  WolfPSORT
#  Phobius
#  PS-SCAN
#####################################
use warnings;
use strict;
use Getopt::Long;
use lib '.';

#####-----Global Variables-----#####
my $input;
my $scripts_dir = "../Scripts"; # When the shell script runs, it descends into each org directory. 
                                # So relatively, the scripts dir is in the parent dir
my $prot_dir = "Proteomes"; # location of proteome files
my $prosite_data = "prosite.dat";
my $prot_file;
my ($sigp_res,$tm_res,$wolfp_res,$phobius_res,$pscan_res);
my @chytrids = qw(Amac Bden Cang Gpro Hpol OrpC PirE Psoj Rall Spun);
my $fungi;  # can add more organisms using --fungi argument
my ($help,$verb);

GetOptions ('i|input=s' => \$input,
            'fungi=s'   => \$fungi,
            'h|help'   => \$help,
            'v|verbose' => \$verb);
my $usage = "Usage: secretome_workflow.pl [--fungi a,b,c...]\n";
die $usage if $help;

#####-----Main-----#####
if($fungi)
{
  foreach my $item (split(/,/,$fungi))
  {
    push (@chytrids,$item);
  }
}
foreach my $org (@chytrids)
{
  open(my $sh,">","$org\_secretome.sh");
  print $sh "# Modules\n";
  loadModules($sh);
  $sigp_res = "signalp";
  $tm_res = "noTM";
  $wolfp_res = "wolfPSort";
  $phobius_res = "phobius";
  $pscan_res = "psScan";
  $prot_file = "$org\_proteins.aa.fasta";
  print $sh "mkdir $org\n";
  print $sh "cd $org\n";
  print $sh "ln -s $prot_dir/$prot_file\n";

  # SignalP
  $sigp_res = join(".","$org\_proteins",$sigp_res);
  print $sh "# SignalP\n";
  print $sh "signalp $prot_file > $sigp_res\n";
  print $sh "grep \"#\" -v $sigp_res | grep \"Y\" | cut -f 1 -d\" \" > $sigp_res\.accnos\n";
  print $sh "$scripts_dir/getseqfromfile.pl -d . -f $prot_file -a $sigp_res\.accnos > $sigp_res\.aa.fasta\n";
  
  # TMHMM
  print $sh "# TMHMM\n";
  $tm_res = join(".",$sigp_res,$tm_res);
  print $sh "tmhmm -short $sigp_res.aa.fasta > $sigp_res\.tmhmm\n";
  print $sh "grep \"PredHel=0\" $sigp_res\.tmhmm | cut -f 1 > $tm_res\.accnos\n";
  print $sh "$scripts_dir/getseqfromfile.pl -d . -f $prot_file -a $tm_res\.accnos > $tm_res\.aa.fasta\n";

  # WolfPSORT
  print $sh "# WolfPSORT\n";
  $wolfp_res = join(".",$tm_res,$wolfp_res);
  print $sh "runWolfPsortSummary fungi < $tm_res\.aa.fasta > $wolfp_res\n";
  print $sh "$scripts_dir/parseWolfPSORT.pl -i $wolfp_res | cut -f 1 > $wolfp_res\.accnos\n";
  print $sh "$scripts_dir/getseqfromfile.pl -d . -f $prot_file -a $wolfp_res\.accnos > $wolfp_res\.aa.fasta\n";

  # Phobius
  print $sh "# Phobius\n";
  $phobius_res = join(".",$wolfp_res,$phobius_res);
  print $sh "$scripts_dir/phobius/phobius.pl -short $wolfp_res\.aa.fasta > $phobius_res\n";
  print $sh "grep \"0  Y\" $phobius_res | cut -f 1 -d\" \" > $phobius_res\.accnos\n";
  print $sh "$scripts_dir/getseqfromfile.pl -d . -f $prot_file -a $phobius_res\.accnos > $phobius_res\.aa.fasta\n";

  # PScan
  print $sh "# PScan\n";
  $pscan_res = join(".",$phobius_res,$pscan_res);
  print $sh "$scripts_dir/ps_scan/ps_scan.pl -o pff -s --pfscan $scripts_dir/ps_scan/pfscan --psa2msa $scripts_dir/ps_scan/psa2msa -d $prosite_data $phobius_res\.aa.fasta > $pscan_res\n";
  print $sh "cut -f 1 $pscan_res | sort | uniq > $pscan_res\.accnos\n";
  print $sh "$scripts_dir/getseqfromfile.pl -d . -f $prot_file -a $pscan_res\.accnos > $pscan_res\.aa.fasta\n";
  close($sh);
  print `chmod 744 $org\_secretome.sh`;
}
warn "Done.\n";
exit(0);

#####-----Subroutines-----#####
sub loadModules
{
  my $fh = shift @_;
  print $fh "module load wolfpsort\n";
  print $fh "module load signalp/4.1\n";
  print $fh "module load tmhmm\n";
}
