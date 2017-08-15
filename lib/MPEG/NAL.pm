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

# A much trickier resync function - this makes the speed actually usable
sub resync {
    my $self = shift;

    # read in bigger chunks to speed things up
    my $read_size = 4096;

    my $remainder;
    while(1) {
        my $buf = $self->read_bytes($read_size);
        if (!defined($buf)) {
            return undef;
        }

        # add in any remainder from the last block
        if (defined($remainder)) {
            $buf = $remainder . $buf;
        }

        my $index = index($buf,"\000\000\000\001");
        if ($index != -1) {
            my $buf_len = length($buf);
            my $actualoffset = -($buf_len-$index);
            $self->{_fh}->seek($actualoffset,1);
            return $self;
        }

        # check if we might have a sync word on the boundary of our buffer
        if (substr($buf,-1,3) eq "\000\000\000") {
            $remainder = "\000\000\000";
        } elsif (substr($buf,-1,2) eq "\000\000") {
            $remainder = "\000\000";
        } elsif (substr($buf,-1,1) eq "\000") {
            $remainder = "\000";
        } else {
            $remainder = undef;
        }
    }
}

1;
