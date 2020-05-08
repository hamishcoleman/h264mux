package MPEG::TS::packet_unknown;
# class to hold unknown packets
use warnings;
use strict;

use MPEG::TS::packet_base;
our @ISA = qw(MPEG::TS::packet_base);

# Override the parent class reader, since we need to return undef for unknown
sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);
    return undef;
}

sub to_string {
    my $self = shift;

    my ($sync, $pid_hi, $pid_lo, $cc) = unpack("CCCC",$self->{_data});
    my $pid = (($pid_hi & 0x1f) <<8) | $pid_lo;

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" Unknown packet pid=0x%02x", $pid);
    return $s;
}

1;
