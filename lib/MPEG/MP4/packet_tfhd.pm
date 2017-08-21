package MPEG::MP4::packet_tfhd;
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
        $default_sample_duration,
        $default_sample_size,
        $default_sample_flags,
    ) = unpack("C4NNN", $self->{_data});

    if ($version != 0) { ...  }

    # base-data-offset-present
    if ($flags2 & 1) { ...  }
    # sample-description-index-present
    if ($flags2 & 2) { ...  }

    # default-sample-duration-present
    if (!($flags2 & 8)) { ... }
    # default-sample-size-present
    if (!($flags2 & 0x10)) { ... }
    # default-sample-flags-present
    if (!($flags2 & 0x20)) { ... }

    my $h;
    $h->{version} = $version;
    $h->{flags}{default_base_is_moof} = ($flags0 & 0x02) != 0;
    $h->{flags}{duration_is_empty} = ($flags0 & 0x01) != 0;
    $h->{default_sample_duration} = $default_sample_duration;
    $h->{default_sample_size} = $default_sample_size;
    $h->{default_sample_flags} = $default_sample_flags;

    $self->{val} = $h;

    return $self;
}

1;
