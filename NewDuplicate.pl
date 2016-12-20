#!/usr/bin/perl
##################################################################
#  Arthur Mulkandov 
#  Looking for duplicate files in directory given as parameter
##################################################################
my %SIZE;
my %SHA1;
my $dir = shift;

die "ERROR: The folder does not exist...\n\n" unless -e "$dir";
die "\nSyntax: $0 <path>\n\n" if $dir =~ /^\s*$/; 

$psize = '';
$pname = '';

#Looking for duplicated files with the same size
foreach (split("\n",`find $dir -type f -printf '%s %p\n' \| sort -nr`)){
    ($csize, $cname) = split;		
		if ($csize == $psize){
		  if ($SIZE{$csize} =~ /^\s*$/ ){
		    $SIZE{$csize} .= "$cname $pname ";
		  }else{
		    $SIZE{$csize} .= "$cname ";
			}
		}
		$psize = $csize;
		$pname = $cname;
}

#Looking for duplicated files with the same checksum (from already found files with the same size)
foreach $s (keys %SIZE){
  foreach (split(" ",$SIZE{$s})) {
    my $sha1 = `sha1sum $_ \| cut -d\' \' -f1`; chomp $sha1;
    $SHA1{$sha1} .= "$_,";
  }
}

foreach (keys %SHA1){
  chop $SHA1{$_};
  if (scalar (split(",",$SHA1{$_})) > 1 ){ print "Files $SHA1{$_} are equal\n";} 
}
