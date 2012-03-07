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
package Perlito5::AST::Apply;
((my  %op) = (('infix:<+=>' => 'infix:<+>'), ('infix:<-=>' => 'infix:<->'), ('infix:<*=>' => 'infix:<*>'), ('infix:</=>' => 'infix:</>'), ('infix:<||=>' => 'infix:<||>'), ('infix:<&&=>' => 'infix:<&&>'), ('infix:<|=>' => 'infix:<|>'), ('infix:<&=>' => 'infix:<&>'), ('infix:<//=>' => 'infix:<//>'), ('infix:<.=>' => 'list:<.>')));
sub Perlito5::AST::Apply::op_assign {
    ((my  $self) = $_[0]);
    ((my  $code) = $self->{'code'});
    if (ref($code)) {
        return (0)
    };
    if ((exists($op{$code}))) {
        return (Perlito5::AST::Apply->new(('code' => 'infix:<=>'), ('arguments' => [$self->{'arguments'}->[0], Perlito5::AST::Apply->new(('code' => $op{$code}), ('arguments' => $self->{'arguments'}))])))
    };
    return (0)
};
package Perlito5::AST::Do;
sub Perlito5::AST::Do::simplify {
    ((my  $self) = $_[0]);
    (my  $block);
    if (($self->{'block'}->isa('Perlito5::AST::Lit::Block'))) {
        ($block = $self->{'block'}->stmts())
    }
    else {
        ($block = [$self->{'block'}])
    };
    if (((scalar(@{$block}) == 1))) {
        ((my  $stmt) = $block->[0]);
        if ((($stmt->isa('Perlito5::AST::Apply') && ($stmt->code() eq 'circumfix:<( )>')))) {
            ((my  $args) = $stmt->arguments());
            return (Perlito5::AST::Do->new(('block' => $args->[0]))->simplify())
        };
        if (($stmt->isa('Perlito5::AST::Do'))) {
            return ($stmt->simplify())
        }
    };
    return (Perlito5::AST::Do->new(('block' => $block)))
};

1;
