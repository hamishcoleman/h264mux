package MPEG::MP4::packet_stsc;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @values = unpack("NN/(NNN)", $self->{_data});
    my %h;

    $h{version} = shift @values;
    my @entries;
    while(@values) {
        my $entry;
        $entry->{first_chunk} = shift @values;
        $entry->{samples_per_chunk} = shift @values;
        $entry->{sample_description_index} = shift @values;
        push @entries, $entry;
    }
    $h{entries} = \@entries;

    if ($h{version} != 0) {
        ...
    }

    $self->{val} = \%h;

    # FIXME - if there is anything left in the stream, it is data_extra

    return $self;
}

sub to_string {
    my $self = shift;

    my $s = $self->SUPER::to_string();
    for my $key (sort(keys(%{$self->{val}}))) {
        my $val = $self->{val}{$key};
        $s .= "\n" . $self->_extra_indent();
        $s .= sprintf("%s = %s", $key, $val);
    }
    return $s;
}

1;
