package MPEG::MP4::container_base_ver;
# 
use warnings;
use strict;

use MPEG::MP4::container_base;
our @ISA = qw(MPEG::MP4::container_base);

sub read_data_pre_container {
    my $self = shift;
    my $stream = shift;

    my $data = $stream->read_bytes(4);
    my $version = unpack('N',$data);
    if ($version != 0) {
        ...
        # 64bit timestamps
    }

    my @fields = qw(
        version
    );
    my @values = unpack("N", $data);
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    return $self;
}

1;
