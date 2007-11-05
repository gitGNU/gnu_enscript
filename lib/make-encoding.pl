#!/usr/local/bin/perl
#
# Create encoding vectors from the `*.txt' encoding files.
# Copyright (c) 1995-1998 Markku Rossi
#
# Author: Markku Rossi <mtr@iki.fi>
#

#
# This file is part of GNU enscript.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; see the file COPYING.  If not, write to
# the Free Software Foundation, 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301, USA.
#

#
# Handle arguments
#

if (@ARGV != 1) {
    print "usage: $0 encfile\n";
    exit(1);
}

$file = shift(@ARGV);

open(FP, $file) || die "couldn't open input file `$file': $!\n";

# Find the start of the table.
$found = 0;
while (<FP>) {
    if ($_ =~ /^-+$/) {
	$found = 1;
	last;
    }
}

if (!$found) {
    die "file `$file' is not a valid encoding file: couldn't find table\n";
}

$file =~ s/\.txt$//g;
$file =~ s/.*\///g;

# Print header.

print <<"EOF";
%
% $file encoding vector.
%
% This file is automatically generated from file \`$file.txt\'.  If you
% have any corrections to this file, please, edit file \`$file.txt\' instead.
%

%
% This file is part of GNU enscript.
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2, or (at your option)
% any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; see the file COPYING.  If not, write to
% the Free Software Foundation, 51 Franklin Street, Fifth Floor,
% Boston, MA 02110-1301, USA.
%

% -- code follows this line --
/encoding_vector [
EOF

$inum = 0;
$names_per_row = 4;
sub print_item {
    ($name) = @_;

    printf("%-14s\t", $name);
    if ((++$inum % $names_per_row) == 0) {
	printf("\n");
    }
}

# Process file.
while (<FP>) {
    @cols = split;
    if ($_ =~ /^\s*$/) {
	next;
    } elsif ($_ =~ /non-printable/) {
	$fields{hex(@cols[1])} = "/.notdef";
    } elsif (@cols[2] =~ /-/) {
	$fields{hex(@cols[1])} = "/.notdef";
    } else {
	$fields{hex(@cols[1])} = @cols[2];
    }
}

# Dump mapping.
for ($i = 0; $i < 256; $i++) {
    if (!defined($fields{$i})) {
	print "* code $i is not defined, assuming `.notdef'\n";
	$name = "/.notdef";
    } else {
	$name = $fields{$i};
    }
    print_item($name);
}

# Print trailer.
if (($inum % $names_per_row) != 0) {
    printf("\n");
}
print "\] def\n";

close(FP);
