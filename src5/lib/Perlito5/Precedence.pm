
package Perlito5::Precedence;

# Perlito5::Precedence attributes:
#   get_token - code ref
#   reduce    - code ref
#   end_token - array ref
#   end_token_chars - array ref (index to end_token entries)

sub new { 
    my $class = shift;
    bless {@_}, $class
}

my $Operator = {};
my $Precedence = {};    # integer 0..100
my $Assoc = {};         # right, left, list

sub is_assoc_type {
    my $assoc_type = shift;
    my $op_name = shift;
    return $Assoc->{$assoc_type}{$op_name}
}

sub is_fixity_type {
    my $fixity_type = shift;
    my $op_name = shift;
    return $Operator->{$fixity_type}{$op_name}
}

sub is_term {
    my $token = shift;
    ($token->[0] eq 'term') || ($token->[0] eq 'postfix_or_term')
}

sub is_ident_middle {
    my $c = shift;
       ($c ge 'a' && $c le 'z')
    || ($c ge '0' && $c le '9')
    || ($c eq '_')
}

my @Parsed_op_chars = (2, 1);
my %Parsed_op = (
      # 1 char
        '?'  => sub { Perlito5::Expression->term_ternary($_[0], $_[1]) },
        '('  => sub { Perlito5::Expression->term_paren($_[0], $_[1]) },
        '['  => sub { Perlito5::Expression->term_square($_[0], $_[1]) },
        '{'  => sub { Perlito5::Expression->term_curly($_[0], $_[1]) },
      # 2 chars
        '->' => sub { Perlito5::Expression->term_arrow($_[0], $_[1]) },
);

my @Term_chars = (7, 6, 5, 4, 3, 2, 1);
my %Term = (
    # 1 char
        '$'  => sub { Perlito5::Expression->term_sigil($_[0], $_[1]) },
        '@'  => sub { Perlito5::Expression->term_sigil($_[0], $_[1]) },
        '%'  => sub { Perlito5::Expression->term_sigil($_[0], $_[1]) },
        '&'  => sub { Perlito5::Expression->term_sigil($_[0], $_[1]) },
        '*'  => sub { Perlito5::Expression->term_sigil($_[0], $_[1]) },

        '.'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '0'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '1'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '2'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '3'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '4'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '5'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '6'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '7'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '8'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },
        '9'  => sub { Perlito5::Expression->term_digit($_[0], $_[1]) },

        '#'     => sub { Perlito5::Expression->term_space($_[0], $_[1]) }, 
        chr(9)  => sub { Perlito5::Expression->term_space($_[0], $_[1]) }, 
        chr(10) => sub { Perlito5::Expression->term_space($_[0], $_[1]) },
        chr(12) => sub { Perlito5::Expression->term_space($_[0], $_[1]) },
        chr(13) => sub { Perlito5::Expression->term_space($_[0], $_[1]) },
        chr(32) => sub { Perlito5::Expression->term_space($_[0], $_[1]) },
    # 2 chars
        'my' => sub { Perlito5::Expression->term_declarator($_[0], $_[1]) },
        'no' => sub { Perlito5::Expression->term_use($_[0], $_[1]) },
        'do' => sub { Perlito5::Expression->term_do($_[0], $_[1]) },
    # 3 chars
        'our' => sub { Perlito5::Expression->term_declarator($_[0], $_[1]) },
        'sub' => sub { Perlito5::Expression->term_sub($_[0], $_[1]) },
        'use' => sub { Perlito5::Expression->term_use($_[0], $_[1]) },
        'map' => sub { Perlito5::Expression->term_map_or_sort($_[0], $_[1]) },
    # 4 chars
        'eval'  => sub { Perlito5::Expression->term_eval($_[0], $_[1]) },
        'sort'  => sub { Perlito5::Expression->term_map_or_sort($_[0], $_[1]) },
        'grep'  => sub { Perlito5::Expression->term_map_or_sort($_[0], $_[1]) },
    # 5 chars
        'state' => sub { Perlito5::Expression->term_declarator($_[0], $_[1]) },
        'local' => sub { Perlito5::Expression->term_declarator($_[0], $_[1]) },
    # 6 chars
        'return' => sub { Perlito5::Expression->term_return($_[0], $_[1]) },
    # 7 chars
        'package' => sub { Perlito5::Expression->term_package($_[0], $_[1]) },
);

sub add_term {
    my $name = shift;
    my $param = shift;

    # XXX this fails unless the length is registered in @Term_chars

    $Term{$name} = $param;
}

