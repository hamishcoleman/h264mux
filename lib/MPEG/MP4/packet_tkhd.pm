package MPEG::MP4::packet_tkhd;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my $version = unpack('C',$self->{_data});
    if ($version != 0) {
        ...
        # 64bit timestamps
    }

    my @fields = qw(
        version flags0 flags1 flags2
        ctime mtime track_ID reserved0 duration
        reserved1 reserved2 layer alternate_group volume reserved3
        matrix0 matrix1 matrix2 matrix3 matrix4 matrix5 matrix6 matrix7
        matrix8
        width height
    );
    my @values = unpack("C4NNNNNNNnnnnN9NN", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    if (length($self->{_data}) > 0x54) {
        $self->{_data_extra} = substr($self->{_data},0x54);
    }

    return $self;
}

1;
