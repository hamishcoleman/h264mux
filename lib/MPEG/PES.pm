package MPEG::PES;
use warnings;
use strict;

use IO::File;

use MPEG::stream_base;
our @ISA = qw(MPEG::stream_base);

use MPEG::PES::packet_unknown;
use MPEG::PES::packet_01b9;
use MPEG::PES::packet_01ba;
use MPEG::PES::packet_01bb;
use MPEG::PES::packet_01bc;
use MPEG::PES::packet_01bd;
use MPEG::PES::packet_01be;
use MPEG::PES::packet_01c0;
use MPEG::PES::packet_01e0;

sub packet_unknown {
    return "MPEG::PES::packet_unknown";
}

sub packet_known_map {
    return {
        0x1b9 => 'MPEG::PES::packet_01b9',
        0x1ba => 'MPEG::PES::packet_01ba',
        0x1bb => 'MPEG::PES::packet_01bb',
        0x1bc => 'MPEG::PES::packet_01bc',
        0x1bd => 'MPEG::PES::packet_01bd',
        0x1be => 'MPEG::PES::packet_01be',
        0x1c0 => 'MPEG::PES::packet_01c0',
        0x1e0 => 'MPEG::PES::packet_01e0',
    };
}

# TODO - this sync value is actually "0x00 0x00 0x01", with "0xba"
# as the only valid starting streamid
sub packet_sync_value {
    return 0x1ba;
}

# peek at the next dword, which might be a valid packet start code
sub peek_type {
    my $self = shift;
    my $size = 4;

    my $buf = $self->peek_bytes($size);
    if (!defined($buf)) {
        return undef;
    }

    my $dword = unpack("N",$buf);

    if (($dword & 0xffffff00) != 0x00000100) {
        return undef;
    }

    return $dword;
}

1;
