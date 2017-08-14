package MPEG::MP4;
use warnings;
use strict;

use IO::File;

use MPEG::stream_base;
our @ISA = qw(MPEG::stream_base);

use MPEG::MP4::packet_unknown;

use MPEG::MP4::container_dinf;
use MPEG::MP4::container_dref;
use MPEG::MP4::container_mdia;
use MPEG::MP4::container_minf;
use MPEG::MP4::container_moov;
use MPEG::MP4::container_trak;
use MPEG::MP4::container_stbl;
use MPEG::MP4::container_stsd;
use MPEG::MP4::packet_ftyp;
use MPEG::MP4::packet_hdlr;
use MPEG::MP4::packet_mdhd;
use MPEG::MP4::packet_mvhd;
use MPEG::MP4::packet_tkhd;

sub packet_classname {
    my $self = shift;
    my $type = shift;

    my %types = (
        'dinf' => 'MPEG::MP4::container_dinf',
        'dref' => 'MPEG::MP4::container_dref',
        'ftyp' => 'MPEG::MP4::packet_ftyp',
        'hdlr' => 'MPEG::MP4::packet_hdlr',
        'mdhd' => 'MPEG::MP4::packet_mdhd',
        'mdia' => 'MPEG::MP4::container_mdia',
        'minf' => 'MPEG::MP4::container_minf',
        'moov' => 'MPEG::MP4::container_moov',
        'mvhd' => 'MPEG::MP4::packet_mvhd',
        'stbl' => 'MPEG::MP4::container_stbl',
        'stsd' => 'MPEG::MP4::container_stsd',
        'tkhd' => 'MPEG::MP4::packet_tkhd',
        'trak' => 'MPEG::MP4::container_trak',
    );

    my $class = $types{$type};
    if (defined($class)) {
        return $class;
    }
    return "MPEG::MP4::packet_unknown";
}

# TODO - how does a MP4 container handle streaming?>
#sub packet_sync_value {
#    return undef;
#}

# peek at the next dword, which might be a valid packet start code
sub peek_type {
    my $self = shift;
    my $size = 8;

    my $buf = $self->peek_bytes($size);

    my ($length, $type) = unpack("Na4",$buf);

    return $type;
}

1;
