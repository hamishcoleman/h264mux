package MPEG::NAL::packet_unknown;
# class to hold unknown packets
use warnings;
use strict;

use MPEG::NAL::packet_base;
our @ISA = qw(MPEG::NAL::packet_base);

sub to_string {
    my $self = shift;

    my ($dword, $type) = unpack('NC',$self->{val});

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" Unknown packet 0x%02x\n", $type);
    return $s;
}

1;
