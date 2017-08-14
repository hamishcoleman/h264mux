package MPEG::MP4::container_base;
use warnings;
use strict;
#
# Implement a packet type that is a container for other packets
#

use IO::String;

use MPEG::MP4;
use MPEG::MP4::packet_base;

our @ISA = qw(MPEG::MP4 MPEG::MP4::packet_base);

sub open {
    my $self = shift;
    my $string = shift;
    my $fh = IO::String->new($string);
    if (!defined($fh)) {
        die("Could not use string: $!");
    }
    $self->{_fh} = $fh;
    return $self;
}

sub current_offset {
    my $self = shift;
    return $self->offset() + $self->length_fixed() + $self->{_fh}->tell();
}

sub _cb {
    my $self = shift;
    my $packet = shift;

    push @{$self->{_packets}}, $packet;
}

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    # create the stream
    $self->open($self->{_data});
    $self->packet_cb(sub { $self->_cb(shift); });
    $self->current_indent($self->indent()+1);

    @{$self->{_packets}} = ();

    # if this container is prefixed with data, read that out first
    if ($self->can('read_data_pre_container')) {
        $self->read_data_pre_container($self);
    }

    while ($self->read_packets()) { };

    my @packets = ($self,@{$self->{_packets}});

    # clean up the object for dumping..
    my $data_extra_count = $self->length_variable() - $self->{_fh}->tell();
    if ($data_extra_count) {
        $self->{_data_extra} = $self->read_bytes($data_extra_count);
    }

    delete $self->{_data};
    delete $self->{_packets};

    if (!scalar(@packets)) {
        # we found a stop condition
        return undef;
    }
    return @packets;
}
