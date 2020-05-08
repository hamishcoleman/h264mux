package MPEG::TS;
use warnings;
use strict;

use IO::File;

use MPEG::stream_base;
our @ISA = qw(MPEG::stream_base);

use MPEG::TS::packet_unknown;
use MPEG::TS::pid_generic;

sub packet_classname {
    my $self = shift;
    my $type = shift;

    my %types = (
        0 => 'MPEG::TS::pid_generic',
        0x11 => 'MPEG::TS::pid_generic',
    );

    my $class = $types{$type};
    if (defined($class)) {
        return $class;
    }

    return 'MPEG::TS::packet_unknown';
}

sub packet_sync_value {
    return 0x47;
}

# peek at the next dword, which might be a valid packet start code
sub peek_type {
    my $self = shift;
    my $size = 4;

    my $buf = $self->peek_bytes($size);
    if (!defined($buf)) {
        return undef;
    }

    my ($sync, $pid_hi, $pid_lo, $cc) = unpack("CCCC",$buf);

    if ($sync != $self->packet_sync_value()) {
        return undef;
    }

    my $pid = (($pid_hi & 0x1f) <<8) | $pid_lo;

    return $pid;
}

1;
