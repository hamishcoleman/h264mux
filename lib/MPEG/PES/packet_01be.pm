package MPEG::PES::packet_01be;
# padding stream
use warnings;
use strict;

use MPEG::PES::packet_base_large;
our @ISA = qw(MPEG::PES::packet_base_large);
sub sync_value { 0x1be; }

# No contents
1;
