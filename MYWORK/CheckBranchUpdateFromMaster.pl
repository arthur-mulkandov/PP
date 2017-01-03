#!/usr/bin/perl
###########################
#
###########################
$|=1;

my ${branch} = shift;
die "ERROR: branch name is empty.\n\n" if ${branch} =~ /^\s*$/;
#${branch} = quotemeta(${branch});
${branch} =~ s/^\W+//;
print "BRANCH- ${branch}\n";

my ${cmd} = "git fetch";
system($cmd);
print ${cmd} . "\n";

my ${cmd} = "git rev-parse remotes\/origin\/master";
my ${CM} = `$cmd`; chomp $CM;
print ${cmd} . "\n" . "Result: ${CM} \n";



${cmd} = "git rev-parse remotes\/origin\/${branch}";
my ${CB} = `$cmd`; chomp $CB;
print ${cmd} . "\n" . "Result: ${CB} \n";

#print $cmd . "\n" . "Result: $CM \n";
#$BM = `git merge-base remotes\/origin\/${branch} remotes\/origin\/master`; chomp $BM;

$cmd = "git merge-base origin\/${branch} origin\/master";
#$cmd = "git merge-base ${CB} ${CM}";

my $BM = `$cmd`; chomp $BM;
print $cmd . "\n" . "Result: $BM \n\n\n";

die "ERROR: CM - ${CM}\n       BM - ${BM}\n\n" if $CM =~ /^\s*$/ or $BM =~ /^\s*$/;

if ( $CM eq $BM ){ print "OK: Last Master commit ${CM}\nand Base commit from branch $branch $BM are equal!!!!\n\n"; exit;}


$cmd = "git show -s \-\-format=\%ci ${BM}";
$LM = `$cmd`;

print "========================================================================\n";
print "ERROR: Last Master commit $CM and Base \n       commit from branch $branch $BM are NOT equal!!!!\n\n";
print "$cmd\n";
print "Last merge from master time is: ${LM}"; 
print "========================================================================\n";

# Commits you need to merge
$C2M = '';
$BM2 = substr($BM,0,7);
#print "BM - $BM  BM2 = ${BM2}\n";
foreach (split("\n",`git log --oneline remotes\/origin\/master \| head -100`)){
    last if /^${BM2}/;
		$C2M .= "$_\n";
}

print "\n\n";
print "========================================================================\n";
print "Below you can find all commits of master you need to merge to your branch:\n";
print "========================================================================\n";
print "${C2M}\n\n"; 