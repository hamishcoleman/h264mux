package MPEG::MP4::packet_stco;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @values = unpack("NN/N", $self->{_data});
    my %h;

    $h{version} = shift @values;
    $h{offsets} = \@values;

    if ($h{version} != 0) {
        ...
    }

    $self->{val} = \%h;

    # FIXME - if there is anything left in the stream, it is data_extra

    return $self;
}

sub to_string {
    my $self = shift;

    my $s = $self->SUPER::to_string();

    if (scalar(@{$self->{val}{offsets}})<4) {
        $s .= " offsets=".join(',',@{$self->{val}{offsets}});
    }

    return $s;
}

1;
