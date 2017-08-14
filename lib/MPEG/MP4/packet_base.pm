package MPEG::MP4::packet_base;
# a packet with a LTV format
use warnings;
use strict;

use MPEG::packet_base
our @ISA = qw(MPEG::packet_base);

# TODO - length_fixed can be variable!
sub length_fixed { 8; }
 
sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my ($length, $type) = unpack('Na4',$self->{_data});
    delete $self->{_data};

    # TODO:
    # if length == 1, next 64bits is real length
    # if length == 0, length is until EOF
    # if type == "uuid", type is next 16 bytes as usertype or extended type

    $self->length_variable($length - $self->length_fixed());
    $self->{_type} = $type;

    my $buf = $stream->read_bytes($self->length_variable());

    $self->{_data} = $buf;

    return $self;
}

1;
