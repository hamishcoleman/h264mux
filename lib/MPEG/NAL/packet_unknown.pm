package MPEG::NAL::packet_unknown;
# class to hold unknown packets
use warnings;
use strict;

use MPEG::NAL::packet_base;
our @ISA = qw(MPEG::NAL::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);
    return undef;
}

sub to_string {
    my $self = shift;

    my ($dword, $type) = unpack('NC',$self->{_data});

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" Unknown packet 0x%02x", $type);
    return $s;
}

1;
