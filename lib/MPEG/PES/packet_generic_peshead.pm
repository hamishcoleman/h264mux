package MPEG::PES::packet_generic_peshead;
# A packet, that might contain the optional PES Header
use warnings;
use strict;

use MPEG::PES::packet_generic;
our @ISA = qw(MPEG::PES::packet_generic);

sub _pts_dts {
    my $match = shift;
    my @val = @_;

    my $magic = (($val[0] & 0xf0)>>4);
    die("bad magic") if ( $magic != $match );

    die("bad marker") if ( ($val[0] & 0x01) != 1);
    die("bad marker") if ( ($val[2] & 0x01) != 1);
    die("bad marker") if ( ($val[4] & 0x01) != 1);

    return
        (($val[0] >>1) & 0x7) << 30 |
        (($val[1])) << 22 |
        (($val[2] >>1) & 0x7f) << 15 |
        (($val[3])) << 7 |
        (($val[4] >>1) & 0x7f);
}

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @val = unpack('C*',$self->{val}{_data});

    my $h = {};
    $h->{PES_Header} = (($val[0] & 0xc0) >>6) == 0x2;

    my $i = 0;
    if ($h->{PES_Header}) {
        $h->{PES_scrambling_control}    = (($val[$i] & 0x30) >>4);
        $h->{PES_priority}              = (($val[$i] & 0x08) >>3);
        $h->{data_alignment_indicator}  = (($val[$i] & 0x04) >>2);
        $h->{copyright}                 = (($val[$i] & 0x02) >>1);
        $h->{original_or_copy}          = (($val[$i] & 0x01));
        $i++;
        $h->{PTS_DTS_flags}             = (($val[$i] & 0xc0) >>6);
        $h->{ESCR_flag}                 = (($val[$i] & 0x20) >>5);
        $h->{ES_rate_flag}              = (($val[$i] & 0x10) >>4);
        $h->{DSM_trick_mode_flag}       = (($val[$i] & 0x08) >>3);
        $h->{additional_copy_info_flag} = (($val[$i] & 0x04) >>2);
        $h->{PES_CRC_flag}              = (($val[$i] & 0x02) >>1);
        $h->{PES_extension_flag}        = (($val[$i] & 0x01));
        $i++;
        $h->{PES_header_data_length}    = $val[$i];
        $i++;

             if ($h->{PTS_DTS_flags} == 0) {
        } elsif ($h->{PTS_DTS_flags} == 2) {
            $h->{PTS} = _pts_dts(2,@val[$i..($i+4)]);
            $i+=5;
        } elsif ($h->{PTS_DTS_flags} == 3) {
            $h->{PTS} = _pts_dts(3,@val[$i..($i+4)]);
            $i+=5;
            $h->{DTS} = _pts_dts(1,@val[$i..($i+4)]);
            $i+=5;
        } else {
            ...
        }

        if ($h->{ESCR_flag}) {
            ...
        }

        if ($h->{ES_rate_flag}) {
            ...
        }

        if ($h->{DSM_trick_mode_flag}) {
            ...
        }

        if ($h->{additional_copy_info_flag}) {
            ...
        }

        if ($h->{PES_CRC_flag}) {
            ...
        }

        if ($h->{PES_extension_flag}) {
            $h->{PES_private_data_flag}         = (($val[$i] & 0x80) >>7);
            $h->{pack_header_field_flag}        = (($val[$i] & 0x40) >>6);
            $h->{program_packet_sequence_counter_flag} = (($val[$i] & 0x20)>>5);
            $h->{P_STD_buffer_flag}             = (($val[$i] & 0x10) >>4);
            $h->{PES_extension_flag_2}          = (($val[$i] & 0x01));
            $i++;

            if ($h->{PES_private_data_flag}) {
                ...
            }
            if ($h->{pack_header_field_flag}) {
                ...
            }
            if ($h->{program_packet_sequence_counter_flag}) {
                ...
            }
            if ($h->{P_STD_buffer_flag}) {
                die("bad magic") if (($val[$i] & 0xc0) != 0x40);
                $h->{P_STD_buffer_scale}        = (($val[$i] & 0x20) >>5);
                $h->{P_STD_buffer_size} =
                    (($val[$i] & 0x1f) <<5) |
                    $val[$i+1];
                $i+=2;
            }
            if ($h->{PES_extension_flag_2}) {
                ...
            }
        }
    }

    # save the remaining packet data
    $self->{_pes_data} = substr($self->{val}{_data},$i);

    $self->{val} = $h;

    return $self;
}

sub to_string {
    my $self = shift;

    my $s = $self->SUPER::to_string();
    if ($self->{val}{PES_Header}) {
        for my $key (sort(keys(%{$self->{val}}))) {
            my $val = $self->{val}{$key};
            $s .= "\n" . $self->_extra_indent();
            $s .= sprintf("%s = %s", $key, $val);
        }
    }
    return $s;
}

1;
