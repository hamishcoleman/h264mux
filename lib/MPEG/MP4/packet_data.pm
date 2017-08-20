package MPEG::MP4::packet_data;
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
        version unk string
    );
    my @values = unpack("NNZ*", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    # FIXME - need to know the number of bytes consumed to determine if there
    # is extra data present

    return $self;
}

1;
