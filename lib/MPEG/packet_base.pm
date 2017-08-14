package MPEG::packet_base;
use warnings;
use strict;
#
# Base class for all the other packet types
#

sub new {
    my $class = shift;
    my $self = {};
    bless $self, $class;
    return $self;
}

sub offset {
    my $self = shift;
    my $val = shift;
    if (defined($val)) {
        if (defined($self->{offset})) {
            die("can only set offset once");
        }
        $self->{offset} = $val;
    }
    return $self->{offset};
}

sub length_variable {
    my $self = shift;
    my $val = shift;
    if (defined($val)) {
        $self->{length_variable} = $val;
    }
    return $self->{length_variable};
}

sub indent {
    my $self = shift;
    my $val = shift;
    if (defined($val) && $val>0) {
        $self->{indent} = $val;
    }
    return $self->{indent};
}

sub length {
    my $self = shift;
    my $length_fixed = $self->length_fixed();
    my $length_variable = $self->length_variable() || 0;
    return $length_fixed + $length_variable;
}

sub read {
    my $self = shift;
    my $stream = shift;

    $self->offset($stream->current_offset());

    my $buf = $stream->read_bytes($self->length_fixed());

    $self->{_data} = $buf;
    return $self;
}

sub to_string {
    my $self = shift;

    my $s = '';

    my $offset = $self->offset();
    if (defined($offset)) {
        $s .= sprintf("0x%08x",$offset);
    }

    $s .= sprintf("(0x%08x)",$self->length());
    $s .= " " x ($self->indent() || 1);
    $s .= ref($self);

    return $s;
}

# return the spaces to indent a new line for additional data
sub _extra_indent {
    my $self = shift;

    my $s;
    if (defined($self->offset())) {
        $s .= " "x10; # skip the offset field
    }
    $s .= " "x12; # skip the length field
    $s .= " " x $self->indent(); # indent as needed
    $s .= "|- "; # clearly mark the extra data
    return $s;
}

1;
