package MPEG::PES::packet_01e0;
# video stream number 0
# TODO - make this a generic video stream thing
use warnings;
use strict;

use MPEG::PES::packet_generic_peshead;
our @ISA = qw(MPEG::PES::packet_generic_peshead);
sub sync_value { 0x1e0; }

1;
