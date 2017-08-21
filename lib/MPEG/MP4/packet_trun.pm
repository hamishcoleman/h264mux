package MPEG::MP4::packet_trun;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my ($version, $flags0, $flags1, $flags2,
        $sample_count,
    ) = unpack('C4N',$self->{_data});
    my $data = substr($self->{_data},8);
    if ($version != 1) {
        ...
    }

    my $h;
    $h->{version} = $version;
    $h->{sample_count} = $sample_count;

    if ($flags2 & 1) {
        $h->{data_offset} = unpack('N',$data);
        $data = substr($data, 4);
    }

    if ($flags2 & 4) {
        # first-sample-flags-present
        ...
    }

    while ($sample_count--) {
        my $entry;

        if ($flags1 & 1) {
            # sample-duration-present
            ...
        }

        if ($flags1 & 2) {
            $entry->{sample_size} = unpack('N', $data);
            $data = substr($data, 4);
        }
        if ($flags1 & 4) {
            $entry->{sample_flags} = unpack('N', $data);
            $data = substr($data, 4);
        }
        if ($flags1 & 8) {
            $entry->{sample_composition_time_offset} = unpack('l>', $data);
            $data = substr($data, 4);
        }
        push @{$h->{samples}}, $entry;
    }

    $self->{val} = $h;

    return $self;
}

1;
