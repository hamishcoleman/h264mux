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
    $stream->read_bytes(4);

    # find the next header
    $stream->resync();

    my $offset_end = $stream->current_offset();
    $self->length_variable($offset_end - $self->offset());

    # FIXME - digging around in object privates
    $stream->{_fh}->seek($self->offset(),0);

    my $buf = $stream->read_bytes($self->length_variable());
    if (!defined($buf)) {
        return undef;
    }

    $self->{_data} = $buf;
    # TODO - implement 00 00 03 unstuffing

    return $self;
}

1;
