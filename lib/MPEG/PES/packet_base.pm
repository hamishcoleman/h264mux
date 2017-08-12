package MPEG::PES::packet_base;
# a packet with a 16bit length field
use warnings;
use strict;

use MPEG::packet_base
our @ISA = qw(MPEG::packet_base);

sub length_fixed { 6; }
 
sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @val = unpack('Nn',$self->{val});

    die("bad magic") if ($val[0] != $self->sync_value());

    my $h= {};
    $self->length_variable($val[1]);

    my $buf = $stream->read_bytes($self->length_variable());

    $h->{_data} = $buf;

    $self->{val} = $h;

    return $self;
}

1;
