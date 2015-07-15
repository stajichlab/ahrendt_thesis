#!/usr/bin/perl
# Script: dock_summ.pl
# Description: Summarizes all of the *_docking_results files in the current directory
# Author: Steven Ahrendt
# email: sahrendt0@gmail.com
# Date: 11.27.13
###########################################
# Usage: dock_summ.pl
###########################################
use warnings;
use strict;
use Getopt::Long;
use Cwd;

#####-----Global Variables-----#####
my ($help,$verb);
my $dir = ".";
my $num_runs = 50;
my %result;
my $run_number = 1;  # include the run number in the output
my %scores;

GetOptions ('h|help'    => \$help,
            'v|verbose' => \$verb,
            'd|dir=s'   => \$dir,
            'run!'      => \$run_number);

my $usage = "Usage: dock_summ.pl [-d dir] [-v] [--norun]\n  use --norun to suppress the run number in the output\n";
die $usage if ($help);

#####-----Main-----#####
opendir(DIR,".");
my @dir_list = grep {-d && /LIG_\d{3}/} readdir(DIR);
closedir(DIR);

my @file_list;
foreach my $dir (sort @dir_list)
{
  print "Dir: $dir\n" if $verb;
  opendir(LIGDIR,$dir);  
  my @res_list = grep {/\_docking\_results$/} readdir(LIGDIR);
  closedir(LIGDIR);
  my $res = "./$dir/$res_list[0]";
  push @file_list,$res;
}
## Now that we have a file list, run through and sort the energies for each ligand
foreach my $file (@file_list)
{
  open(IN,"<$file") || die "Can't open file $file.\n";
  print $file,"\n" if $verb;
  my $lc = 0;
  my ($rec,$lig1,$lig2,$d,$r) = split(/\_/,(split(/\//,$file))[-1]); # Filename is $dir1/$dir2/$rec_$lig_docking_results
 # my ($rec,$lig1,$lig2,$d,$r) = split(/\_/,$file); # Filename is $rec_$lig1_$lig2_docking_results
  my $lig = join("_",$lig1,$lig2);
  my @sorted_scores;
  while(my $line = <IN>)
  {
    chomp $line;
    next if($line =~ /^#/);
    my($run,$FE) = split(/\t/,$line);
    $scores{$lig}{$run} = $FE;
    if($run_number){$sorted_scores[$lc] = join(",",$FE,$run);}
    else{$sorted_scores[$lc] = $FE;}
    $lc++;
  }
  if($lc> 0){$result{$lig} = \@sorted_scores;}
  close(IN);
}

my @ligands = sort keys %scores;
my $d = cwd();
my $org = (split(/\//,cwd()))[-1];
if($run_number){$org = join("_","runNum",$org)};
my $outstream = ">$org\_docking_summary";
if($verb){ $outstream = ">&STDOUT";}
open(SUM,$outstream);
print SUM "#$org\n";
print SUM join("\t",(sort keys %result)),"\n";

## Output
foreach my $r (0..($num_runs-1))
{
  foreach my $lig (sort keys %result)
  {
    print SUM ${$result{$lig}}[$r],"\t"; 
  }
  print SUM "\n";
}
close(SUM);

warn "Done.\n";
exit(0);

#####-----Subroutines-----#####
__END__
foreach my $new_dir (@dir_list)
{
  opendir(D,"$dir/$new_dir");
  my @res_file = grep {/.+\_docking\_results$/} readdir(D);
  closedir(D);
  if(scalar @res_file == 0)
  {
    ## No results, so run dock_parse
    warn "No results found for $dir/$new_dir\n";
    opendir(D,"$dir/$new_dir");
    my @dlg_file = grep {/dlg/} readdir(D);
    closedir(D);
    if(scalar @dlg_file == 1)
    {
      my ($rec,$lig,$dock) = split(/\_/,$dlg_file[0]);
      my $res = "$dir/$new_dir/$rec\_$lig\_docking_results";
      my $dock_parse = "~/Scripts/docking_scripts/dock_parse.pl -i $dir/$new_dir/$dlg_file[0]";
      system($dock_parse);
      push (@file_list,"$res");
   }
   else
   {
     warn "No log file for $new_dir\n";
   }
  }
  else
  {
    push(@file_list,"$dir/$new_dir/$res_file[0]");
  }
}
