package MPEG::PES::packet_01bd;
# private_stream_1
use warnings;
use strict;

use MPEG::PES::packet_generic_large;
our @ISA = qw(MPEG::PES::packet_generic_large);
sub sync_value { 0x1bd; }

# TODO: work out what the contents are
1;
