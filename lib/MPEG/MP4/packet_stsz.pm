package MPEG::MP4::packet_stsz;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @values = unpack("NNN/N", $self->{_data});
    my %h;

    $h{version} = shift @values;
    $h{sample_size} = shift @values;
    $h{sample_count} = scalar(@values);
    $h{samples} = \@values;

    if ($h{version} != 0) {
        ...
    }

    $self->{val} = \%h;

    # FIXME - if there is anything left in the stream, it is data_extra

    return $self;
}

1;
