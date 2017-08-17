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
    if (!defined($count)) {
        die("read error");
    }
    if ($count == 0) {
        # no data left
        return undef;
    }
    if ($count != $size) {
        # could just be the end of the data
        warn("read size mismatch");
    }
    return $buf;
}

sub peek_bytes {
    my $self = shift;
    my $size = shift;

    my $buf = $self->read_bytes($size);
    if (!defined($buf)) {
        return undef;
    }

    $self->{_fh}->seek(-$size,1);

    return $buf;
}

sub read_packets {
    my $self = shift;

    my $packet;
    my $type = $self->peek_type();
    if (!defined($type)) {
        return undef;
    }

    my $class = $self->packet_classname($type);
    if (!defined($class)) {
        return undef;
    }

    $packet = $class->new();

    $packet->indent($self->current_indent());
    $self->{packets}{$type} = $packet;
    my @packets = $packet->read($self);

    if (!defined($packets[0])) {
        # no packets returned, this is an unknown class and we need to stop
        # still callback though, so we can output an unknown packet string
        &{$self->packet_cb()}($packet);
        return undef;
    }

    for my $entry (@packets) {
        &{$self->packet_cb()}($entry);
    }

    return $self;
}

# a very simple sync byte search
sub resync {
    my $self = shift;
    my $sync_value = $self->packet_sync_value();

    while(1) {
        my $type = $self->peek_type();
        if (defined($type)) {
            return $self;
        }

        # skip to the next possible position
        $self->{_fh}->seek(1,1);
    }
}

1;
