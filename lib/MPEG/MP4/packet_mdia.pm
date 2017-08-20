package MPEG::MP4::packet_mvhd;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my $version = unpack('N',$self->{_data});
    if ($version != 0) {
        ...
        # 64bit timestamps
    }

    my @fields = qw(
        version ctime mtime timescale duration rate volume
        reserved0 reserved1 reserved2 matrix0 matrix1 matrix2 matrix3
        matrix4 matrix5 matrix6 matrix7 matrix8 zero0 zero1 zero2 zero3
        zero4 zero5 next_track_ID
    );
    my @values = unpack("NNNNNNnnN2N9N6N", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    if (length($self->{_data}) > 0x64) {
        $self->{_data_extra} = substr($self->{_data},0x64);
    }

    return $self;
}

1;