my $End_token;
my $End_token_chars;
my %Op;
my @Op_chars = (3,2,1);
sub op_parse {
    my $self = shift;
    my $str  = shift;
    my $pos  = shift;
    my $last_is_term = shift;

    for my $len ( @$End_token_chars ) {
        my $term = substr($str, $pos, $len);
        if (exists($End_token->{$term})) {
            my $c1 = substr($str, $pos + length($term) - 1, 1);
            my $c2 = substr($str, $pos + length($term), 1);
            if (!(is_ident_middle($c1) && is_ident_middle($c2) )) {
                # it looks like an end token, and it is not one of these cases:
                #   if_more
                return Perlito5::Match->new(
                    str     => $str,
                    from    => $pos,
                    to      => $pos,
                    bool    => 1,
                    capture => [ 'end', $term ]
                );
            }
        }
    }

    if ( !$last_is_term ) {
        for my $len ( @Term_chars ) {
            my $term = substr($str, $pos, $len);
            if (exists($Term{$term})) {
                my $m = $Term{$term}->($str, $pos);
                return $m if $m->{"bool"};
            }
        }
    }

    # check for operators that need special parsing
    for my $len ( @Parsed_op_chars ) {
        my $op = substr($str, $pos, $len);
        if (exists($Parsed_op{$op})) {
            my $m = $Parsed_op{$op}->($str, $pos);
            return $m if $m->{"bool"};
        }
    }

    for my $len ( @Op_chars ) {
        my $op = substr($str, $pos, $len);
        if (exists($Op{$op})) {
            my $c1 = substr($str, $pos + length($op) - 1, 1);
            my $c2 = substr($str, $pos + length($op), 1);
            if (!(is_ident_middle($c1) && ( is_ident_middle($c2) || $c2 eq '(' ))) {
                # it looks like an operator, and it is not one of these cases:
                #   and_more
                #   and(...)
                return Perlito5::Match->new(
                    str     => $str,
                    from    => $pos,
                    to      => $pos + $len,
                    bool    => 1,
                    capture => [ 'op', $op ]
                );
            }
        }
    }

    return Perlito5::Grammar::Bareword->term_bareword( $str, $pos );
}

sub add_op {
    my $fixity = shift;
    my $name = shift;
    my $precedence = shift;
    my $param = shift;

    if (!(defined($param))) {
        $param = {}
    }
    my $assoc = $param->{'assoc'} || 'left';
    $Operator->{$fixity}{$name} = 1;
    $Precedence->{$name}        = $precedence;
    $Assoc->{$assoc}{$name}     = 1;
    $Op{$name}                  = 1;
}


# - no space allowed before postfix ops
# - if there is both an infix and a postfix with the same name, then the infix requires space before
# - $a[] inside string interpolation
# - parentheses vs. Parcel (x) (x,)
# - pair vs. block, hash vs. closure
# - function call without parentheses
# - '|' in prefix position

# left        terms and list operators (leftward)
# left        ->
# nonassoc    ++ --
# right       **
# right       ! ~ \ and unary + and -
# left        =~ !~
# left        * / % x
# left        + - .
# left        << >>
# nonassoc    named unary operators
# nonassoc    < > <= >= lt gt le ge
# nonassoc    == != <=> eq ne cmp ~~
# left        &
# left        | ^
# left        &&
# left        || //
# nonassoc    ..  ...
# right       ?:
# right       = += -= *= etc.
# left        , =>
# nonassoc    list operators (rightward)
# right       not
# left        and
# left        or xor

my $prec = 100;
add_op( 'postfix', '.( )',               $prec, );
add_op( 'postfix', '.[ ]',               $prec, );
add_op( 'postfix', '.{ }',               $prec, );
add_op( 'postfix', '( )',                $prec, );
add_op( 'postfix', '[ ]',                $prec, );
add_op( 'postfix', 'funcall',            $prec, );
add_op( 'postfix', 'funcall_no_params',  $prec, );
add_op( 'postfix', 'methcall',           $prec, );
add_op( 'postfix', 'methcall_no_params', $prec, );
add_op( 'postfix', 'block',              $prec, );
add_op( 'postfix', 'hash',               $prec, );
add_op( 'prefix',   '$',   $prec );
add_op( 'prefix',   '$#',  $prec );
add_op( 'prefix',   '&',   $prec );
add_op( 'prefix',   '*',   $prec );
add_op( 'prefix',   '@',   $prec );
add_op( 'prefix',   '%',   $prec );

$prec = $prec - 1;
add_op( 'prefix',   '++',  $prec );
add_op( 'prefix',   '--',  $prec );
add_op( 'postfix',  '++',  $prec,);
add_op( 'postfix',  '--',  $prec,);

$prec = $prec - 1;
add_op( 'infix',    '**',  $prec, { assoc => 'right' } );

$prec = $prec - 1;
add_op( 'prefix',   '\\',  $prec );
add_op( 'prefix',   '+',   $prec );
add_op( 'prefix',   '-',   $prec );
add_op( 'prefix',   '~',   $prec );
add_op( 'prefix',   '!',   $prec );

