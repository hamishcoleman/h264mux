package MPEG::PES;
use warnings;
use strict;

use IO::File;

use MPEG::PES::packet_unknown;
use MPEG::PES::packet_01b9;
use MPEG::PES::packet_01ba;
use MPEG::PES::packet_01bb;
use MPEG::PES::packet_01bc;
use MPEG::PES::packet_01bd;
use MPEG::PES::packet_01be;
use MPEG::PES::packet_01c0;
use MPEG::PES::packet_01e0;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub open {
    my $self = shift;
    my $filename = shift;
    my $fh = IO::File->new($filename,"r");
    if (!defined($fh)) {
        die("Could not open $filename: $!");
    }
    $self->{_fh} = $fh;
    return $self;
}

sub current_offset {
    my $self = shift;
    return $self->{_fh}->tell();
}

sub current_indent {
    my $self = shift;
    my $val = shift;
    if (defined($val) && $val>0) {
        $self->{current_indent} = $val;
    }
    return $self->{current_indent};
}

sub packet_cb {
    my $self = shift;
    my $val = shift;
    if (defined($val)) {
        $self->{packet_cb} = $val;
    }
    return $self->{packet_cb};
}

sub read_bytes {
    my $self = shift;
    my $size = shift;
    die("need size") if (!defined($size));

    my $buf;
    my $count = $self->{_fh}->read($buf,$size);
    if ($count != $size) {
        die("read size mismatch");
    }
    return $buf;
}

# peek at the next dword, which might be a valid packet start code
sub peek_packet {
    my $self = shift;
    my $sync_size = 4;

    my $buf = $self->read_bytes($sync_size);

    # rewind back over the sync byte
    $self->{_fh}->seek(-$sync_size,1);
    return unpack("N",$buf);
}

# a very simple sync byte search
# TODO - this sync value is actually "0x00 0x00 0x01", with "0xba"
# as the only valid starting streamid
sub resync {
    my $self = shift;
    my $sync_value = 0x1ba;

    while(!$self->{_fh}->eof()) {
        my $dword = $self->peek_packet();
        if ($dword == $sync_value) {
            return $self;
        }

        # skip to the next possible position
        $self->{_fh}->seek(1,1);
    }
}

sub read_packets {
    my $self = shift;

    return undef if $self->{_fh}->eof();

    my $packets = {
        0x1b9 => 'MPEG::PES::packet_01b9',
        0x1ba => 'MPEG::PES::packet_01ba',
        0x1bb => 'MPEG::PES::packet_01bb',
        0x1bc => 'MPEG::PES::packet_01bc',
        0x1bd => 'MPEG::PES::packet_01bd',
        0x1be => 'MPEG::PES::packet_01be',
        0x1c0 => 'MPEG::PES::packet_01c0',
        0x1e0 => 'MPEG::PES::packet_01e0',
    };

    my $dword = $self->peek_packet();

    my $class = $packets->{$dword};
    my $packet;
    if (defined($class)) {
        $packet = $class->new();
    } else {
        $packet = MPEG::PES::packet_unknown->new();
    }

    $packet->indent($self->current_indent());
    $self->{packets}{$dword} = $packet;
    $packet->read($self);

    &{$self->packet_cb()}($packet);

    if (!defined($class)) {
        return undef;
    }

    return $packet;
}

1;
