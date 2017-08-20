package MPEG::MP4::packet_vmhd;
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
        version flags0 flags1 flags2
        graphicsmode
        opcolor0 opcolor1 opcolor2
    );
    my @values = unpack("CC3nn3", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    if ($h{version} != 0) {
        ...
    }

    $self->{val} = \%h;

    if (length($self->{_data}) > 12) {
        $self->{_data_extra} = substr($self->{_data},12);
    }

    return $self;
}

1;
