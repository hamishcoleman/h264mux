package MPEG::MP4::packet_mfhd;
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
        sequence_number
    );
    my @values = unpack("NN", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    if (length($self->{_data}) > 8) {
        $self->{_data_extra} = substr($self->{_data},8);
    }

    return $self;
}

1;
