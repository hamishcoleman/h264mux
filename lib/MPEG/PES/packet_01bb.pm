package MPEG::PES::packet_01bb;
# a system header
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);
sub sync_value { 0x1bb; }

# TODO - decode contents:
# marker_bits x3
# rate_bound
# audio_bound
# fixed_flag
# CSPS_flag
# system_audio_lock_flag
# system_video_lock_flag
# video_bound
# packet_rate_restriction_flag
# reserved
# while bit7==1
#       stream_id
#       optional
#              stream_id_extension
#       P-STD_buffer_bound_scale
#       P-STD_buffer_size_bound

1;
