package MPEG::PES::packet_01b9;
# program end code
use warnings;
use strict;

use MPEG::packet_base;
our @ISA = qw(MPEG::packet_base);

sub sync_value { 0x1b9; }
sub length_fixed { 4; }

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @val = unpack('N',$self->{val});
    die("bad magic") if ($val[0] != $self->sync_value());

    delete $self->{val};

    # this pack packet ends the whole stream, so gets unindented
    $self->indent($self->indent()-1);

    return $self;
}

1;
