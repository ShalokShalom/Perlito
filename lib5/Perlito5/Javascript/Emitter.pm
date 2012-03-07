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
use Perlito5::AST;
use Perlito5::Dumper;
package Perlito5::Javascript;
(do {
    sub Perlito5::Javascript::tab {
        ((my  $level) = shift());
join("", chr(9) x $level)
    };
    ((my  %safe_char) = ((' ' => 1), ('!' => 1), ('"' => 1), ('#' => 1), ('$' => 1), ('%' => 1), ('&' => 1), ('(' => 1), (')' => 1), ('*' => 1), ('+' => 1), (',' => 1), ('-' => 1), ('.' => 1), ('/' => 1), (':' => 1), (';' => 1), ('<' => 1), ('=' => 1), ('>' => 1), ('?' => 1), ('@' => 1), ('[' => 1), (']' => 1), ('^' => 1), ('_' => 1), ('`' => 1), ('{' => 1), ('|' => 1), ('}' => 1), ('~' => 1)));
    sub Perlito5::Javascript::escape_string {
        ((my  $s) = shift());
        (my  @out);
        ((my  $tmp) = '');
        if (($s eq '')) {
            return (chr(39) . chr(39))
        };
        for my $i ((0 .. (length($s) - 1))) {
            ((my  $c) = substr($s, $i, 1));
            if (((((((($c ge 'a') && ($c le 'z'))) || ((($c ge 'A') && ($c le 'Z')))) || ((($c ge '0') && ($c le '9')))) || exists($safe_char{$c})))) {
                ($tmp = ($tmp . $c))
            }
            else {
                if (($tmp ne '')) {
                    push(@out, (chr(39) . $tmp . chr(39)) )
                };
                push(@out, ('String.fromCharCode(' . ord($c) . ')') );
                ($tmp = '')
            }
        };
        if (($tmp ne '')) {
            push(@out, (chr(39) . $tmp . chr(39)) )
        };
        return (join(' + ', @out))
    };
    sub Perlito5::Javascript::to_str {
        ((my  $cond) = shift());
        if ((((($cond->isa('Perlito5::AST::Apply') && ($cond->code() eq 'circumfix:<( )>')) && $cond->{'arguments'}) && @{$cond->{'arguments'}}))) {
            return (to_str($cond->{'arguments'}->[0]))
        };
        if (((($cond->isa('Perlito5::AST::Val::Buf')) || (($cond->isa('Perlito5::AST::Apply') && (((($cond->code() eq 'substr') || ($cond->code() eq 'join')) || ($cond->code() eq 'list:<.>')))))))) {
            return ($cond->emit_javascript())
        }
        else {
            return (('string(' . $cond->emit_javascript() . ')'))
        }
    };
    sub Perlito5::Javascript::to_num {
        ((my  $cond) = shift());
        if ((($cond->isa('Perlito5::AST::Val::Int') || $cond->isa('Perlito5::AST::Val::Num')))) {
            return ($cond->emit_javascript())
        }
        else {
            return (('num(' . $cond->emit_javascript() . ')'))
        }
    };
    sub Perlito5::Javascript::to_bool {
        ((my  $cond) = shift());
        if ((((($cond->isa('Perlito5::AST::Apply') && ($cond->code() eq 'circumfix:<( )>')) && $cond->{'arguments'}) && @{$cond->{'arguments'}}))) {
            return (to_bool($cond->{'arguments'}->[0]))
        };
        if ((($cond->isa('Perlito5::AST::Apply') && ((($cond->code() eq 'infix:<&&>') || ($cond->code() eq 'infix:<and>')))))) {
            return (('(' . to_bool($cond->{'arguments'}->[0]) . ' && ' . to_bool($cond->{'arguments'}->[1]) . ')'))
        };
        if ((($cond->isa('Perlito5::AST::Apply') && ((($cond->code() eq 'infix:<||>') || ($cond->code() eq 'infix:<or>')))))) {
            return (('(' . to_bool($cond->{'arguments'}->[0]) . ' || ' . to_bool($cond->{'arguments'}->[1]) . ')'))
        };
        if ((((($cond->isa('Perlito5::AST::Val::Int')) || ($cond->isa('Perlito5::AST::Val::Num'))) || (($cond->isa('Perlito5::AST::Apply') && (((((((((((($cond->code() eq 'prefix:<!>') || ($cond->code() eq 'infix:<!=>')) || ($cond->code() eq 'infix:<==>')) || ($cond->code() eq 'infix:<<=>')) || ($cond->code() eq 'infix:<>=>')) || ($cond->code() eq 'infix:<>>')) || ($cond->code() eq 'infix:<<>')) || ($cond->code() eq 'infix:<eq>')) || ($cond->code() eq 'infix:<ne>')) || ($cond->code() eq 'infix:<ge>')) || ($cond->code() eq 'infix:<le>')))))))) {
            return ($cond->emit_javascript())
        }
        else {
            return (('bool(' . $cond->emit_javascript() . ')'))
        }
    };
    sub Perlito5::Javascript::to_list {
        ((my  $items) = to_list_preprocess($_[0]));
        (@{$items} ? ('interpolate_array(' . join(', ', map($_->emit_javascript(), @{$items})) . ')') : '[]')
    };
    sub Perlito5::Javascript::to_list_preprocess {
        (my  @items);
        for my $item (@{$_[0]}) {
            if ((($item->isa('Perlito5::AST::Apply') && (((($item->code() eq 'circumfix:<( )>') || ($item->code() eq 'list:<,>')) || ($item->code() eq 'infix:<=>>')))))) {
                for my $arg (@{to_list_preprocess($item->arguments())}) {
                    push(@items, $arg )
                }
            }
            else {
                push(@items, $item )
            }
        };
        return (\@items)
    }
});
package Perlito5::Javascript::LexicalBlock;
(do {
    sub Perlito5::Javascript::LexicalBlock::new {
        ((my  $class) = shift());
        bless({@_}, $class)
    };
    sub Perlito5::Javascript::LexicalBlock::block {
        $_[0]->{'block'}
    };
    sub Perlito5::Javascript::LexicalBlock::needs_return {
        $_[0]->{'needs_return'}
    };
    sub Perlito5::Javascript::LexicalBlock::top_level {
        $_[0]->{'top_level'}
    };
    sub Perlito5::Javascript::LexicalBlock::has_decl {
        ((my  $self) = $_[0]);
        ((my  $type) = $_[1]);
        for my $decl (@{$self->{'block'}}) {
            if ((defined($decl))) {
                if ((($decl->isa('Perlito5::AST::Decl') && ($decl->decl() eq $type)))) {
                    return (1)
                };
                if ((($decl->isa('Perlito5::AST::Apply') && ($decl->code() eq 'infix:<=>')))) {
                    ((my  $var) = $decl->arguments()->[0]);
                    if ((($var->isa('Perlito5::AST::Decl') && ($var->decl() eq $type)))) {
                        return (1)
                    }
                }
            }
        };
        return (0)
    };
    sub Perlito5::Javascript::LexicalBlock::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::Javascript::LexicalBlock::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        (my  @block);
        for ((@{$self->{'block'}})) {
            if ((defined($_))) {
                push(@block, $_ )
            }
        };
        if ((!(@block))) {
            return ((Perlito5::Javascript::tab($level) . 'null;'))
        };
        ((my  $out) = '');
        (my  @str);
        ((my  $has_local) = $self->has_decl('local'));
        ((my  $create_context) = ($self->{'create_context'} && $self->has_decl('my')));
        ((my  $outer_pkg) = $Perlito5::PKG_NAME);
        ((my  $outer_throw) = $Perlito5::THROW);
        unshift(@{$Perlito5::VAR}, {});
        if ($self->{'top_level'}) {
            ($Perlito5::THROW = 0)
        };
        if ($has_local) {
            ($out = ($out . (Perlito5::Javascript::tab($level) . 'var local_idx = LOCAL.length;' . chr(10))))
        };
        if (($self->{'top_level'})) {
            ($level)++
        };
        if (($create_context)) {
            ($out = ($out . (Perlito5::Javascript::tab($level) . '(function () {' . chr(10))));
            ($level)++
        };
        ((my  $tab) = Perlito5::Javascript::tab($level));
        (my  $last_statement);
        if (($self->{'needs_return'})) {
            ($last_statement = pop(@block))
        };
        for my $decl (@block) {
            if ((((ref($decl) eq 'Perlito5::AST::Apply') && ($decl->code() eq 'package')))) {
                ($Perlito5::PKG_NAME = $decl->{'namespace'})
            };
            if (($decl->isa('Perlito5::AST::Decl'))) {
                push(@str, $decl->emit_javascript_init() )
            };
            if ((($decl->isa('Perlito5::AST::Apply') && ($decl->code() eq 'infix:<=>')))) {
                if (($decl->{'arguments'}->[0]->isa('Perlito5::AST::Decl'))) {
                    push(@str, $decl->{'arguments'}->[0]->emit_javascript_init() )
                }
            };
            if ((!((($decl->isa('Perlito5::AST::Decl') && ($decl->decl() eq 'my')))))) {
                push(@str, ($decl->emit_javascript_indented($level) . ';') )
            }
        };
        if ((($self->{'needs_return'} && $last_statement))) {
            if (($last_statement->isa('Perlito5::AST::Decl'))) {
                push(@str, $last_statement->emit_javascript_init() )
            };
            if ((($last_statement->isa('Perlito5::AST::Apply') && ($last_statement->code() eq 'infix:<=>')))) {
                if (($last_statement->{'arguments'}->[0]->isa('Perlito5::AST::Decl'))) {
                    push(@str, $last_statement->{'arguments'}->[0]->emit_javascript_init() )
                }
            };
            if (($last_statement->isa('Perlito5::AST::If'))) {
                ((my  $cond) = $last_statement->cond());
                ((my  $body) = $last_statement->body());
                ((my  $otherwise) = $last_statement->otherwise());
                ($body = Perlito5::Javascript::LexicalBlock->new(('block' => $body->stmts()), ('needs_return' => 1)));
                push(@str, ('if ( ' . Perlito5::Javascript::to_bool($cond) . ' ) {' . chr(10) . $body->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '}') );
                if (($otherwise)) {
                    ($otherwise = Perlito5::Javascript::LexicalBlock->new(('block' => $otherwise->stmts()), ('needs_return' => 1)));
                    push(@str, (chr(10) . Perlito5::Javascript::tab($level) . 'else {' . chr(10) . $otherwise->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '}') )
                }
            }
            else {
                if ((((($last_statement->isa('Perlito5::AST::For') || $last_statement->isa('Perlito5::AST::While')) || ($last_statement->isa('Perlito5::AST::Apply') && ($last_statement->code() eq 'goto'))) || ($last_statement->isa('Perlito5::AST::Apply') && ($last_statement->code() eq 'return'))))) {
                    push(@str, $last_statement->emit_javascript_indented($level) )
                }
                else {
                    if (($has_local)) {
                        push(@str, ('return cleanup_local(local_idx, (' . $last_statement->emit_javascript_indented(($level + 1)) . '));') )
                    }
                    else {
                        push(@str, ('return (' . $last_statement->emit_javascript_indented(($level + 1)) . ');') )
                    }
                }
            }
        };
        if (($has_local)) {
            push(@str, 'cleanup_local(local_idx, null);' )
        };
        if (($create_context)) {
            ($level)--;
            push(@str, '})();' )
        };
        if ((($self->{'top_level'} && $Perlito5::THROW))) {
            ($level)--;
            ($out = ($out . (Perlito5::Javascript::tab($level) . 'try {' . chr(10) . join(chr(10), map(($tab . $_), @str)) . chr(10) . Perlito5::Javascript::tab($level) . '}' . chr(10) . Perlito5::Javascript::tab($level) . 'catch(err) {' . chr(10) . Perlito5::Javascript::tab(($level + 1)) . 'if ( err instanceof Error ) {' . chr(10) . Perlito5::Javascript::tab(($level + 2)) . 'throw(err);' . chr(10) . Perlito5::Javascript::tab(($level + 1)) . '}' . chr(10) . Perlito5::Javascript::tab(($level + 1)) . 'else {' . chr(10) . Perlito5::Javascript::tab(($level + 2)) . (($has_local ? 'return cleanup_local(local_idx, err)' : 'return(err)')) . ';' . chr(10) . Perlito5::Javascript::tab(($level + 1)) . '}' . chr(10) . Perlito5::Javascript::tab($level) . '}')))
        }
        else {
            ($out = ($out . join(chr(10), map(($tab . $_), @str))))
        };
        ($Perlito5::PKG_NAME = $outer_pkg);
        if ($self->{'top_level'}) {
            ($Perlito5::THROW = $outer_throw)
        };
        shift(@{$Perlito5::VAR});
        return ($out)
    }
});
package Perlito5::AST::CompUnit;
(do {
    sub Perlito5::AST::CompUnit::emit_javascript {
        ((my  $self) = $_[0]);
        $self->emit_javascript_indented(0)
    };
    sub Perlito5::AST::CompUnit::emit_javascript_indented {
        ((my  $self) = $_[0]);
        ((my  $level) = $_[1]);
        ((my  $str) = ('(function () {' . chr(10) . Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'body'}), ('needs_return' => 0))->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '})()' . chr(10)));
        return ($str)
    };
    sub Perlito5::AST::CompUnit::emit_javascript_program {
        ((my  $comp_units) = shift());
        ((my  $str) = '');
        ($Perlito5::VAR = [{('@_' => {('decl' => 'my')}), ('$_' => {('decl' => 'my')}), ('@ARGV' => {('decl' => 'my')})}]);
        ($Perlito5::PKG_NAME = 'main');
        for my $comp_unit (@{$comp_units}) {
            ($str = ($str . $comp_unit->emit_javascript() . chr(10)))
        };
        return ($str)
    }
});
package Perlito5::AST::Val::Int;
(do {
    sub Perlito5::AST::Val::Int::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Val::Int::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        $self->{'int'}
    }
});
package Perlito5::AST::Val::Num;
(do {
    sub Perlito5::AST::Val::Num::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Val::Num::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        $self->{'num'}
    }
});
package Perlito5::AST::Val::Buf;
(do {
    sub Perlito5::AST::Val::Buf::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Val::Buf::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        Perlito5::Javascript::escape_string($self->{'buf'})
    }
});
package Perlito5::AST::Lit::Block;
(do {
    sub Perlito5::AST::Lit::Block::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Lit::Block::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $sig) = 'v__');
        if (($self->{'sig'})) {
            ($sig = $self->{'sig'}->emit_javascript_indented(($level + 1)))
        };
        return ((Perlito5::Javascript::tab($level) . ('(function (' . $sig . ') {' . chr(10)) . (Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'stmts'}), ('needs_return' => 1)))->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '})'))
    }
});
package Perlito5::AST::Index;
(do {
    sub Perlito5::AST::Index::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Index::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        if ((($self->{'obj'}->isa('Perlito5::AST::Var') && ($self->{'obj'}->sigil() eq '$')))) {
            ((my  $v) = Perlito5::AST::Var->new(('sigil' => '@'), ('namespace' => $self->{'obj'}->namespace()), ('name' => $self->{'obj'}->name())));
            return (($v->emit_javascript_indented($level) . '[' . $self->{'index_exp'}->emit_javascript() . ']'))
        };
        ('(' . $self->{'obj'}->emit_javascript() . ' || (' . $self->{'obj'}->emit_javascript() . ' = new ArrayRef([]))' . ')._array_[' . $self->{'index_exp'}->emit_javascript() . ']')
    }
});
package Perlito5::AST::Lookup;
(do {
    sub Perlito5::AST::Lookup::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Lookup::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        if ((($self->{'obj'}->isa('Perlito5::AST::Var') && ($self->{'obj'}->sigil() eq '$')))) {
            ((my  $v) = Perlito5::AST::Var->new(('sigil' => '%'), ('namespace' => $self->{'obj'}->namespace()), ('name' => $self->{'obj'}->name())));
            return (($v->emit_javascript_indented($level) . '[' . $self->{'index_exp'}->emit_javascript() . ']'))
        };
        ('(' . $self->{'obj'}->emit_javascript() . ' || (' . $self->{'obj'}->emit_javascript() . ' = new HashRef({}))' . ')._hash_[' . $self->{'index_exp'}->emit_javascript() . ']')
    }
});
package Perlito5::AST::Var;
(do {
    ((my  $table) = {('$' => 'v_'), ('@' => 'List_'), ('%' => 'Hash_'), ('&' => '')});
    sub Perlito5::AST::Var::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Var::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $perl5_name) = $self->perl5_name());
        (my  $decl_type);
        ((my  $decl) = $self->perl5_get_decl($perl5_name));
        if (($decl)) {
            ($decl_type = $decl->{'decl'})
        }
        else {
            if (($self->{'namespace'} || ($self->{'sigil'} eq '*'))) {

            }
            else {
                die(('Global symbol "' . $perl5_name . '" requires explicit package name'))
            }
        };
        if ((($self->{'sigil'} eq '*'))) {
            return (('NAMESPACE["' . (($self->{'namespace'} || $Perlito5::PKG_NAME)) . '"]["' . $self->{'name'} . '"]'))
        };
        if ((($decl_type eq 'our'))) {
            return (('NAMESPACE["' . (($self->{'namespace'} || $decl->{'namespace'})) . '"]["' . $table->{$self->{'sigil'}} . $self->{'name'} . '"]'))
        };
        ((my  $ns) = '');
        if (($self->{'namespace'})) {
            ($ns = ('NAMESPACE["' . $self->{'namespace'} . '"].'))
        };
        ($ns . $table->{$self->{'sigil'}} . $self->{'name'})
    };
    sub Perlito5::AST::Var::perl5_name {
        ((my  $self) = shift());
        ($self->{'sigil'} . (($self->{'namespace'} ? ($self->{'namespace'} . '::') : '')) . $self->{'name'})
    };
    sub Perlito5::AST::Var::perl5_get_decl {
        ((my  $self) = shift());
        ((my  $perl5_name) = shift());
        for ((@{$Perlito5::VAR})) {
            if (exists($_->{$perl5_name})) {
                return ($_->{$perl5_name})
            }
        };
        return (undef())
    }
});
package Perlito5::AST::Decl;
(do {
    sub Perlito5::AST::Decl::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Decl::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        if ((($self->{'decl'} eq 'local'))) {
            ((my  $perl5_name) = $self->{'var'}->perl5_name());
            ((my  $decl_namespace) = '');
            ((my  $decl) = $self->{'var'}->perl5_get_decl($perl5_name));
            if ((($decl && ((($decl->{'decl'} eq 'our') || ($decl->{'decl'} eq 'local')))))) {
                ($decl_namespace = $decl->{'namespace'})
            };
            ((my  $ns) = ('NAMESPACE["' . ((($self->{'var'}->{'namespace'} || $decl_namespace) || $Perlito5::PKG_NAME)) . '"]'));
            return (('set_local(' . $ns . ',' . Perlito5::Javascript::escape_string($self->{'var'}->{'name'}) . ',' . Perlito5::Javascript::escape_string($self->{'var'}->{'sigil'}) . '); ' . $self->{'var'}->emit_javascript_indented($level)))
        };
        $self->{'var'}->emit_javascript_indented($level)
    };
    sub Perlito5::AST::Decl::emit_javascript_init {
        ((my  $self) = shift());
        ((my  $env) = {('decl' => $self->{'decl'})});
        ((my  $perl5_name) = $self->{'var'}->perl5_name());
        if ((($self->{'decl'} ne 'my'))) {
            if ((($self->{'decl'} eq 'our') && $self->{'var'}->{'namespace'})) {
                die(('No package name allowed for variable ' . $perl5_name . ' in "our"'))
            };
            if ((($self->{'var'}->{'namespace'} eq ''))) {
                ((my  $decl_namespace) = '');
                ((my  $decl) = $self->{'var'}->perl5_get_decl($perl5_name));
                if ((((($self->{'decl'} eq 'local') && $decl) && ((($decl->{'decl'} eq 'our') || ($decl->{'decl'} eq 'local')))))) {
                    ($decl_namespace = $decl->{'namespace'})
                };
                ($env->{'namespace'} = ($decl_namespace || $Perlito5::PKG_NAME))
            }
        };
        ($Perlito5::VAR->[0]->{$perl5_name} = $env);
        if ((($self->{'decl'} eq 'my'))) {
            ((my  $str) = '');
            ($str = ($str . 'var ' . $self->{'var'}->emit_javascript() . ' = '));
            if ((($self->{'var'})->sigil() eq '%')) {
                ($str = ($str . '{};'))
            }
            else {
                if ((($self->{'var'})->sigil() eq '@')) {
                    ($str = ($str . '[];'))
                }
                else {
                    ($str = ($str . 'null;'))
                }
            };
            return ($str)
        }
        else {
            if ((($self->{'decl'} eq 'our'))) {
                return (('// our ' . $self->{'var'}->emit_javascript()))
            }
            else {
                if ((($self->{'decl'} eq 'local'))) {
                    return (('// local ' . $self->{'var'}->emit_javascript()))
                }
                else {
                    if ((($self->{'decl'} eq 'state'))) {
                        return (('// state ' . $self->{'var'}->emit_javascript()))
                    }
                    else {
                        die(('not implemented: Perlito5::AST::Decl ' . chr(39) . $self->{'decl'} . chr(39)))
                    }
                }
            }
        }
    }
});
package Perlito5::AST::Proto;
(do {
    sub Perlito5::AST::Proto::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Proto::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ('CLASS["' . $self->{'name'} . '"]')
    }
});
package Perlito5::AST::Call;
(do {
    sub Perlito5::AST::Call::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Call::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $invocant) = $self->{'invocant'}->emit_javascript());
        ((my  $meth) = $self->{'method'});
        if ((($meth eq 'postcircumfix:<[ ]>'))) {
            return (('(' . $invocant . ' || (' . $invocant . ' = new ArrayRef([]))' . ')._array_[' . $self->{'arguments'}->emit_javascript() . ']'))
        };
        if ((($meth eq 'postcircumfix:<{ }>'))) {
            return (('(' . $invocant . ' || (' . $invocant . ' = new HashRef({}))' . ')._hash_[' . $self->{'arguments'}->emit_javascript() . ']'))
        };
        if ((($meth eq 'postcircumfix:<( )>'))) {
            ((my  @args) = ());
            for (@{$self->{'arguments'}}) {
                push(@args, $_->emit_javascript() )
            };
            return (('(' . $invocant . ')([' . join(',', @args) . '])'))
        };
        ((my  @args) = ($invocant));
        for (@{$self->{'arguments'}}) {
            push(@args, $_->emit_javascript() )
        };
        return (($invocant . '._class_.' . $meth . '([' . join(',', @args) . '])'))
    }
});
package Perlito5::AST::Apply;
(do {
    ((my  %op_infix_js) = (('infix:<eq>' => ' == '), ('infix:<ne>' => ' != '), ('infix:<le>' => ' <= '), ('infix:<ge>' => ' >= ')));
    ((my  %op_infix_js_num) = (('infix:<==>' => ' == '), ('infix:<!=>' => ' != '), ('infix:<->' => ' - '), ('infix:<*>' => ' * '), ('infix:</>' => ' / '), ('infix:<>>' => ' > '), ('infix:<<>' => ' < '), ('infix:<>=>' => ' >= '), ('infix:<<=>' => ' <= ')));
    sub Perlito5::AST::Apply::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Apply::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $apply) = $self->op_assign());
        if (($apply)) {
            return ($apply->emit_javascript_indented($level))
        };
        ((my  $code) = $self->{'code'});
        if ((ref(($code ne '')))) {
            ((my  @args) = ());
            for (@{$self->{'arguments'}}) {
                push(@args, $_->emit_javascript() )
            };
            return (('(' . $self->{'code'}->emit_javascript_indented($level) . ')(' . join(',', @args) . ')'))
        };
        if ((($code eq 'package'))) {
            return (('make_package("' . $self->{'namespace'} . '")'))
        };
        if ((($code eq 'infix:<=>>'))) {
            return (join(', ', map($_->emit_javascript_indented($level), @{$self->{'arguments'}})))
        };
        if ((exists($op_infix_js{$code}))) {
            return (('(' . join($op_infix_js{$code}, map($_->emit_javascript_indented($level), @{$self->{'arguments'}})) . ')'))
        };
        if ((exists($op_infix_js_num{$code}))) {
            return (('(' . join($op_infix_js_num{$code}, map(Perlito5::Javascript::to_num($_), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'eval'))) {
            ((my  $var_env_perl5) = Perlito5::Dumper::Dumper($Perlito5::VAR));
            ((my  $m) = Perlito5::Expression->term_square($var_env_perl5, 0));
            ($m = Perlito5::Expression::expand_list($m->flat()->[2]));
            ((my  $var_env_js) = ('(new ArrayRef(' . Perlito5::Javascript::to_list($m) . '))'));
            return (('eval(perl5_to_js(' . Perlito5::Javascript::to_str($self->{'arguments'}->[0]) . ', ' . '"' . $Perlito5::PKG_NAME . '", ' . $var_env_js . '))'))
        };
        if ((($code eq 'undef'))) {
            if ((($self->{'arguments'} && @{$self->{'arguments'}}))) {
                return (('(' . $self->{'arguments'}->[0]->emit_javascript() . ' = null)'))
            };
            return ('null')
        };
        if ((($code eq 'defined'))) {
            return (('(' . join(' ', map($_->emit_javascript_indented($level), @{$self->{'arguments'}})) . ' != null)'))
        };
        if ((($code eq 'shift'))) {
            if ((($self->{'arguments'} && @{$self->{'arguments'}}))) {
                return (('NAMESPACE["' . $Perlito5::PKG_NAME . '"].shift([' . join(', ', map($_->emit_javascript_indented($level), @{$self->{'arguments'}})) . '])'))
            };
            return (('NAMESPACE["' . $Perlito5::PKG_NAME . '"].shift([List__])'))
        };
        if ((($code eq 'map'))) {
            ((my  $fun) = $self->{'arguments'}->[0]);
            ((my  $list) = $self->{'arguments'}->[1]);
            return (('(function (a_) { ' . 'var out = []; ' . 'if ( a_ == null ) { return out; }; ' . 'for(var i = 0; i < a_.length; i++) { ' . 'var v__ = a_[i]; ' . 'out.push(' . $fun->emit_javascript_indented($level) . ')' . '}; ' . 'return out;' . ' })(' . $list->emit_javascript() . ')'))
        };
        if ((($code eq 'prefix:<!>'))) {
            return (('!( ' . Perlito5::Javascript::to_bool($self->{'arguments'}->[0]) . ')'))
        };
        if ((($code eq 'prefix:<$>'))) {
            ((my  $arg) = $self->{'arguments'}->[0]);
            return (('(' . $arg->emit_javascript() . ')._scalar_'))
        };
        if ((($code eq 'prefix:<@>'))) {
            ((my  $arg) = $self->{'arguments'}->[0]);
            return (('(' . $arg->emit_javascript_indented($level) . ' || (' . $arg->emit_javascript_indented($level) . ' = new ArrayRef([]))' . ')._array_'))
        };
        if ((($code eq 'prefix:<%>'))) {
            ((my  $arg) = $self->{'arguments'}->[0]);
            return (('(' . $arg->emit_javascript_indented($level) . ')._hash_'))
        };
        if ((($code eq 'circumfix:<[ ]>'))) {
            return (('(new ArrayRef(' . Perlito5::Javascript::to_list($self->{'arguments'}) . '))'))
        };
        if ((($code eq 'circumfix:<{ }>'))) {
            return (('(new HashRef(array_to_hash(' . Perlito5::Javascript::to_list($self->{'arguments'}) . ')))'))
        };
        if ((($code eq 'prefix:<' . chr(92) . '>'))) {
            ((my  $arg) = $self->{'arguments'}->[0]);
            if (($arg->isa('Perlito5::AST::Var'))) {
                if ((($arg->sigil() eq '@'))) {
                    return (('(new ArrayRef(' . $arg->emit_javascript_indented($level) . '))'))
                };
                if ((($arg->sigil() eq '%'))) {
                    return (('(new HashRef(' . $arg->emit_javascript_indented($level) . '))'))
                };
                if ((($arg->sigil() eq '&'))) {
                    if (($arg->{'namespace'})) {
                        return (('NAMESPACE["' . $arg->{'namespace'} . '"].' . $arg->{'name'}))
                    }
                    else {
                        return (('NAMESPACE["' . $Perlito5::PKG_NAME . '"].' . $arg->{'name'}))
                    }
                }
            };
            return (('(new ScalarRef(' . $arg->emit_javascript_indented($level) . '))'))
        };
        if ((($code eq 'postfix:<++>'))) {
            return (('(' . join(' ', map($_->emit_javascript(), @{$self->{'arguments'}})) . ')++'))
        };
        if ((($code eq 'postfix:<-->'))) {
            return (('(' . join(' ', map($_->emit_javascript(), @{$self->{'arguments'}})) . ')--'))
        };
        if ((($code eq 'prefix:<++>'))) {
            return (('++(' . join(' ', map($_->emit_javascript(), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'prefix:<-->'))) {
            return (('--(' . join(' ', map($_->emit_javascript(), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'infix:<x>'))) {
            return (('str_replicate(' . join(', ', map($_->emit_javascript(), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'list:<.>'))) {
            return (('(' . join(' + ', map(Perlito5::Javascript::to_str($_), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'infix:<+>'))) {
            return (('add' . '(' . join(', ', map($_->emit_javascript(), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'prefix:<+>'))) {
            return (('(' . $self->{'arguments'}->[0]->emit_javascript() . ')'))
        };
        if ((($code eq 'infix:<..>'))) {
            return (('(function (a) { ' . 'for (var i=' . $self->{'arguments'}->[0]->emit_javascript() . ', l=' . $self->{'arguments'}->[1]->emit_javascript() . '; ' . 'i<=l; ++i)' . '{ ' . 'a.push(i) ' . '}; ' . 'return a ' . '})([])'))
        };
        if ((($code eq 'infix:<&&>') || ($code eq 'infix:<and>'))) {
            return (('and' . '(' . $self->{'arguments'}->[0]->emit_javascript() . ', ' . 'function () { return ' . $self->{'arguments'}->[1]->emit_javascript() . '; })'))
        };
        if ((($code eq 'infix:<||>') || ($code eq 'infix:<or>'))) {
            return (('or' . '(' . $self->{'arguments'}->[0]->emit_javascript() . ', ' . 'function () { return ' . $self->{'arguments'}->[1]->emit_javascript() . '; })'))
        };
        if ((($code eq 'infix:<//>'))) {
            return ((('defined_or') . '(' . $self->{'arguments'}->[0]->emit_javascript() . ', ' . 'function () { return ' . $self->{'arguments'}->[1]->emit_javascript() . '; })'))
        };
        if ((($code eq 'exists'))) {
            ((my  $arg) = $self->{'arguments'}->[0]);
            if (($arg->isa('Perlito5::AST::Lookup'))) {
                ((my  $v) = $arg->obj());
                if ((($v->isa('Perlito5::AST::Var') && ($v->sigil() eq '$')))) {
                    ($v = Perlito5::AST::Var->new(('sigil' => '%'), ('namespace' => $v->namespace()), ('name' => $v->name())));
                    return (('(' . $v->emit_javascript() . ').hasOwnProperty(' . ($arg->index_exp())->emit_javascript() . ')'))
                };
                return (('(' . $v->emit_javascript() . ')._hash_.hasOwnProperty(' . ($arg->index_exp())->emit_javascript() . ')'))
            };
            if (($arg->isa('Perlito5::AST::Call'))) {
                if ((($arg->method() eq 'postcircumfix:<{ }>'))) {
                    return (('(' . $arg->invocant()->emit_javascript() . ')._hash_.hasOwnProperty(' . $arg->{'arguments'}->emit_javascript() . ')'))
                }
            }
        };
        if ((($code eq 'ternary:<?? !!>'))) {
            return (('( ' . Perlito5::Javascript::to_bool($self->{'arguments'}->[0]) . ' ? ' . ($self->{'arguments'}->[1])->emit_javascript() . ' : ' . ($self->{'arguments'}->[2])->emit_javascript() . ')'))
        };
        if ((($code eq 'circumfix:<( )>'))) {
            return (('(' . join(', ', map($_->emit_javascript_indented($level), @{$self->{'arguments'}})) . ')'))
        };
        if ((($code eq 'infix:<=>'))) {
            return (emit_javascript_bind($self->{'arguments'}->[0], $self->{'arguments'}->[1], $level))
        };
        if ((($code eq 'return'))) {
            ($Perlito5::THROW = 1);
            return (('throw(' . ((($self->{'arguments'} && @{$self->{'arguments'}}) ? $self->{'arguments'}->[0]->emit_javascript() : 'null')) . ')'))
        };
        if ((($code eq 'goto'))) {
            ($Perlito5::THROW = 1);
            return (('throw((' . $self->{'arguments'}->[0]->emit_javascript() . ')([List__]))'))
        };
        if (($self->{'namespace'})) {
            if (((($self->{'namespace'} eq 'JS') && ($code eq 'inline')))) {
                if (($self->{'arguments'}->[0]->isa('Perlito5::AST::Val::Buf'))) {
                    return ($self->{'arguments'}->[0]->{'buf'})
                }
                else {
                    die('JS::inline needs a string constant')
                }
            };
            ($code = ('NAMESPACE["' . $self->{'namespace'} . '"].' . $code))
        }
        else {
            ($code = ('NAMESPACE["' . $Perlito5::PKG_NAME . '"].' . $code))
        };
        ((my  @args) = ());
        for (@{$self->{'arguments'}}) {
            push(@args, $_->emit_javascript_indented($level) )
        };
        ($code . '([' . join(', ', @args) . '])')
    };
    sub Perlito5::AST::Apply::emit_javascript_bind {
        ((my  $parameters) = shift());
        ((my  $arguments) = shift());
        ((my  $level) = shift());
        if ((($parameters->isa('Perlito5::AST::Var') && ($parameters->sigil() eq '@')) || ($parameters->isa('Perlito5::AST::Decl') && ($parameters->var()->sigil() eq '@')))) {
            return (('(' . $parameters->emit_javascript() . ' = ' . Perlito5::Javascript::to_list([$arguments]) . ')'))
        }
        else {
            if ((($parameters->isa('Perlito5::AST::Var') && ($parameters->sigil() eq '%')) || ($parameters->isa('Perlito5::AST::Decl') && ($parameters->var()->sigil() eq '%')))) {
                return (('(' . $parameters->emit_javascript() . ' = array_to_hash(' . Perlito5::Javascript::to_list([$arguments]) . '))'))
            }
        };
        ('(' . $parameters->emit_javascript_indented($level) . ' = ' . $arguments->emit_javascript_indented($level) . ')')
    }
});
package Perlito5::AST::If;
(do {
    sub Perlito5::AST::If::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::If::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $cond) = $self->{'cond'});
        ((my  $body) = Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'body'}->stmts()), ('needs_return' => 0), ('create_context' => 1)));
        ((my  $s) = ('if ( ' . Perlito5::Javascript::to_bool($cond) . ' ) {' . chr(10) . $body->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '}'));
        if ((@{$self->{'otherwise'}->stmts()})) {
            ((my  $otherwise) = Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'otherwise'}->stmts()), ('needs_return' => 0), ('create_context' => 1)));
            ($s = ($s . chr(10) . Perlito5::Javascript::tab($level) . 'else {' . chr(10) . $otherwise->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '}'))
        };
        return ($s)
    }
});
package Perlito5::AST::While;
(do {
    sub Perlito5::AST::While::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::While::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $body) = Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'body'}->stmts()), ('needs_return' => 0), ('create_context' => 1)));
        return (('for ( ' . (($self->{'init'} ? ($self->{'init'}->emit_javascript() . '; ') : '; ')) . (($self->{'cond'} ? (Perlito5::Javascript::to_bool($self->{'cond'}) . '; ') : '; ')) . (($self->{'continue'} ? ($self->{'continue'}->emit_javascript() . ' ') : ' ')) . ') {' . chr(10) . $body->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '}'))
    }
});
package Perlito5::AST::For;
(do {
    sub Perlito5::AST::For::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::For::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $cond) = Perlito5::Javascript::to_list([$self->{'cond'}]));
        ((my  $body) = Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'body'}->stmts()), ('needs_return' => 0)));
        ((my  $sig) = 'v__');
        if (($self->{'body'}->sig())) {
            ((my  $v) = $self->{'body'}->sig());
            ($Perlito5::VAR->[0]->{$v->perl5_name()} = {('decl' => 'my')});
            ($sig = $v->emit_javascript_indented(($level + 1)))
        };
        ('for (var i_ = 0, a_ = (' . $cond . '); i_ < a_.length ; i_++) { ' . ('(function (' . $sig . ') {' . chr(10)) . $body->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '})(a_[i_]) }')
    }
});
package Perlito5::AST::Sub;
(do {
    sub Perlito5::AST::Sub::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Sub::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $s) = ('function (List__) {' . chr(10) . (Perlito5::Javascript::LexicalBlock->new(('block' => $self->{'block'}), ('needs_return' => 1), ('top_level' => 1)))->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '}'));
        if (($self->{'name'})) {
            if ((($Perlito5::PKG_NAME ne $self->{'namespace'}))) {
                die(('bad sub namespace ' . $Perlito5::PKG_NAME . ' ne '), $self->{'namespace'})
            };
            return (('make_sub("' . $self->{'namespace'} . '", "' . $self->{'name'} . '", ' . $s . ')'))
        }
        else {
            return ($s)
        }
    }
});
package Perlito5::AST::Do;
(do {
    sub Perlito5::AST::Do::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Do::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ((my  $block) = $self->simplify()->block());
        return (('(function () {' . chr(10) . (Perlito5::Javascript::LexicalBlock->new(('block' => $block), ('needs_return' => 1)))->emit_javascript_indented(($level + 1)) . chr(10) . Perlito5::Javascript::tab($level) . '})()'))
    }
});
package Perlito5::AST::Use;
(do {
    sub Perlito5::AST::Use::emit_javascript {
        $_[0]->emit_javascript_indented(0)
    };
    sub Perlito5::AST::Use::emit_javascript_indented {
        ((my  $self) = shift());
        ((my  $level) = shift());
        ('// use ' . $self->{'mod'} . chr(10))
    }
});

1;
