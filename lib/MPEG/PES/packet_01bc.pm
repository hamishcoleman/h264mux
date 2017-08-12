package MPEG::PES::packet_01bc;
# Program Stream Map
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);
sub sync_value { 0x1bc; }

# TODO - decode contents:
# current_next_indicator
# single_extension_stream_flag
# reserved
# program_stream_map_version
# reserved
# marker_bit
# program_stream_info_length
#       n * descriptor()
# elementary_stream_map_length
#       n * :
#               stream_type
#               elementary_stream_id
#               elementary_stream_info_length
#                       n * descriptor()
# CRC_32

1;
