package MPEG::PES::packet_01bc;
# Program Stream Map
use warnings;
use strict;

use MPEG::PES::packet_base;
our @ISA = qw(MPEG::PES::packet_base);
sub sync_value { 0x1bc; }

# TODO - decode contents:
# current_next_indicator
# single_extension_stream_flag
# reserved
# program_stream_map_version
# reserved
# marker_bit
# program_stream_info_length
#       n * descriptor()
# elementary_stream_map_length
#       n * :
#               stream_type
#               elementary_stream_id
#               elementary_stream_info_length
#                       n * descriptor()
# CRC_32

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my @val = unpack('C*',$self->{val}{_data});

    die("bad marker") if ($val[1] & 1 != 1);

    my $h = {};
    my $i = 0;

    $h->{current_next_indicator}        = ($val[$i] & 0x80) != 0;
    $h->{single_extension_stream_flag}  = ($val[$i] & 0x40) != 0;
    # reserved 1 bit
    $h->{program_stream_map_version}    = ($val[$i] & 0x1f);
    $i++;

    # reserved 7 bit
    $i++;

    $h->{program_stream_info_length}    = $val[$i] <<8 | $val[$i+1];
    $i+=2;

    if ($h->{program_stream_info_length} > 0) {
        ...
    }

    $h->{elementary_stream_map_length}    = $val[$i] <<8 | $val[$i+1];
    $i+=2;

    my $max_map = $i+$h->{elementary_stream_map_length};
    while ($i < $max_map) {
        my $stream = {};
        $stream->{type} = $val[$i];
        $i++;
        $stream->{id} = $val[$i];
        $i++;
        $stream->{info_length} = $val[$i] <<8 | $val[$i+1];
        $i+=2;

        if ($stream->{info_length} >0) {
            printf("i = %x,  info_length = %x\n",$i, $stream->{info_length});
            ...
        }
        push @{$h->{stream_map}}, $stream;
    }

    # save the remaining packet data
    $self->{_psm_data} = substr($self->{val}{_data},$i);

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
