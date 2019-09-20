#! perl

use strict;
use warnings;

use local::lib "local";
use Test::More;

use Language::LispPerl;
use Test::Memory::Cycle;
use Log::Any::Adapter qw/Stderr/;

ok( my $lisp = Language::LispPerl::Evaler->new() );

memory_cycle_ok( $lisp, 'I haz no cycles' );

$lisp->load("core.clp");
memory_cycle_ok( $lisp, 'No cycle after load' );


my $res = $lisp->eval(q|
(defn abc [] ( + 1 2 ))
(abc)

(defn make-adder [add-this]
  (fn [to-this] (+ add-this to-this)))

(let [adder (make-adder 6)]
 (adder 7))
(abc)
|);
is($res->value, 3, "eval ok");
memory_cycle_ok( $lisp, 'No cycle after eval' );

done_testing();
