package MPEG::PES::packet_01bb;
# a system header
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);
sub sync_value { 0x1bb; }

# TODO - decode contents:
# marker_bits x3
# rate_bound
# audio_bound
# fixed_flag
# CSPS_flag
# system_audio_lock_flag
# system_video_lock_flag
# video_bound
# packet_rate_restriction_flag
# reserved
# while bit7==1
#       stream_id
#       optional
#              stream_id_extension
#       P-STD_buffer_bound_scale
#       P-STD_buffer_size_bound

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @val = unpack('C*',$self->{val}{_data});

    die("bad marker") if (($val[0] & 0x80) == 0);
    die("bad marker") if (($val[2] & 0x01) == 0);
    die("bad marker") if (($val[4] & 0x20) == 0);

    my $h = {};
    my $i = 0;

    $h->{rate_bound}                    = ($val[$i] & 0x7f) <<15 |
                                          ($val[$i+1]) <<7 |
                                          ($val[$i+2]) >>1;
    $i+=3;

    $h->{audio_bound}                   = ($val[$i]) >>2;
    $h->{fixed_flag}                    = ($val[$i] & 0x02) >>1;
    $h->{CSPS_flag}                     = ($val[$i] & 0x01);
    $i++;

    $h->{system_audio_lock_flag}        = ($val[$i] & 0x80) >>7;
    $h->{system_vidio_lock_flag}        = ($val[$i] & 0x40) >>6;
    $h->{video_bound}                   = ($val[$i] & 0x1f);
    $i++;

    $h->{packet_rate_restriction_flag}  = ($val[$i] & 0x80) >>7;
    $i++;

    while (($val[$i] & 0x80) == 0x80) {
        my $stream = {};
        $stream->{id} = $val[$i];
        $i++;
        if ($stream->{id} == 0xb7) {
            ...
        } else {
            die("bad magic") if ($val[$i] & 0xc0 != 0xc0);
            $stream->{P_STD_buffer_bound_scale} = ($val[$i] & 0x20) != 0;
            $stream->{P_STD_buffer_size_bound} = ($val[$i] & 0x1f) << 8 |
                                                 ($val[$i+1]);
            $i+=2;
        }
        push @{$h->{stream_id}}, $stream;
    }

    # save the remaining packet data
    $self->{_pss_data} = substr($self->{val}{_data},$i);

    $self->{val} = $h;

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
