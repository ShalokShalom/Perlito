# Do not edit this file - Generated by MiniPerl6 2.0
use v5;
use strict;
use MiniPerl6::Perl5::Runtime;
use MiniPerl6::Perl5::Match;
{
package MiniPerl6::Go::LexicalBlock;
sub new { shift; bless { @_ }, "MiniPerl6::Go::LexicalBlock" }
sub block { @_ == 1 ? ( $_[0]->{block} ) : ( $_[0]->{block} = $_[1] ) };
sub needs_return { @_ == 1 ? ( $_[0]->{needs_return} ) : ( $_[0]->{needs_return} = $_[1] ) };
sub top_level { @_ == 1 ? ( $_[0]->{top_level} ) : ( $_[0]->{top_level} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; do { if (@{$self->{block}}) {  } else { return('') } }; (my  $str = ''); do { for my $decl1 ( @{$self->{block}} ) { (my  $decl = $decl1);do { if ((Main::isa($decl, 'Bind') && (Main::isa($decl->parameters(), 'Decl') && ($decl->parameters()->decl() eq 'my')))) { ($decl = $decl->parameters()) } else {  } };do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'my'))) { ($str = ($str . $decl->emit_go_init())) } else {  } } } }; my  $last_statement; do { if ($self->{needs_return}) { ($last_statement = pop( @{$self->{block}} )) } else {  } }; do { for my $decl ( @{$self->{block}} ) { do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'my'))) {  } else { ($str = ($str . ($decl->emit_go() . ';'))) } } } }; do { if (($self->{needs_return} && $last_statement)) { do { if (Main::isa($last_statement, 'If')) { (my  $cond = $last_statement->cond());(my  $body = $last_statement->body());(my  $otherwise = $last_statement->otherwise());do { if ((Main::isa($cond, 'Apply') && ($cond->code() eq 'prefix:<!>'))) { ($cond = $cond->arguments()->[0]);($body = $last_statement->otherwise());($otherwise = $last_statement->body()) } else {  } };do { if ((Main::isa($cond, 'Var') && ($cond->sigil() eq '@'))) { ($cond = Apply->new( 'code' => 'prefix:<@>','arguments' => [$cond], )) } else {  } };($body = MiniPerl6::Go::LexicalBlock->new( 'block' => $body,'needs_return' => 1,'top_level' => $self->{top_level}, ));($otherwise = MiniPerl6::Go::LexicalBlock->new( 'block' => $otherwise,'needs_return' => 1,'top_level' => $self->{top_level}, ));($str = ($str . ('if tobool( ' . (Call::emit_go_call($cond, 'bool') . (' ) { ' . ($body->emit_go() . (' } else { ' . ($otherwise->emit_go() . ' }')))))))) } else { do { if ((Main::isa($last_statement, 'Return') || Main::isa($last_statement, 'For'))) { ($str = ($str . $last_statement->emit_go())) } else { ($last_statement = Return->new( 'result' => $last_statement, ));do { if ($self->{top_level}) { ($str = ($str . $last_statement->emit_go())) } else { ($str = ($str . $last_statement->emit_go_simple())) } } } } } } } else {  } }; return($str) }

}