$prec = $prec - 1;
add_op( 'infix',    '=~',  $prec );
add_op( 'infix',    '!~',  $prec );

$prec = $prec - 1;
add_op( 'infix',    '*',   $prec );
add_op( 'infix',    '/',   $prec );
add_op( 'infix',    '%',   $prec );
add_op( 'infix',    'x',   $prec );

$prec = $prec - 1;
add_op( 'infix',    '+',   $prec );
add_op( 'infix',    '-',   $prec );
add_op( 'infix',    '.',   $prec, { assoc => 'list' } );

$prec = $prec - 1;
add_op( 'infix',    '<<',  $prec );
add_op( 'infix',    '>>',  $prec );

# named unary operators - these are parsed by the "Grammar::Bareword" module

$prec = $prec - 1;
add_op( 'infix',    'lt',  $prec, { assoc => 'chain' } );
add_op( 'infix',    'le',  $prec, { assoc => 'chain' } );
add_op( 'infix',    'gt',  $prec, { assoc => 'chain' } );
add_op( 'infix',    'ge',  $prec, { assoc => 'chain' } );
add_op( 'infix',    '<=',  $prec, { assoc => 'chain' } );
add_op( 'infix',    '>=',  $prec, { assoc => 'chain' } );
add_op( 'infix',    '<',   $prec, { assoc => 'chain' } );
add_op( 'infix',    '>',   $prec, { assoc => 'chain' } );

$prec = $prec - 1;
add_op( 'infix',    '<=>', $prec );
add_op( 'infix',    'cmp', $prec );
add_op( 'infix',    '==',  $prec, { assoc => 'chain' } );
add_op( 'infix',    '!=',  $prec, { assoc => 'chain' } );
add_op( 'infix',    'ne',  $prec, { assoc => 'chain' } );
add_op( 'infix',    'eq',  $prec, { assoc => 'chain' } );

$prec = $prec - 1;
add_op( 'infix',    '&',   $prec, { assoc => 'list' } );
add_op( 'prefix',   '&',   $prec );

$prec = $prec - 1;
add_op( 'infix',    '|',   $prec, { assoc => 'list' } );
add_op( 'prefix',   '|',   $prec );
add_op( 'infix',    '^',   $prec );

$prec = $prec - 1;
add_op( 'infix',    '..',  $prec );
add_op( 'infix',    '...', $prec );
add_op( 'infix',    '~~',  $prec, { assoc => 'chain' } );

$prec = $prec - 1;
add_op( 'infix',    '&&',  $prec );

$prec = $prec - 1;
add_op( 'infix',    '||',  $prec );
add_op( 'infix',    '//',  $prec );

$prec = $prec - 1;
add_op( 'ternary',  '? :',  $prec, { assoc => 'right' } );

$prec = $prec - 1;
add_op( 'infix',    '=',   $prec, { assoc => 'right' } );
add_op( 'infix',    '**=', $prec, { assoc => 'right' } );
add_op( 'infix',    '+=',  $prec, { assoc => 'right' } );
add_op( 'infix',    '-=',  $prec, { assoc => 'right' } );
add_op( 'infix',    '*=',  $prec, { assoc => 'right' } );
add_op( 'infix',    '/=',  $prec, { assoc => 'right' } );
add_op( 'infix',    'x=',  $prec, { assoc => 'right' } );

add_op( 'infix',    '|=',  $prec, { assoc => 'right' } );
add_op( 'infix',    '&=',  $prec, { assoc => 'right' } );
add_op( 'infix',    '.=',  $prec, { assoc => 'right' } );

add_op( 'infix',    '<<=', $prec, { assoc => 'right' } );
add_op( 'infix',    '>>=', $prec, { assoc => 'right' } );
add_op( 'infix',    '%=',  $prec, { assoc => 'right' } );

add_op( 'infix',    '||=', $prec, { assoc => 'right' } );
add_op( 'infix',    '&&=', $prec, { assoc => 'right' } );
add_op( 'infix',    '^=',  $prec, { assoc => 'right' } );
add_op( 'infix',    '//=', $prec, { assoc => 'right' } );

$prec = $prec - 1;
add_op( 'infix',    '=>',  $prec );
$prec = $prec - 1;
add_op( 'list',     ',',   $prec, { assoc => 'list' } );

$prec = $prec - 1;
add_op( 'prefix',   'not', $prec );
$prec = $prec - 1;
add_op( 'infix',    'and', $prec );
$prec = $prec - 1;
add_op( 'infix',    'or',  $prec );
add_op( 'infix',    'xor', $prec );
$prec = $prec - 1;
add_op( 'infix',    '*start*', $prec );

