package MPEG::PES::packet_01c0;
# video stream number 0
# TODO - make this a generic audio stream thing
use warnings;
use strict;

use MPEG::PES::packet_generic_peshead;
our @ISA = qw(MPEG::PES::packet_generic_peshead);
sub sync_value { 0x1c0; }

1;
