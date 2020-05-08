package MPEG::TS::packet_base;
use warnings;
use strict;
#
# A base class for all TS packets
#

use MPEG::packet_base;
our @ISA = qw(MPEG::packet_base);

sub length_fixed {
    return 188;
}

1;
