#!/usr/bin/perl
##################################################################
#  Arthur Mulkandov 
#  Looking for duplicate files in directory given as parameter
##################################################################
my %SHA1;
my $dir = shift;

die "ERROR: The folder does not exist...\n\n" unless -e "$dir";
die "\nSyntax: $0 <path>\n\n" if $dir =~ /^\s*$/; 

foreach (split("\n",`find $dir -type f`)){
   my $sha1 = `sha1sum $_ \| cut -d\' \' -f1`; chomp $sha1;
   $SHA1{$sha1} .= "$_,";
}

foreach (keys %SHA1){
  chop $SHA1{$_};
  if (scalar (split(",",$SHA1{$_})) > 1 ){ print "Files $SHA1{$_} are equal\n";} 
}
