package MPEG::TS::pid_generic;
#
# A generic do nothing disector
#
use warnings;
use strict;

use MPEG::packet_base;
our @ISA = qw(MPEG::packet_base);

sub sync_value { 0x47; }
sub length_fixed { 188; }

1;
