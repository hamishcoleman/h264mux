package MPEG::MP4::packet_trex;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @fields = qw(
        version
        track_ID
        default_sample_description_index
        default_sample_duration
        default_sample_size
        default_sample_flags
    );
    my @values = unpack("NNNNNN", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    if (length($self->{_data}) > 24) {
        $self->{_data_extra} = substr($self->{_data},24);
    }

    return $self;
}

1;
