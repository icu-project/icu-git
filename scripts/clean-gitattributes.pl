#!/usr/bin/perl
# Copyright (C) 2017 and later: Unicode, Inc. and others.
# License & terms of use: http://www.unicode.org/copyright.html 

# This script is used to clean up the .gitattributes file after the SubGit conversion.

# Preserves any line that contains -text, and also adds the "default" attributes for common
# file types.

use strict;
use warnings;

my $input_filename = '.gitattributes';
my $output_filename = '.gitattributes';

my @lines;

# Simple helper to remove both leading and trailing white-space.
sub trim
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}

# Read the input file.
{
    open (my $fh, '<:encoding(UTF-8)', $input_filename)
        or die "Could not open '$input_filename' $!";

    while (my $line = <$fh>) {
        
        next if ($line =~ /^#/);        # Skip comments.
        next if ($line =~ /^\s+$/);     # Skip blanks.
        next if ($line =~ /^\Q* text=auto !eol\E$/);    # Skip default.
        next if ($line =~ /^\Q*.\E/);     # Skip Git-LFS entries.

        my @fields = split(/\s+/, trim($line));

        my $filename = shift(@fields);

        if ( grep(/^-text/, @fields) ) {
            my $newline = $filename . ' -text';
            push (@lines, $newline);
        }
    }
    close $fh;
}

# Output the new file.
{
    open (my $fh, '>:encoding(UTF-8)', $output_filename)
        or die "Could not open '$output_filename'.";

    print $fh "* text=auto !eol\n";
    print $fh "\n";
    print $fh "*.c text !eol\n";
    print $fh "*.cc text !eol\n";
    print $fh "*.classpath text !eol\n";
    print $fh "*.cpp text !eol\n";
    print $fh "*.css text !eol\n";
    print $fh "*.dsp text !eol\n";
    print $fh "*.dsw text !eol\n";
    print $fh "*.filters text !eol\n";
    print $fh "*.h text !eol\n";
    print $fh "*.htm text !eol\n";
    print $fh "*.html text !eol\n";
    print $fh "*.in text !eol\n";
    print $fh "*.java text !eol\n";
    print $fh "*.launch text !eol\n";
    print $fh "*.mak text !eol\n";
    print $fh "*.md text !eol\n";
    print $fh "*.MF text !eol\n";
    print $fh "*.mk text !eol\n";
    print $fh "*.pl text !eol\n";
    print $fh "*.pm text !eol\n";
    print $fh "*.project text !eol\n";
    print $fh "*.properties text !eol\n";
    print $fh "*.py text !eol\n";
    print $fh "*.rc text !eol\n";
    print $fh "*.sh text eol=lf\n";
    print $fh "*.sln text !eol\n";
    print $fh "*.stub text !eol\n";
    print $fh "*.txt text !eol\n";
    print $fh "*.ucm text !eol\n";
    print $fh "*.vcproj text !eol\n";
    print $fh "*.vcxproj text !eol\n";
    print $fh "*.xml text !eol\n";
    print $fh "*.xsl text !eol\n";
    print $fh "*.xslt text !eol\n";
    print $fh "Makefile text !eol\n";
    print $fh "configure text !eol\n";
    print $fh "LICENSE text !eol\n";
    print $fh "README text !eol\n";
    print $fh "\n";
    print $fh "*.bin -text\n";
    print $fh "*.brk -text\n";
    print $fh "*.cnv -text\n";
    print $fh "*.icu -text\n";
    print $fh "*.res -text\n";
    print $fh "*.nrm -text\n";
    print $fh "*.spp -text\n";
    print $fh "*.tri2 -text\n";
    print $fh "\n";

    # all of subgit lines go here.
    if (scalar @lines != 0) {
        
        foreach my $line (@lines) {
            print $fh $line."\n";
        }
        print $fh "\n";
    }
    
    print $fh "# The following file types are stored in Git-LFS.\n";
    print $fh "*.jar filter=lfs diff=lfs merge=lfs -text\n";
    print $fh "*.dat filter=lfs diff=lfs merge=lfs -text\n";
    print $fh "*.zip filter=lfs diff=lfs merge=lfs -text\n";
    print $fh "*.gz filter=lfs diff=lfs merge=lfs -text\n";
    print $fh "*.bz2 filter=lfs diff=lfs merge=lfs -text\n";
    print $fh "*.gif filter=lfs diff=lfs merge=lfs -text\n";
    print $fh "\n";

    close $fh;
}
