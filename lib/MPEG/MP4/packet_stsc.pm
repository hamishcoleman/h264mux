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

1;
