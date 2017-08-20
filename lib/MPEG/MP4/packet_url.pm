package MPEG::MP4::packet_url;
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
        string
    );
    my @values = unpack("CC3Z*", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    if ($h{version} != 0) {
        ...
    }

    $self->{val} = \%h;

    return $self;
}

1;
