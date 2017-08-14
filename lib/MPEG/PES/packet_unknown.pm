package MPEG::PES::packet_unknown;
# class to hold unknown packets
use warnings;
use strict;

use MPEG::packet_base;
our @ISA = qw(MPEG::packet_base);
sub length_fixed { 4; }

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);
    return undef;
}

sub to_string {
    my $self = shift;

    my $dword = unpack('N',$self->{_data});

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" Unknown packet 0x%08x", $dword);
    return $s;
}

1;
