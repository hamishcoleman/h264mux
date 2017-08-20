package MPEG::MP4::packet_mdhd;
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
        version ctime mtime timescale duration lang zero
    );
    my @values = unpack("NNNNNnn", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    if (length($self->{_data}) > 0x18) {
        $self->{_data_extra} = substr($self->{_data},0x18);
    }

    return $self;
}

1;
