package MPEG::MP4;
use warnings;
use strict;

use IO::File;

use MPEG::stream_base;
our @ISA = qw(MPEG::stream_base);

use MPEG::MP4::packet_unknown;

use MPEG::MP4::container_avc1;
use MPEG::MP4::container_dinf;
use MPEG::MP4::container_dref;
use MPEG::MP4::container_edts;
use MPEG::MP4::container_gshh;
use MPEG::MP4::container_gspm;
use MPEG::MP4::container_gspu;
use MPEG::MP4::container_gssd;
use MPEG::MP4::container_gsst;
use MPEG::MP4::container_gstd;
use MPEG::MP4::container_ilst;
use MPEG::MP4::container_mdia;
use MPEG::MP4::container_meta;
use MPEG::MP4::container_minf;
use MPEG::MP4::container_moov;
use MPEG::MP4::container_stbl;
use MPEG::MP4::container_stsd;
use MPEG::MP4::container_trak;
use MPEG::MP4::container_udta;
use MPEG::MP4::packet_data;
use MPEG::MP4::packet_elst;
use MPEG::MP4::packet_ftyp;
use MPEG::MP4::packet_hdlr;
use MPEG::MP4::packet_mdhd;
use MPEG::MP4::packet_mvhd;
use MPEG::MP4::packet_stco;
use MPEG::MP4::packet_stsc;
use MPEG::MP4::packet_stss;
use MPEG::MP4::packet_stsz;
use MPEG::MP4::packet_stts;
use MPEG::MP4::packet_tkhd;
use MPEG::MP4::packet_url;
use MPEG::MP4::packet_vmhd;

sub packet_classname {
    my $self = shift;
    my $type = shift;

    my %types = (
        'avc1' => 'MPEG::MP4::container_avc1',
        'data' => 'MPEG::MP4::packet_data',
        'dinf' => 'MPEG::MP4::container_dinf',
        'dref' => 'MPEG::MP4::container_dref',
        'edts' => 'MPEG::MP4::container_edts',
        'elst' => 'MPEG::MP4::packet_elst',
        'ftyp' => 'MPEG::MP4::packet_ftyp',
        'gshh' => 'MPEG::MP4::container_gshh',
        'gspm' => 'MPEG::MP4::container_gspm',
        'gspu' => 'MPEG::MP4::container_gspu',
        'gssd' => 'MPEG::MP4::container_gssd',
        'gsst' => 'MPEG::MP4::container_gsst',
        'gstd' => 'MPEG::MP4::container_gstd',
        'hdlr' => 'MPEG::MP4::packet_hdlr',
        'ilst' => 'MPEG::MP4::container_ilst',
        'mdhd' => 'MPEG::MP4::packet_mdhd',
        'mdia' => 'MPEG::MP4::container_mdia',
        'meta' => 'MPEG::MP4::container_meta',
        'minf' => 'MPEG::MP4::container_minf',
        'moov' => 'MPEG::MP4::container_moov',
        'mvhd' => 'MPEG::MP4::packet_mvhd',
        'stbl' => 'MPEG::MP4::container_stbl',
        'stco' => 'MPEG::MP4::packet_stco',
        'stsd' => 'MPEG::MP4::container_stsd',
        'stsc' => 'MPEG::MP4::packet_stsc',
        'stss' => 'MPEG::MP4::packet_stss',
        'stsz' => 'MPEG::MP4::packet_stsz',
        'stts' => 'MPEG::MP4::packet_stts',
        'tkhd' => 'MPEG::MP4::packet_tkhd',
        'trak' => 'MPEG::MP4::container_trak',
        'udta' => 'MPEG::MP4::container_udta',
        'url ' => 'MPEG::MP4::packet_url',
        'vmhd' => 'MPEG::MP4::packet_vmhd',
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
    if (!defined($buf)) {
        return undef;
    }

    my ($length, $type) = unpack("Na4",$buf);

    return $type;
}

1;