sub precedence_parse {
    my $self = shift;

    my $get_token       = $self->{'get_token'};
    my $reduce          = $self->{'reduce'};
    my $last_end_token  = $End_token;
    my $last_end_token_chars = $End_token_chars;
    $End_token          = $self->{'end_token'};
    $End_token_chars    = $self->{'end_token_chars'};
    my $op_stack  = [];   # [category, name]
    my $num_stack = [];
    my $last      = ['op', '*start*'];
    my $token     = $get_token->();
    # say "# precedence get_token: (0) ", $token->perl;
    if ($token->[0] eq 'space') {
        $token = $get_token->()
    }
    while ((defined($token)) && ($token->[0] ne 'end')) {
        # say "# precedence      last: (1) ", $last->perl;
        # say "# precedence get_token: (1) ", $token->perl;
        if (($token->[1] eq ',') && ( ($last->[1] eq '*start*') || ($last->[1] eq ',') )) {
            # allow (,,,)
            push( @$num_stack, ['term', undef] );
        }
        if ($Operator->{'prefix'}{$token->[1]} && ( ($last->[1] eq '*start*') || !(is_term($last)) )) {
            $token->[0] = 'prefix';
            unshift( @$op_stack, $token);
        }
        elsif ( ($Operator->{'postfix'}){$token->[1]} && is_term($last) )
        {
            my $pr = $Precedence->{$token->[1]};
            while (scalar(@$op_stack) && ($pr <= $Precedence->{ ($op_stack->[0])[1] })) {
                $reduce->($op_stack, $num_stack);
            }
            if ($token->[0] ne 'postfix_or_term') {
                $token->[0] = 'postfix';
            }
            unshift( @$op_stack, $token);
        }
        elsif (($token->[1] eq 'block') && is_term($last)) {
            # a block in this position terminates the current expression
            # say "# there is a block after the expression: ", $token->perl;
            while (scalar(@$op_stack)) {
                $reduce->($op_stack, $num_stack);
            }
            push( @$num_stack, $token);  # save the block
            $End_token = $last_end_token;  # restore previous 'end token' context
            $End_token_chars = $last_end_token_chars;  # restore previous 'end token' context
            return $num_stack;
        }
        elsif (is_term($token)) {
            if (is_term($last)) {
                say "#      last:  ", Perlito5::Dumper::Dumper($last);
                say "#      token: ", Perlito5::Dumper::Dumper($token);
                die "Value tokens must be separated by an operator";
            }
            $token->[0] = 'term';
            push( @$num_stack, $token);
        }
        elsif ($Precedence->{$token->[1]}) {
            my $pr = $Precedence->{$token->[1]};
            if ($Assoc->{'right'}{$token->[1]}) {
                while (scalar(@$op_stack) && ( $pr < $Precedence->{ ($op_stack->[0])[1] } )) {
                    $reduce->($op_stack, $num_stack);
                }
            }
            else {
                while (scalar(@$op_stack) && ( $pr <= $Precedence->{ ($op_stack->[0])[1] } )) {
                    $reduce->($op_stack, $num_stack);
                }
            }
            if ($Operator->{'ternary'}{$token->[1]}) {
                $token->[0] = 'ternary';
            }
            else {
                $token->[0] = 'infix';
            }
            unshift( @$op_stack, $token);
        }
        else {
            die "Unknown token: '", $token->[1], "'";
        }
        $last = $token;
        $token = $get_token->();
        # say "# precedence get_token: (2) ", $token->perl;
        if ($token->[0] eq 'space') {
            $token = $get_token->();
        }
    }
    if (defined($token) && ($token->[0] ne 'end')) {
        die "Unexpected end token: ",$token;
    }
    while (scalar(@$op_stack)) {
        $reduce->($op_stack, $num_stack);
    }
    # say "# precedence return";
    $End_token = $last_end_token;  # restore previous 'end token' context
    $End_token_chars = $last_end_token_chars;  # restore previous 'end token' context
    return $num_stack;
}

1;

=begin

=head1 NAME

Perlito5::Precedence - precedence parser for Perlito

=head1 SYNOPSIS

    my $prec = Perlito5::Precedence->new(
        get_token => $get_token,
        reduce    => $reduce_to_ast,
        end_token => [ 
                {}, 
                { ']' => 1, ')' => 1, '}' => 1, ';' => 1 } 
            ],
        end_token_chars => [ 1 ],
    );
    my $res = $prec->precedence_parse;

=head1 DESCRIPTION

This module resolves the operator precedence in Perl 5 expressions.

=head1 AUTHORS

Flavio Soibelmann Glock <fglock@gmail.com>.
The Pugs Team E<lt>perl6-compiler@perl.orgE<gt>.

=head1 COPYRIGHT

Copyright 2010, 2011, 2012 by Flavio Soibelmann Glock and others.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=end

