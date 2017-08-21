package MPEG::MP4::packet_tfdt;
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
    if ($version != 1) {
        ...
        # 32bit timestamps
    }

    my @fields = qw(
        version flags0 flags1 flags2
        baseMediaDecodeTime
    );
    my @values = unpack("C4Q>", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    return $self;
}

1;
