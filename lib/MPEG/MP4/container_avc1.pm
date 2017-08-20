package MPEG::MP4::container_avc1;
# 
use warnings;
use strict;

use MPEG::MP4::container_base;
our @ISA = qw(MPEG::MP4::container_base);

sub read_data_pre_container {
    my $self = shift;
    my $stream = shift;

    my $data = $stream->read_bytes(0x4e);

    my @fields = qw(
        reserved0 reserved1 reserved2 reserved3 reserved4 reserved5
        data_reference_index
        unknown
    );
    my @values = unpack("C6na*", $data);
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    return $self;
}

1;
