package MPEG::MP4::packet_hdlr;
# 
use warnings;
use strict;

use MPEG::MP4::packet_base;
our @ISA = qw(MPEG::MP4::packet_base);

sub read {
    my $self = shift;
    my $stream = shift;

    $self->SUPER::read($stream);

    my $version = unpack('N',$self->{_data});
    if ($version != 0) {
        ...
        # 64bit timestamps
    }

    my @fields = qw(
        version zero0 handler_type reserved0 reserved1 reserved2 name
    );
    my @values = unpack("NNa4NNNZ*", $self->{_data});
    my %h = map { $fields[$_] => $values[$_] } (0..scalar(@fields)-1);

    $self->{val} = \%h;

    # FIXME - need to know the number of bytes consumed to determine if there
    # is extra data present

    return $self;
}

1;
