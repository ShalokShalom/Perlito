# Do not edit this file - Generated by Perlito5 8.0
use v5;
use utf8;
use strict;
use warnings;
no warnings ('redefine', 'once', 'void', 'uninitialized', 'misc', 'recursion');
use Perlito5::Perl5::Runtime;
our $MATCH = Perlito5::Match->new();
package main;
use v5;
package Perlito5::Match;
sub Perlito5::Match::new {
    ((my  $class) = shift());
    bless({@_}, $class)
};
sub Perlito5::Match::from {
    $_[0]->{'from'}
};
sub Perlito5::Match::to {
    $_[0]->{'to'}
};
sub Perlito5::Match::str {
    $_[0]->{'str'}
};
sub Perlito5::Match::bool {
    $_[0]->{'bool'}
};
sub Perlito5::Match::capture {
    $_[0]->{'capture'}
};
sub Perlito5::Match::flat {
    ((my  $self) = $_[0]);
    if (($self->{'bool'})) {
        if ((defined($self->{'capture'}))) {
            return ($self->{'capture'})
        };
        return (substr($self->{'str'}, $self->{'from'}, (($self->{'to'} - $self->{'from'}))))
    }
    else {
        return ('')
    }
};

1;
