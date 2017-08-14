package MPEG::MP4::packet_unknown;
# class to hold unknown packets
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);
sub length_fixed { 8; }

# Because every packet in the MP4 container format has a length value, we will
# never lose sync, and can omit the full stop on unknown packets
# Thus, we do not redefine the read() method

sub to_string {
    my $self = shift;

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" Unknown packet %s", $self->{_type});
    return $s;
}

1;
