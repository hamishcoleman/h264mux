package MPEG::PES::packet_unknown;
# class to hold unknown packets
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);
sub length_fixed { 4; }

sub to_string {
    my $self = shift;

    my $dword = unpack('N',$self->{val});

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" Unknown packet 0x%08x\n", $dword);
    return $s;
}

1;
