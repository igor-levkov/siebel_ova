#parselst.pl – Script to analyze flat files with data. I’ve used “@objtypes” array to hold information about variables. I’ve analyzed nearly 5MB of flat file less that 1 minute. If you need to analyze nearly 100-MB of flat files, for performance consideration you can implement “if … elseif … elseif“ conditional statement, it will work more faster.

######################################################################################
##
##		Script description:	script parses all *.lst* files in particular directory
##					and print problem statement survey in out.csv file
##
##		Author:			Timur Vafin, timur.vafin@gmail.com
##		Date:			06.08.2011
##
######################################################################################
#	initial directory for input lst files
my $dir = $ARGV[0];
######################################################################################

use File::Spec;

opendir (LSTDIR, "$dir") or die "Cannot open directory \"$dir\": ($!).\n";
my @files = grep(/\.lst/,readdir(LSTDIR));
closedir (LSTDIR);

my %objsvar;
my %objsvarc;
my $id;
my $cflg = 0;
my @objtypes = (	'this.BusComp',
					'ActiveBusComp',
					'GetBusComp',
					'GetAssocBusComp',
					'GetPicklistBusComp',
					'this.BusObject',
					'ActiveBusObject',
					'GetBusObject',
					'GetService',
					'NewPropertySet');

($vol,$script_dir,$f) = File::Spec->splitpath( $0 );
$out_file = File::Spec->catfile( $vol, $script_dir, 'out.csv' );

foreach my $file (@files) {

$file_path = File::Spec->catfile( $dir, $file );
open (FILE,"<", "$file_path") or die "Cannot open file \"$file_path\": ($!).\n";
while (my $line = <FILE>) {
	$line =~ s/\n//;
	if ($line =~ m/^Siebel Repository/ ) {
		$id = join ('#',split (/[ \t]+;/,$line));
#	Comment flag
	} elsif ($line =~ m/=.*\/\*/ || $line =~ m/^[ \t]*\/\//) {
		print "SKIPPED LINE:\n";
		print "\t$line\n";
	} elsif ($line =~ m/\/\*/ && $line !~ m/\*\//) {
		$cflg = 1;
	} elsif ($line =~ m/\*\// ) {
		$cflg = 0;
	} else {
#	Search for variables
		foreach my $objtype (@objtypes) {
			if ($line =~ m/=.*($objtype)/ && !$cflg && $line !~ m/($objtype)[ \t]*\([ \t]*.*[ \t]*\)[ \t]*\./) {
				$line =~ s/^[ \t]*//;
				$line =~ s/var[ \t]*//;
				$line =~ s/[ \t]*=.*//;
				$line =~ s/:.*//;
				$line =~ s/\(//g;
				$line =~ s/\)//g;
				$line =~ s/[ \t]*$//;
				$line =~ s/\}//g;
				$line =~ s/\{//g;
				$line =~ s/[;\/]+$//;

				#print "LINE: $line\n";
				if ($line !~ m/\[|if|return|while|^\&\&|^\|\|/ && $line !~ m/^\/\/|\/\*/) {
					if ($line =~ m/=/) {
						$line =~ s/[ \t]*//g;
						#print "\tPROCESSED LINE 1: $line\n";
							foreach my $litem (split('=',$line)) {
								push(@{$objsvar{$id}},$litem . "\#$objtype");
							};
					} else {
						#print "\tPROCESSED LINE 2: $line\n";
						push(@{$objsvar{$id}},$line . "\#$objtype");
					};
				};
			};
		};
#	Search for variables that become null
		if ($line =~ m/=[ \t]*null/ && !$cflg) {
			$line =~ s/^[ \t]*//;
			$line =~ s/[ \t]*=[ \t]*null.*//;
			if ($line !~ m/\[|^var[ \t]*|if|return|while|^\&\&|^\|\|/ && $line !~ m/^\/\/|\/\*/) {
				if ($line =~ m/=/) {
					$line =~ s/[ \t]*//g;
						foreach my $litem (split('=',$line)) {
							push(@{$objsvarc{$id}},$litem . "\#null");
						};
				} else {
					push(@{$objsvarc{$id}},$line . "\#null");
				};
			};
		};
	};
};
close (FILE);
};


#	Print problem Stements
open (CSV,">","$out_file") or die "Cannot create file \"$out_file\": ($!).\n";
print CSV "Siebel Repository Name#Object Type#Object Name#Function#Last Change Date#Open Variable#Assignment Method\n";
foreach my $id (sort keys %objsvar) {
	foreach my $val (@{$objsvar{$id}}) {
		my $tmp = (split('#',$val))[0] . "\#null";
		my $check = grep (/$tmp/,@{$objsvarc{$id}});
		if ( $check == 0 ) {
			print CSV "$id#$val\n";
		};
	};
};
close (CSV);
