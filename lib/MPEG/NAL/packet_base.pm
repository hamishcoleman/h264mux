package MPEG::NAL::packet_base;
use warnings;
use strict;
#
# A base class for all NAL packets
#

use MPEG::packet_base;
our @ISA = qw(MPEG::packet_base);

# TODO
# - probably should include the header and type byte in the fixed value
# but that would mean that the 'fixed' length changes when there
# is a different length header
sub length_fixed {
    return 0;
}

sub read {
    my $self = shift;
    my $stream = shift;

    $self->offset($stream->current_offset());

    # skip the current packet header marker
    my $packet = $stream->read_bytes(4);
    if (!defined($packet)) {
        return undef;
    }

    # find the next header
    my $buf = $stream->resync();
    if (!defined($buf)) {
        return undef;
    }

    $packet .= $buf;

    $self->length_variable(length($packet));

    $self->{_data} = $packet;
    # TODO - implement 00 00 03 unstuffing ?

    return $self;
}

1;
