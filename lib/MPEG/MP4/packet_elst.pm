package MPEG::MP4::packet_elst;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @fields = qw(
        version entry_count
        segment_duration media_time
        media_rate_integer media_rate_fraction
    );
    my @values = unpack("NNNNnn", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    if ($h{version} != 0) {
        ...
    }
    if ($h{entry_count} != 1) {
        ...
    }

    $self->{val} = \%h;

    if (length($self->{_data}) > 20) {
        $self->{_data_extra} = substr($self->{_data},20);
    }

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
