package MPEG::stream_base;
use warnings;
use strict;

use IO::File;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    $self->current_indent(1);

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

sub read_packets {
    my $self = shift;

    return undef if $self->{_fh}->eof();

    my $packet;
    my $dword = $self->peek_packet();
    my $class = $self->packet_known_map()->{$dword};

    if (defined($class)) {
        $packet = $class->new();
    } else {
        $packet = $self->packet_unknown()->new();
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
