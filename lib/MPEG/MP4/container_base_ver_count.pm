package MPEG::MP4::container_base_ver_count;
# 
use warnings;
use strict;

use MPEG::MP4::container_base;
our @ISA = qw(MPEG::MP4::container_base);

sub read_data_pre_container {
    my $self = shift;
    my $stream = shift;

    my $data = $stream->read_bytes(8);
    my $version = unpack('N',$data);
    if ($version != 0) {
        ...
        # 64bit timestamps
    }

    my @fields = qw(
        version entry_count
    );
    my @values = unpack("NN", $data);
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

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
