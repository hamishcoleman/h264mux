package MPEG::PES::packet_01ba;
# a Program Stream pack packet
# FIXME - this packet (optionally) contains the system_header (0x1bb)
# and is not followed by it, as coded here
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);

sub sync_value { 0x1ba; }
sub length_fixed { 14; }

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @val = unpack('NC*',$self->{val});

    # MPEG1 has different marker here - and different header structure
    die("bad magic") if ($val[0] != $self->sync_value());

    # check all the magic values at once
    die("bad marker") if ((($val[1] >>6) & 0x3) != 1);
    die("bad marker") if ((($val[1] >>2) & 0x1) != 1);
    die("bad marker") if ((($val[3] >>2) & 0x1) != 1);
    die("bad marker") if ((($val[5] >>2) & 0x1) != 1);
    die("bad marker") if (($val[6] & 0x1) != 1);
    die("bad marker") if (($val[9] & 0x3) != 3);

    my $h= {};
    $h->{scr} =
        (($val[1] >>3) & 0x7) << 30 |
        (($val[1] ) & 0x3) << 28 |
        (($val[2] )) << 20 |
        (($val[3] >>3) & 0x1f) << 15 |
        (($val[3] ) & 0x3) << 13 |
        (($val[4] )) << 5 |
        (($val[5] >>3) & 0x1f);
    $h->{scr_ext} =
        (($val[5] ) & 0x3) << 7 |
        (($val[6] >>1));
    $h->{bitrate} =
        (($val[7] )) <<15 |
        (($val[8] )) <<6 |
        (($val[9] >>2));
    # TODO - check the reserved bytes?
    $self->length_variable((($val[10]) & 0x7));

    my $buf = $stream->read_bytes($self->length_variable());
    $h->{stuff_bytes} = $buf;

    $self->{val} = $h;

    # this pack packet starts a new group, so is unindented
    $self->indent($self->indent()-1);
    # this packet has children, so they get indented
    $stream->current_indent($self->indent()+1);

    return $self;
}

sub to_string {
    my $self = shift;

    my $s = $self->SUPER::to_string();
    $s .= sprintf(" scr=%i", $self->{val}{scr});
    return $s;
}

1;
