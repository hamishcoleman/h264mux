package MPEG::NAL;
use warnings;
use strict;

use IO::File;

use MPEG::stream_base;
our @ISA = qw(MPEG::stream_base);

use MPEG::NAL::packet_unknown;
use MPEG::NAL::packet_09;
use MPEG::NAL::packet_21;
use MPEG::NAL::packet_25;
use MPEG::NAL::packet_27;
use MPEG::NAL::packet_28;

sub packet_classname {
    my $self = shift;
    my $type = shift;

    my %types = (
        0x09 => 'MPEG::NAL::packet_09',
        0x21 => 'MPEG::NAL::packet_21',
        0x25 => 'MPEG::NAL::packet_25',
        0x27 => 'MPEG::NAL::packet_27',
        0x28 => 'MPEG::NAL::packet_28',
    );

    my $class = $types{$type};
    if (defined($class)) {
        return $class;
    }
    return 'MPEG::NAL::packet_unknown';
}

sub packet_sync_value {
    return 0x1;
}

# peek at the next dword, which might be a valid packet start code
sub peek_type {
    my $self = shift;
    my $size = 5;

    my $buf = $self->peek_bytes($size);
    if (!defined($buf)) {
        return undef;
    }

    my ($dword,$type) = unpack("NC",$buf);

    # TODO - NAL streams can have both 00,00,00,01 and 00,00,01 as sync markers
    if ($dword != $self->packet_sync_value()) {
        return undef;
    }

    return $type;
}

1;
