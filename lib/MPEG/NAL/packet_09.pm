package MPEG::NAL::packet_09;
# Access unit delimeter
use warnings;
use strict;

use MPEG::packet_base;
our @ISA = qw(MPEG::packet_base);
sub length_fixed { 0x6; }

# TODO - contents
1;
