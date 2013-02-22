package Template::Caribou::Utils;
BEGIN {
  $Template::Caribou::Utils::AUTHORITY = 'cpan:YANICK';
}
{
  $Template::Caribou::Utils::VERSION = '0.2.0';
}

use strict;
use warnings;
no warnings qw/ uninitialized /;

use Carp;

use Moose;

BEGIN {
    *::RAW = *::STDOUT;
}


__PACKAGE__->meta->make_immutable;

package
    Template::Caribou::String;

use overload 
    '""' => sub { return ${$_[0] } };

sub new { my ( $class, $string ) = @_;  bless \$string, $class; }


package 
    Template::Caribou::Output;

use parent 'Tie::Handle';

sub TIEHANDLE { return bless \my $i, shift; }

sub escape {
    no warnings qw/ uninitialized/;
    @_ = map { 
        my $x = $_;
        $x =~ s/&/&amp;/g;
        $x =~ s/</&lt;/g;
        $x;
    } @_;

    return wantarray ? @_ : join '', @_;
}

sub PRINT { shift; print ::RAW escape( @_ ) } 

package
    Template::Caribou::OutputRaw;

use parent 'Tie::Handle';

sub TIEHANDLE { return bless \my $i, shift; }

sub PRINT { 
    shift;
    no warnings qw/ uninitialized /;
    $Template::Caribou::OUTPUT .= join '', @_, $\;
} 

1;

__END__

=pod

=head1 NAME

Template::Caribou::Utils

=head1 VERSION

version 0.2.0

=head1 AUTHOR

Yanick Champoux

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yanick Champoux.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
