package BufferedStream;
use warnings;
use strict;
#
# I want to read from a stream, allowing part of the read data to be "pushed
# back" into the stream - ready for a later read.
#
# Avoid any seeks, but allow some repositioning
#
# Scan forwards for the next occurance of a sync sequence
#
# Keep track of the current byte position (for those streams that are file
# backed)
#
# A simple implementation - not a fast one
#

use Carp::Always;

use IO::File;

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;

    $self->{current_offset} = 0;
    $self->{buffer} = '';
    $self->{read_pointer} = 0;

    return $self;
}

sub open_fh {
    my $self = shift;
    my $val = shift;
    if (!defined($val)) {
        return undef;
    }
    $self->{fh} = $val;
    return $self;
}

sub read {
    my $self = shift;
    my $read_size = $_[1];

    my $min_buf_size = 4096;

    if ($self->{read_pointer} + $read_size > length($self->{buffer})) {
        # reading old data and unfetched data - extend the buffer

        # first, ensure the buffer does not grow huge
        if (length($self->{buffer}) > $min_buf_size*2) {
            my $truncate = int(length($self->{buffer})/2);
            if ($self->{read_pointer} < $truncate) {
                $truncate = $self->{read_pointer};
            }

            substr($self->{buffer}, 0, $truncate, '');
            $self->{current_offset} += $truncate;
            $self->{read_pointer} -= $truncate;
        }
 
        my $count = $self->{fh}->read($self->{buffer}, $read_size, length($self->{buffer}));
    }

    if ($self->{read_pointer} + $read_size > length($self->{buffer})) {
        # there is still not enough available (might be eof)
        $read_size = length($self->{buffer}) - $self->{read_pointer};
    }

    if ($self->{read_pointer} == length($self->{buffer})) {
        # the reading position is beyond the current buffer
        $self->{current_offset} += length($self->{buffer});
        delete $self->{buffer};
        $self->{read_pointer} = 0;
    }

    if (!defined($self->{buffer})) {
        # buffer is empty, fill it

        # small reads are slow
        my $size = $read_size;
        if ($size < $min_buf_size) {
            $size = $min_buf_size;
        }

        my $count = $self->{fh}->read($self->{buffer}, $size);

        if ($count < 1) {
            # just return that then
            return $count;
        }

        $self->{read_pointer} = 0;
    }

    if (@_ > 2) {
        substr($_[0],$_[2]) = substr($self->{buffer}, $self->{read_pointer}, $read_size);
    } else {
        $_[0] = substr($self->{buffer}, $self->{read_pointer}, $read_size);
    }

    my $count = $read_size;
    $self->{read_pointer} += $count;

    return $count;
}

sub tell {
    my $self = shift;
    return $self->{current_offset} + $self->{read_pointer};
}

sub seek {
    my $self = shift;
    my $pos = shift;
    my $whence = shift;

    if ($whence != 1) {
        die("cannot do SEEK_SET or SEEK_END positioning");
    }

    if ($pos == 0) {
        # that works
        return 1;
    }

    my $want_offset = $self->tell() + $pos;
    if ($want_offset > $self->{current_offset} + length($self->{buffer})) {
        die("a seek too far (pos=$pos want=$want_offset)");
    }

    if ($want_offset < $self->{current_offset}) {
        warn("a seek too far back");
        # a sign that we need bigger buffers?
        ...
    }

    $self->{read_pointer} += $pos;
    return 1;
}

1;
