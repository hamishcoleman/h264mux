package MPEG::MP4::packet_ftyp;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my ($major_brand, $minor_version, @compat) =
        unpack('a4N(a4)*',$self->{_data});

    my $h = {};
    $h->{major_brand} = $major_brand;
    $h->{minor_version} = $minor_version;
    @{$h->{compatible_brands}} = @compat;

    $self->{val} = $h;

    return $self;
}

1;
