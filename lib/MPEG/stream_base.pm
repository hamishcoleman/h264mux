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
        warn("read size mismatch");
        return undef;
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

    return undef if $self->{_fh}->eof();

    my $packet;
    my $type = $self->peek_type();
    if (!defined($type)) {
        return undef;
    }

    my $class;
    if (defined($type)) {
        $class = $self->packet_known_map()->{$type};
    }

    if (defined($class)) {
        $packet = $class->new();
    } else {
        $packet = $self->packet_unknown()->new();
    }

    $packet->indent($self->current_indent());
    $self->{packets}{$type} = $packet;
    my @packets = $packet->read($self);

    for my $entry (@packets) {
        &{$self->packet_cb()}($entry);
    }

    if (!defined($class)) {
        return undef;
    }

    return $packet;
}

# a very simple sync byte search
sub resync {
    my $self = shift;
    my $sync_value = $self->packet_sync_value();

    while(!$self->{_fh}->eof()) {
        my $type = $self->peek_type();
        if (defined($type)) {
            return $self;
        }

        # skip to the next possible position
        $self->{_fh}->seek(1,1);
    }
}

1;