{
package CompUnit;
sub new { shift; bless { @_ }, "CompUnit" }
sub name { @_ == 1 ? ( $_[0]->{name} ) : ( $_[0]->{name} = $_[1] ) };
sub attributes { @_ == 1 ? ( $_[0]->{attributes} ) : ( $_[0]->{attributes} = $_[1] ) };
sub methods { @_ == 1 ? ( $_[0]->{methods} ) : ( $_[0]->{methods} = $_[1] ) };
sub body { @_ == 1 ? ( $_[0]->{body} ) : ( $_[0]->{body} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $class_name = Main::to_go_namespace($self->{name})); (my  $str = ('// instances of class ' . ($self->{name} . ('
' . ('type ' . ($class_name . (' struct {' . '
'))))))); do { for my $decl ( values( %{$self->{attributes}} ) ) { do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'has'))) { ($str = ($str . ('  ' . ('v_' . ($decl->var()->name() . (' *Any;' . '
')))))) } else {  } } } }; ($str = ($str . ('}' . '
'))); ($str = ($str . ('// methods in class ' . ($self->{name} . ('
' . ('var Method_' . ($class_name . (' struct {' . '
')))))))); do { for my $decl ( values( %{$self->{methods}} ) ) { do { if (Main::isa($decl, 'Method')) { ($str = ($str . ('  ' . ('f_' . ($decl->name() . (' func (*' . ($class_name . (', Capture) *Any;' . '
')))))))) } else {  } } } }; do { for my $decl ( values( %{$self->{attributes}} ) ) { do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'has'))) { ($str = ($str . ('  ' . ('f_' . ($decl->var()->name() . (' func (*' . ($class_name . (', Capture) *Any;' . '
')))))))) } else {  } } } }; ($str = ($str . ('}' . '
'))); ($str = ($str . ('// namespace ' . ($self->{name} . ('
' . ('var Namespace_' . ($class_name . (' struct {' . '
')))))))); do { for my $decl ( @{$self->{body}} ) { do { if (Main::isa($decl, 'Sub')) { ($str = ($str . ('  ' . ('f_' . ($decl->name() . (' Function;' . '
')))))) } else {  } } } }; ($str = ($str . ('}' . '
'))); ($str = ($str . ('var Run_' . ($class_name . (' func ();' . '
'))))); ($str = ($str . ('// method wrappers for ' . ($self->{name} . '
')))); do { for my $decl ( values( %{$self->{methods}} ) ) { do { if (Main::isa($decl, 'Method')) { ($str = ($str . ('func (v_self *' . ($class_name . (') f_' . ($decl->name() . (' (v Capture) *Any {' . ('
' . ('  return Method_' . ($class_name . ('.f_' . ($decl->name() . ('(v_self, v);' . ('
' . ('}' . '
'))))))))))))))) } else {  } } } }; do { for my $decl ( values( %{$self->{attributes}} ) ) { do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'has'))) { ($str = ($str . ('func (v_self *' . ($class_name . (') f_' . ($decl->var()->name() . (' (v Capture) *Any {' . ('
' . ('  return Method_' . ($class_name . ('.f_' . ($decl->var()->name() . ('(v_self, v);' . ('
' . ('}' . '
'))))))))))))))) } else {  } } } }; do { if ($self->{methods}->{'isa'}) {  } else { ($str = ($str . ('func (v_self *' . ($class_name . (') f_isa (v Capture) *Any { ' . ('return toBool( "' . ($self->{name} . ('" == tostr( v.p[0] ) ) ' . ('}' . '
'))))))))) } }; ($str = ($str . ('// prototype of ' . ($self->{name} . ('
' . ('var Proto_' . ($class_name . (' *Any;' . '
')))))))); ($str = ($str . ('func Init_' . ($class_name . ('() {' . '
'))))); ($str = ($str . ('  this_namespace := &Namespace_' . ($class_name . (';' . ('
' . ('  this_namespace = this_namespace;' . '
'))))))); ($str = ($str . ('  Proto_' . ($class_name . (' = ' . ('func() *Any { ' . ('var m = new(' . ($class_name . ('); ' . ('var m1 Any = m; ' . ('return &m1; ' . ('}();' . '
')))))))))))); do { for my $decl1 ( @{$self->{body}} ) { (my  $decl = $decl1);do { if ((Main::isa($decl, 'Bind') && (Main::isa($decl->parameters(), 'Decl') && ($decl->parameters()->decl() eq 'my')))) { ($decl = $decl->parameters()) } else {  } };do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'my'))) { ($str = ($str . $decl->emit_go_init())) } else {  } } } }; do { for my $decl ( @{$self->{body}} ) { do { if ((Main::isa($decl, 'Decl') && ($decl->decl() eq 'has'))) { ($str = ($str . ('  // accessor ' . ($decl->var()->name() . ('
' . ('  Method_' . ($class_name . ('.f_' . ($decl->var()->name() . (' = func (v_self *' . ($class_name . (', v Capture) *Any {' . ('
' . ('    ' . ('if v_self.v_' . ($decl->var()->name() . (' == nil {' . '
')))))))))))))))));($str = ($str . ('      ' . Decl->new( 'decl' => 'my','type' => (undef),'var' => Var->new( 'sigil' => $decl->var()->sigil(),'twigil' => '','namespace' => '','name' => 'tmp', ), )->emit_go_init())));($str = ($str . ('      ' . ('v_self.v_' . ($decl->var()->name() . (' = ' . (Var->new( 'sigil' => $decl->var()->sigil(),'twigil' => '','namespace' => '','name' => 'tmp', )->emit_go() . (';' . ('
' . ('    ' . ('}' . '
')))))))))));($str = ($str . ('    ' . ('return v_self.v_' . ($decl->var()->name() . ('
' . ('  };' . '
'))))))) } else {  } };do { if (Main::isa($decl, 'Method')) { (my  $sig = $decl->sig());(my  $block = MiniPerl6::Go::LexicalBlock->new( 'block' => $decl->block(),'needs_return' => 1,'top_level' => 1, ));($str = ($str . ('  // method ' . ($decl->name() . ('
' . ('  Method_' . ($class_name . ('.f_' . ($decl->name() . (' = func (self *' . ($class_name . (', v Capture) *Any {' . '
'))))))))))));($str = ($str . ('    var self1 Any = self;' . ('
' . ('    var ' . ($sig->invocant()->emit_go() . (' *Any = &self1;' . ('
' . ('    ' . ($sig->invocant()->emit_go() . (' = ' . ($sig->invocant()->emit_go() . (';' . ('
' . ('    ' . ($sig->emit_go_bind() . '
'))))))))))))))));($str = ($str . ('    p := make(chan *Any); go func () { ' . ('
' . ('        ' . ($block->emit_go() . ('; return }(); ' . ('
' . ('    return <-p; ' . ('
' . ('  };' . '
'))))))))))) } else {  } };do { if (Main::isa($decl, 'Sub')) { (my  $sig = $decl->sig());(my  $block = MiniPerl6::Go::LexicalBlock->new( 'block' => $decl->block(),'needs_return' => 1,'top_level' => 1, ));($str = ($str . ('  // sub ' . ($decl->name() . ('
' . ('  Namespace_' . ($class_name . ('.f_' . ($decl->name() . (' = Function( func (v Capture) *Any {' . '
'))))))))));($str = ($str . ('    ' . ($sig->emit_go_bind() . ('
' . ('    p := make(chan *Any); go func () { ' . ('
' . ('        ' . ($block->emit_go() . ('; return }(); ' . '
'))))))))));($str = ($str . ('    return <-p; ' . ('
' . ('  } );' . '
'))))) } else {  } } } }; ($str = ($str . ('  // main runtime block of ' . ($self->{name} . ('
' . ('  Run_' . ($class_name . (' = func () {' . '
')))))))); do { for my $decl ( @{$self->{body}} ) { do { if ((((Main::isa($decl, 'Decl') && (($decl->decl() eq 'has') || ($decl->decl() eq 'my'))) ? 0 : 1) && ((Main::isa($decl, 'Method') ? 0 : 1) && (Main::isa($decl, 'Sub') ? 0 : 1)))) { ($str = ($str . ('    ' . ($decl->emit_go() . (';' . '
'))))) } else {  } } } }; ($str = ($str . ('  }' . '
'))); ($str = ($str . ('}' . '
'))); return($str) };
sub emit_go_program { my $List__ = \@_; my $comp_units; do {  ($comp_units = $List__->[0]); [$comp_units] }; (my  $str = ''); my  $Hash_unit_seen; my  $List_tmp_comp_unit; do { for my $comp_unit ( @{$comp_units} ) { (my  $name = $comp_unit->name());do { if ($Hash_unit_seen->{$name}) { do { for my $stmt ( @{$comp_unit->body()} ) { push( @{$Hash_unit_seen->{$name}->body()}, $stmt ) } } } else { ($Hash_unit_seen->{$name} = $comp_unit);push( @{$List_tmp_comp_unit}, $comp_unit ) } } } }; ($comp_units = $List_tmp_comp_unit); do { for my $comp_unit ( @{$comp_units} ) { do { for my $stmt ( @{$comp_unit->body()} ) { do { if (Main::isa($stmt, 'Method')) { ($comp_unit->methods()->{$stmt->name()} = $stmt) } else {  } };do { if ((Main::isa($stmt, 'Decl') && ($stmt->decl() eq 'has'))) { ($comp_unit->attributes()->{$stmt->var()->name()} = $stmt) } else {  } } } } } }; do { for my $comp_unit ( @{$comp_units} ) { ($str = ($str . $comp_unit->emit_go())) } }; do { if ($Hash_unit_seen->{'MiniPerl6::Grammar'}) {  } else { ($str = ($str . 'type MiniPerl6__Grammar struct{}
')) } }; ($str = ($str . '// interfaces for all methods
')); (my  $Hash_meth_seen = { 'join' => 1,'perl' => 1,'scalar' => 1,'isa' => 1,'values' => 1,'bind' => 1,'int' => 1,'str' => 1,'bool' => 1,'array' => 1,'hash' => 1,'push' => 1,'lookup' => 1,'index' => 1, }); do { for my $comp_unit ( @{$comp_units} ) { do { for my $stmt ( @{$comp_unit->body()} ) { do { if ((Main::isa($stmt, 'Method') && ($Hash_meth_seen->{$stmt->name()} ? 0 : 1))) { (my  $meth = $stmt->name());($str = ($str . ('type ' . ($meth . ('_er interface { f_' . ($meth . ' (Capture) *Any }
'))))));($Hash_meth_seen->{$meth} = 1) } else {  } };do { if ((Main::isa($stmt, 'Decl') && (($stmt->decl() eq 'has') && ($Hash_meth_seen->{$stmt->var()->name()} ? 0 : 1)))) { (my  $meth = $stmt->var()->name());($str = ($str . ('type ' . ($meth . ('_er interface { f_' . ($meth . ' (Capture) *Any }
'))))));($Hash_meth_seen->{$meth} = 1) } else {  } } } } } }; ($str = ($str . ('
' . ('func main () {
' . '  Init_MiniPerl6__Match();
')))); do { for my $comp_unit ( @{$comp_units} ) { ($str = ($str . ('  Init_' . (Main::to_go_namespace($comp_unit->name()) . '();
')))) } }; ($str = ($str . '  Init_Prelude();
')); do { for my $comp_unit ( @{$comp_units} ) { ($str = ($str . ('  Run_' . (Main::to_go_namespace($comp_unit->name()) . '();
')))) } }; ($str = ($str . ('}' . '
'))); return($str) }

}

{
package Val::Int;
sub new { shift; bless { @_ }, "Val::Int" }
sub int { @_ == 1 ? ( $_[0]->{int} ) : ( $_[0]->{int} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('toInt(' . ($self->{int} . ')')) }

}

{
package Val::Bit;
sub new { shift; bless { @_ }, "Val::Bit" }
sub bit { @_ == 1 ? ( $_[0]->{bit} ) : ( $_[0]->{bit} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('toBit(' . ($self->{bit} . ')')) }

}

{
package Val::Num;
sub new { shift; bless { @_ }, "Val::Num" }
sub num { @_ == 1 ? ( $_[0]->{num} ) : ( $_[0]->{num} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('toNum(' . ($self->{num} . ')')) }

}

{
package Val::Buf;
sub new { shift; bless { @_ }, "Val::Buf" }
sub buf { @_ == 1 ? ( $_[0]->{buf} ) : ( $_[0]->{buf} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('toStr("' . (Main::javascript_escape_string($self->{buf}) . '")')) }

}

{
package Val::Undef;
sub new { shift; bless { @_ }, "Val::Undef" }
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; 'u_undef()' }

}

{
package Val::Object;
sub new { shift; bless { @_ }, "Val::Object" }
sub class { @_ == 1 ? ( $_[0]->{class} ) : ( $_[0]->{class} = $_[1] ) };
sub fields { @_ == 1 ? ( $_[0]->{fields} ) : ( $_[0]->{fields} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; die('Val::Object - not used yet') }

}

{
package Lit::Seq;
sub new { shift; bless { @_ }, "Lit::Seq" }
sub seq { @_ == 1 ? ( $_[0]->{seq} ) : ( $_[0]->{seq} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('[]*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{seq} } ], ', ') . ' }')) }

}

{
package Lit::Array;
sub new { shift; bless { @_ }, "Lit::Array" }
sub array1 { @_ == 1 ? ( $_[0]->{array1} ) : ( $_[0]->{array1} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $str = ''); do { for my $item ( @{$self->{array1}} ) { do { if (((Main::isa($item, 'Var') && ($item->sigil() eq '@')) || (Main::isa($item, 'Apply') && ($item->code() eq 'prefix:<@>')))) { ($str = ($str . ('func(a_ Array) { ' . ('for i_ := 0; i_ < a_.n; i_++ { (*a).(push_er).f_push( Capture{ p: []*Any{ a_.v[i_] } } ) } ' . ('}( (*' . (Call::emit_go_call($item, 'array') . ').(Array) ); ')))))) } else { ($str = ($str . ('(*a).(push_er).f_push( Capture{ p: []*Any{ ' . ($item->emit_go() . ' } } ); ')))) } } } }; ('func () *Any { ' . ('a := a_array(); ' . ($str . ('return a; ' . '}()')))) }

}

{
package Lit::Hash;
sub new { shift; bless { @_ }, "Lit::Hash" }
sub hash1 { @_ == 1 ? ( $_[0]->{hash1} ) : ( $_[0]->{hash1} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $fields = $self->{hash1}); (my  $str = ''); do { for my $field ( @{$fields} ) { ($str = ($str . ('*(*m).(lookup_er).f_lookup( Capture{ p : []*Any{ ' . ($field->[0]->emit_go() . (' }} ) = *(' . ($field->[1]->emit_go() . '); ')))))) } }; ('func() *Any { ' . ('m := h_hash(); ' . ($str . ('return m; ' . '}()')))) }

}

{
package Lit::Code;
sub new { shift; bless { @_ }, "Lit::Code" }


}

{
package Lit::Object;
sub new { shift; bless { @_ }, "Lit::Object" }
sub class { @_ == 1 ? ( $_[0]->{class} ) : ( $_[0]->{class} = $_[1] ) };
sub fields { @_ == 1 ? ( $_[0]->{fields} ) : ( $_[0]->{fields} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $fields = $self->{fields}); (my  $str = ''); do { for my $field ( @{$fields} ) { ($str = ($str . ('if m.v_' . ($field->[0]->buf() . (' == nil {' . ('var p Any; ' . ('m.v_' . ($field->[0]->buf() . (' = &p; ' . ('}' . ('*m.v_' . ($field->[0]->buf() . (' = *' . ($field->[1]->emit_go() . '; ')))))))))))))) } }; ('func() *Any { ' . ('var m = new(' . (Main::to_go_namespace($self->{class}) . ('); ' . ($str . ('var m1 Any = m; ' . ('return &m1; ' . '}()'))))))) }

}

{
package Index;
sub new { shift; bless { @_ }, "Index" }
sub obj { @_ == 1 ? ( $_[0]->{obj} ) : ( $_[0]->{obj} = $_[1] ) };
sub index_exp { @_ == 1 ? ( $_[0]->{index_exp} ) : ( $_[0]->{index_exp} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('(*(*' . ($self->{obj}->emit_go() . (').(array_er).f_array(Capture{}))' . ('.(index_er).f_index( Capture{ p : []*Any{ ' . ($self->{index_exp}->emit_go() . ' }} )'))))) }

}

{
package Lookup;
sub new { shift; bless { @_ }, "Lookup" }
sub obj { @_ == 1 ? ( $_[0]->{obj} ) : ( $_[0]->{obj} = $_[1] ) };
sub index_exp { @_ == 1 ? ( $_[0]->{index_exp} ) : ( $_[0]->{index_exp} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('(*(*' . ($self->{obj}->emit_go() . (').(hash_er).f_hash(Capture{}))' . ('.(lookup_er).f_lookup( Capture{ p : []*Any{ ' . ($self->{index_exp}->emit_go() . ' }} )'))))) }

}

{
package Var;
sub new { shift; bless { @_ }, "Var" }
sub sigil { @_ == 1 ? ( $_[0]->{sigil} ) : ( $_[0]->{sigil} = $_[1] ) };
sub twigil { @_ == 1 ? ( $_[0]->{twigil} ) : ( $_[0]->{twigil} = $_[1] ) };
sub namespace { @_ == 1 ? ( $_[0]->{namespace} ) : ( $_[0]->{namespace} = $_[1] ) };
sub name { @_ == 1 ? ( $_[0]->{name} ) : ( $_[0]->{name} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $table = { '$' => 'v_','@' => 'List_','%' => 'Hash_','&' => 'Code_', }); (my  $ns = ''); do { if ($self->{namespace}) { ($ns = (Main::to_go_namespace($self->{namespace}) . '.')) } else {  } }; (($self->{twigil} eq '.') ? ('(*v_self).(' . ($self->{name} . ('_er).f_' . ($self->{name} . '(Capture{})')))) : (($self->{name} eq '/') ? 'Proto_MiniPerl6__Match' : ($table->{$self->{sigil}} . ($ns . $self->{name})))) };
sub plain_name { my $self = shift; my $List__ = \@_; do { [] }; do { if ($self->{namespace}) { return(($self->{namespace} . ('.' . $self->{name}))) } else {  } }; return($self->{name}) }

}

{
package Bind;
sub new { shift; bless { @_ }, "Bind" }
sub parameters { @_ == 1 ? ( $_[0]->{parameters} ) : ( $_[0]->{parameters} = $_[1] ) };
sub arguments { @_ == 1 ? ( $_[0]->{arguments} ) : ( $_[0]->{arguments} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; do { if (Main::isa($self->{parameters}, 'Lit::Array')) { (my  $a = $self->{parameters}->array1());(my  $str = ('func () *Any { ' . ('List_tmp := ' . ($self->{arguments}->emit_go() . '; '))));(my  $i = 0);do { for my $var ( @{$a} ) { (my  $bind = Bind->new( 'parameters' => $var,'arguments' => Index->new( 'obj' => Var->new( 'sigil' => '@','twigil' => '','namespace' => '','name' => 'tmp', ),'index_exp' => Val::Int->new( 'int' => $i, ), ), ));($str = ($str . (' ' . ($bind->emit_go() . '; '))));($i = ($i + 1)) } };return(($str . ' return List_tmp }()')) } else {  } }; do { if (Main::isa($self->{parameters}, 'Lit::Hash')) { (my  $a = $self->{parameters}->hash1());(my  $b = $self->{arguments}->hash1());(my  $str = 'do { ');(my  $i = 0);my  $arg;do { for my $var ( @{$a} ) { ($arg = Val::Undef->new(  ));do { for my $var2 ( @{$b} ) { do { if (($var2->[0]->buf() eq $var->[0]->buf())) { ($arg = $var2->[1]) } else {  } } } };(my  $bind = Bind->new( 'parameters' => $var->[1],'arguments' => $arg, ));($str = ($str . (' ' . ($bind->emit_go() . '; '))));($i = ($i + 1)) } };return(($str . ($self->{parameters}->emit_go() . ' }'))) } else {  } }; do { if (Main::isa($self->{parameters}, 'Lit::Object')) { (my  $class = $self->{parameters}->class());(my  $a = $self->{parameters}->fields());(my  $b = $self->{arguments});(my  $str = 'do { ');(my  $i = 0);my  $arg;do { for my $var ( @{$a} ) { (my  $bind = Bind->new( 'parameters' => $var->[1],'arguments' => Call->new( 'invocant' => $b,'method' => $var->[0]->buf(),'arguments' => [],'hyper' => 0, ), ));($str = ($str . (' ' . ($bind->emit_go() . '; '))));($i = ($i + 1)) } };return(($str . ($self->{parameters}->emit_go() . ' }'))) } else {  } }; do { if (Main::isa($self->{parameters}, 'Call')) { return(('func () *Any { ' . ('var tmp = ' . (Call::emit_go_call($self->{parameters}->invocant(), $self->{parameters}->method()) . ('; ' . ('*tmp = *( ' . ($self->{arguments}->emit_go() . (' ); ' . ('return tmp; ' . '}()'))))))))) } else {  } }; ('*' . ($self->{parameters}->emit_go() . (' = *(' . ($self->{arguments}->emit_go() . ')')))) }

}

{
package Proto;
sub new { shift; bless { @_ }, "Proto" }
sub name { @_ == 1 ? ( $_[0]->{name} ) : ( $_[0]->{name} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; Main::to_go_namespace($self->{name}) }

}

{
package Call;
sub new { shift; bless { @_ }, "Call" }
sub invocant { @_ == 1 ? ( $_[0]->{invocant} ) : ( $_[0]->{invocant} = $_[1] ) };
sub hyper { @_ == 1 ? ( $_[0]->{hyper} ) : ( $_[0]->{hyper} = $_[1] ) };
sub method { @_ == 1 ? ( $_[0]->{method} ) : ( $_[0]->{method} = $_[1] ) };
sub arguments { @_ == 1 ? ( $_[0]->{arguments} ) : ( $_[0]->{arguments} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $invocant = $self->{invocant}->emit_go()); do { if (Main::isa($self->{invocant}, 'Proto')) { ($invocant = ('Proto_' . $invocant)) } else {  } }; (my  $meth = $self->{method}); do { if (($meth eq 'postcircumfix:<( )>')) { do { if ($self->{hyper}) { ($meth = '') } else { return(($invocant . ('( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )')))) } } } else {  } }; do { if ($self->{hyper}) { return(('func (a_ *Any) *Any { ' . ('var out = a_array(); ' . ('var i = (*(*a_).(array_er).f_array(Capture{})).(Array); ' . ('for pos := 0; pos <= i.n; pos++ { ' . ('(*out).(push_er).f_push( Capture{p: []*Any{ (*i.v[pos]).(' . ($meth . ('_er).f_' . ($meth . ('(Capture{ p : []*Any{}  }) }} ) } ' . ('return out; ' . ('}(' . ($invocant . ')'))))))))))))) } else {  } }; return(('(*' . ($invocant . (').(' . ($meth . ('_er).f_' . ($meth . ('( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))))))))) };
sub emit_go_call { my $List__ = \@_; my $invocant; my $meth_name; do {  ($invocant = $List__->[0]);  ($meth_name = $List__->[1]); [$invocant, $meth_name] }; (my  $invocant1 = $invocant->emit_go()); do { if (Main::isa($invocant, 'Proto')) { ($invocant1 = ('Proto_' . $invocant1)) } else {  } }; (my  $meth = $meth_name); return(('(*' . ($invocant1 . (').(' . ($meth . ('_er).f_' . ($meth . '(Capture{})'))))))) }

}

{
package Apply;
sub new { shift; bless { @_ }, "Apply" }
sub code { @_ == 1 ? ( $_[0]->{code} ) : ( $_[0]->{code} = $_[1] ) };
sub arguments { @_ == 1 ? ( $_[0]->{arguments} ) : ( $_[0]->{arguments} = $_[1] ) };
sub namespace { @_ == 1 ? ( $_[0]->{namespace} ) : ( $_[0]->{namespace} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $code = $self->{code}); do { if (Main::isa($code, 'Str')) {  } else { return(('(' . ($self->{code}->emit_go() . (')->(' . (Main::join([ map { $_->emit() } @{ $self->{arguments} } ], ', ') . ')'))))) } }; do { if (($code eq 'self')) { return('v_self') } else {  } }; do { if (($code eq 'false')) { return('b_false()') } else {  } }; do { if (($code eq 'make')) { return(('func () *Any { ' . ('tmp := ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ('; ' . ('*(*v_MATCH).(capture_er).f_capture(Capture{}) = *tmp; ' . ('return tmp; ' . '}()'))))))) } else {  } }; do { if (($code eq 'say')) { return(('f_print( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ', toStr("\\n") } } )'))) } else {  } }; do { if (($code eq 'print')) { return(('f_print( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'warn')) { return(('f_print_stderr( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ', toStr("\\n") } } )'))) } else {  } }; do { if (($code eq 'die')) { return(('f_die( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'defined')) { return(('f_defined( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'pop')) { return(('f_pop( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'push')) { return(('f_push( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'index')) { return(('f_index( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'substr')) { return(('f_substr( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'scalar')) { return(('f_scalar( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'prefix:<~>')) { return(Call::emit_go_call($self->{arguments}->[0], 'str')) } else {  } }; do { if (($code eq 'prefix:<!>')) { return(('toBool(!tobool(' . ($self->{arguments}->[0]->emit_go() . '))'))) } else {  } }; do { if (($code eq 'prefix:<?>')) { return(Call::emit_go_call($self->{arguments}->[0], 'bool')) } else {  } }; do { if (($code eq 'prefix:<$>')) { return(('f_scalar( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) } else {  } }; do { if (($code eq 'prefix:<@>')) { return(Call::emit_go_call($self->{arguments}->[0], 'array')) } else {  } }; do { if (($code eq 'prefix:<%>')) { return(Call::emit_go_call($self->{arguments}->[0], 'hash')) } else {  } }; do { if (($code eq 'infix:<~>')) { return(('toStr( ' . ('tostr(' . ($self->{arguments}->[0]->emit_go() . (') + ' . ('tostr(' . ($self->{arguments}->[1]->emit_go() . (') ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<+>')) { return(('toInt( ' . ('toint(' . ($self->{arguments}->[0]->emit_go() . (') + ' . ('toint(' . ($self->{arguments}->[1]->emit_go() . (') ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<->')) { return(('toInt( ' . ('toint(' . ($self->{arguments}->[0]->emit_go() . (') - ' . ('toint(' . ($self->{arguments}->[1]->emit_go() . (') ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<>>')) { return(('toBool( ' . ('toint(' . ($self->{arguments}->[0]->emit_go() . (') > ' . ('toint(' . ($self->{arguments}->[1]->emit_go() . (') ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<&&>')) { return(('f_and( ' . ('func () *Any { return ' . ($self->{arguments}->[0]->emit_go() . (' }, ' . ('func () *Any { return ' . ($self->{arguments}->[1]->emit_go() . (' } ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<||>')) { return(('f_or( ' . ('func () *Any { return ' . ($self->{arguments}->[0]->emit_go() . (' }, ' . ('func () *Any { return ' . ($self->{arguments}->[1]->emit_go() . (' } ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<eq>')) { return(('toBool(' . ('tostr(' . ($self->{arguments}->[0]->emit_go() . (') == ' . ('tostr(' . ($self->{arguments}->[1]->emit_go() . (')' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<ne>')) { return(('toBool(' . ('tostr(' . ($self->{arguments}->[0]->emit_go() . (') != ' . ('tostr(' . ($self->{arguments}->[1]->emit_go() . (')' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<==>')) { return(('toBool(' . ('toint(' . ($self->{arguments}->[0]->emit_go() . (') == ' . ('toint(' . ($self->{arguments}->[1]->emit_go() . (') ' . ')')))))))) } else {  } }; do { if (($code eq 'infix:<!=>')) { return(('toBool(' . ('toint(' . ($self->{arguments}->[0]->emit_go() . (') != ' . ('toint(' . ($self->{arguments}->[1]->emit_go() . (') ' . ')')))))))) } else {  } }; do { if (($code eq 'ternary:<?? !!>')) { return(('func () *Any { ' . ('if tobool( ' . (Call::emit_go_call($self->{arguments}->[0], 'bool') . (' ) ' . ('{ return ' . ($self->{arguments}->[1]->emit_go() . (' }; ' . ('return ' . ($self->{arguments}->[2]->emit_go() . (' ' . '}()'))))))))))) } else {  } }; ($code = ('f_' . $self->{code})); do { if ($self->{namespace}) { ($code = ('Namespace_' . (Main::to_go_namespace($self->{namespace}) . ('.' . $code)))) } else { ($code = ('this_namespace.' . $code)) } }; ($code . ('( Capture{ p : []*Any{ ' . (Main::join([ map { $_->emit_go() } @{ $self->{arguments} } ], ', ') . ' } } )'))) }

}

{
package Return;
sub new { shift; bless { @_ }, "Return" }
sub result { @_ == 1 ? ( $_[0]->{result} ) : ( $_[0]->{result} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; do { if (Main::isa($self->{result}, 'Bind')) { (my  $tmp = $self->{result}->parameters());return(('(func () *Any { ' . ($self->{result}->emit_go() . ('; ' . ('Go_return(p, ' . ($tmp->emit_go() . ('); ' . ('return u_undef(); ' . '}())')))))))) } else {  } }; return(('(func () *Any { ' . ('var tmp *Any = ' . ($self->{result}->emit_go() . ('; ' . ('Go_return(p, tmp); ' . ('return u_undef(); ' . '}())'))))))) };
sub emit_go_simple { my $self = shift; my $List__ = \@_; do { [] }; do { if (Main::isa($self->{result}, 'Bind')) { (my  $tmp = $self->{result}->parameters());return(('return (func () *Any { ' . ($self->{result}->emit_go() . ('; ' . ('return ' . ($tmp->emit_go() . ('; ' . '}())'))))))) } else {  } }; return(('return( ' . ($self->{result}->emit_go() . ')'))) }

}

{
package If;
sub new { shift; bless { @_ }, "If" }
sub cond { @_ == 1 ? ( $_[0]->{cond} ) : ( $_[0]->{cond} = $_[1] ) };
sub body { @_ == 1 ? ( $_[0]->{body} ) : ( $_[0]->{body} = $_[1] ) };
sub otherwise { @_ == 1 ? ( $_[0]->{otherwise} ) : ( $_[0]->{otherwise} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $cond = $self->{cond}); do { if ((Main::isa($cond, 'Apply') && ($cond->code() eq 'prefix:<!>'))) { (my  $if = If->new( 'cond' => $cond->arguments()->[0],'body' => $self->{otherwise},'otherwise' => $self->{body}, ));return($if->emit_go()) } else {  } }; do { if ((Main::isa($cond, 'Var') && ($cond->sigil() eq '@'))) { ($cond = Apply->new( 'code' => 'prefix:<@>','arguments' => [$cond], )) } else {  } }; (my  $s = ('if tobool( ' . (Call::emit_go_call($cond, 'bool') . (' ) { ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{body},'needs_return' => 0, )->emit_go() . ' }'))))); do { if (@{$self->{otherwise}}) {  } else { return($s) } }; return(($s . (' else { ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{otherwise},'needs_return' => 0, )->emit_go() . ' }')))) }

}

{
package For;
sub new { shift; bless { @_ }, "For" }
sub cond { @_ == 1 ? ( $_[0]->{cond} ) : ( $_[0]->{cond} = $_[1] ) };
sub body { @_ == 1 ? ( $_[0]->{body} ) : ( $_[0]->{body} = $_[1] ) };
sub topic { @_ == 1 ? ( $_[0]->{topic} ) : ( $_[0]->{topic} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('func (a_ *Any) { ' . ('var i = (*(*a_).(array_er).f_array(Capture{})).(Array); ' . ('for pos := 0; pos <= i.n; pos++ { ' . ('func (' . ($self->{topic}->emit_go() . (' *Any) { ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{body},'needs_return' => 0, )->emit_go() . (' }(i.v[pos]) ' . ('} ' . ('}(' . ($self->{cond}->emit_go() . ')'))))))))))) }

}

{
package When;
sub new { shift; bless { @_ }, "When" }
sub parameters { @_ == 1 ? ( $_[0]->{parameters} ) : ( $_[0]->{parameters} = $_[1] ) };
sub body { @_ == 1 ? ( $_[0]->{body} ) : ( $_[0]->{body} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; die('TODO - When') }

}

{
package While;
sub new { shift; bless { @_ }, "While" }
sub cond { @_ == 1 ? ( $_[0]->{cond} ) : ( $_[0]->{cond} = $_[1] ) };
sub body { @_ == 1 ? ( $_[0]->{body} ) : ( $_[0]->{body} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; die('TODO - While') }

}

{
package Leave;
sub new { shift; bless { @_ }, "Leave" }
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; die('TODO - Leave') }

}

{
package Decl;
sub new { shift; bless { @_ }, "Decl" }
sub decl { @_ == 1 ? ( $_[0]->{decl} ) : ( $_[0]->{decl} = $_[1] ) };
sub type { @_ == 1 ? ( $_[0]->{type} ) : ( $_[0]->{type} = $_[1] ) };
sub var { @_ == 1 ? ( $_[0]->{var} ) : ( $_[0]->{var} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; $self->{var}->emit_go() };
sub emit_go_init { my $self = shift; my $List__ = \@_; do { [] }; do { if (($self->{decl} eq 'my')) { (my  $str = '');($str = ($str . ('var ' . ($self->{var}->emit_go() . (' *Any;' . '
')))));($str = ($str . ($self->{var}->emit_go() . (' = ' . ($self->{var}->emit_go() . (';' . '
'))))));do { if (($self->{var}->sigil() eq '%')) { ($str = ($str . ($self->{var}->emit_go() . (' = h_hash();' . '
')))) } else { do { if (($self->{var}->sigil() eq '@')) { ($str = ($str . ($self->{var}->emit_go() . (' = a_array();' . '
')))) } else { ($str = ($str . ($self->{var}->emit_go() . (' = u_undef();' . '
')))) } } } };return($str) } else { die(('not implemented: Decl \'' . ($self->{decl} . '\''))) } } }

}

{
package Sig;
sub new { shift; bless { @_ }, "Sig" }
sub invocant { @_ == 1 ? ( $_[0]->{invocant} ) : ( $_[0]->{invocant} = $_[1] ) };
sub positional { @_ == 1 ? ( $_[0]->{positional} ) : ( $_[0]->{positional} = $_[1] ) };
sub named { @_ == 1 ? ( $_[0]->{named} ) : ( $_[0]->{named} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ' print \'Signature - TODO\'; die \'Signature - TODO\'; ' };
sub emit_go_bind { my $self = shift; my $List__ = \@_; do { [] }; (my  $str = ''); (my  $i = 0); do { for my $decl ( @{$self->{positional}} ) { ($str = ($str . ($decl->emit_go() . (' := v.p[' . ($i . ']; ')))));($i = ($i + 1)) } }; return($str) }

}

{
package Method;
sub new { shift; bless { @_ }, "Method" }
sub name { @_ == 1 ? ( $_[0]->{name} ) : ( $_[0]->{name} = $_[1] ) };
sub sig { @_ == 1 ? ( $_[0]->{sig} ) : ( $_[0]->{sig} = $_[1] ) };
sub block { @_ == 1 ? ( $_[0]->{block} ) : ( $_[0]->{block} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; (my  $invocant = $self->{sig}->invocant()); ('func ' . ($self->{name} . ('(v Capture) *Any { ' . ('    ' . ($self->{sig}->emit_go_bind() . ('
' . ('    p := make(chan *Any); go func () { ' . ('
' . ('        ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{block},'needs_return' => 1,'top_level' => 1, )->emit_go() . ('; return }(); ' . ('
' . ('    return <-p; ' . ('
' . ' }')))))))))))))) }

}

{
package Sub;
sub new { shift; bless { @_ }, "Sub" }
sub name { @_ == 1 ? ( $_[0]->{name} ) : ( $_[0]->{name} = $_[1] ) };
sub sig { @_ == 1 ? ( $_[0]->{sig} ) : ( $_[0]->{sig} = $_[1] ) };
sub block { @_ == 1 ? ( $_[0]->{block} ) : ( $_[0]->{block} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; do { if (($self->{name} eq '')) { return(('Function( func(v Capture) *Any { ' . ('    ' . ($self->{sig}->emit_go_bind() . ('
' . ('    p := make(chan *Any); go func () { ' . ('
' . ('        ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{block},'needs_return' => 1,'top_level' => 1, )->emit_go() . ('; return }(); ' . ('
' . ('    return <-p; ' . ('
' . ('} ' . ')')))))))))))))) } else {  } }; ('func ' . ($self->{name} . ('(v Capture) *Any { ' . ('    ' . ($self->{sig}->emit_go_bind() . ('
' . ('    p := make(chan *Any); go func () { ' . ('
' . ('        ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{block},'needs_return' => 1,'top_level' => 1, )->emit_go() . ('; return }(); ' . ('
' . ('    return <-p; ' . ('
' . ' }')))))))))))))) }

}

{
package Do;
sub new { shift; bless { @_ }, "Do" }
sub block { @_ == 1 ? ( $_[0]->{block} ) : ( $_[0]->{block} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('(func () *Any { ' . (MiniPerl6::Go::LexicalBlock->new( 'block' => $self->{block},'needs_return' => 1, )->emit_go() . ('; return u_undef() ' . '})()'))) }

}

{
package Use;
sub new { shift; bless { @_ }, "Use" }
sub mod { @_ == 1 ? ( $_[0]->{mod} ) : ( $_[0]->{mod} = $_[1] ) };
sub emit_go { my $self = shift; my $List__ = \@_; do { [] }; ('// use ' . ($self->{mod} . '
')) }

}

1;
