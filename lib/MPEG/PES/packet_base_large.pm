package MPEG::PES::packet_base_large;
# A large sized packet, so dont store all of the data (or dump it)
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    # TODO - apply a size threshold to deleting?
    delete $self->{val}{_data};

    return $self;
}

1;
