#!/usr/bin/perl

# Copyright (C) 2013 Akira Hasegawa <ah3q@gsc.riken.jp>
# 
# This file is part of MOIRAI.
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

############################## USE ##############################

use strict 'vars';
use Cwd;
use IO::File;
use File::Basename;
use Getopt::Std;

############################## HEADER ##############################

my ( $program_name, $program_directory, $program_suffix ) = fileparse( $0 );
$program_directory = substr( $program_directory, 0, -1 ); # remove last "/"

############################## OPTIONS ##############################

use vars qw( $opt_h $opt_H );
getopts( 'hH' );

############################## HELP ##############################

if( defined( $opt_h ) || defined( $opt_H ) ) {
	print "\n";
	print "Program: Return value from MOIRAI config file from key.\n";
	print "Author: Akira Hasegawa (ah3q\@gsc.riken.jp)\n";
	print "\n";
	print "Usage: $program_name KEY < INPUT > OUTPUT\n";
	print "\n";
	print "       KEY     Key to look through Moirai config file\n";
	print "       INPUT   Moirai config file\n";
	print "       OUTPUT  Value from Moirai.config\n";
	print "\n";
	print "Options: -h  Show help lines (default='none')\n";
	print "         -H  Show help lines (default='none')\n";
	print "\n";
	print "Note: This program is used to get value from Moirai.config fil by the shell scripts.\n";
	print "\n";
	print "Updates: Unified help message across perl, java, and shell scripts.\n";
	print "\n";
	exit( 0 );
}

############################## MAIN ##############################

# Read hashtable
my $hashtable = {};
while( <STDIN> ) {
	chomp; s/\r//g;
	my ( $key, $value ) = split( /\t/, $_, 2 );
	$hashtable->{ $key } = $value;
}

# From barcode file and filename, it tries to match appropriate genome assembly file.
foreach my $argument ( @ARGV ) {
	if( exists( $hashtable->{ $argument } ) ) { print $hashtable->{ $argument } . "\n" }
}
