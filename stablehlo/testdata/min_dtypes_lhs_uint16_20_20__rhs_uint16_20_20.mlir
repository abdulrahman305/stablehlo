// RUN: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<20x20xui16>, tensor<20x20xui16>)
    %1 = call @expected() : () -> tensor<20x20xui16>
    %2 = stablehlo.minimum %0#0, %0#1 : tensor<20x20xui16>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<20x20xui16>, tensor<20x20xui16>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<20x20xui16>, tensor<20x20xui16>) {
    %0 = stablehlo.constant dense<"0x0000010001000000010000000400020004000000050005000100010005000000030003000300050002000200000004000000040005000200030001000000050000000200000001000300040003000200040001000000030001000400070001000600010001000100000000000100020001000300010002000200000002000200010001000100050003000000000002000500000000000400050006000200050003000200040007000000010001000000000003000300010001000000030002000000000000000400010000000000030003000500030001000100020000000100020002000800000006000200020000000200040001000000010000000000020000000200020001000600050001000300040002000100010000000000000000000100030002000000060001000400010001000400030000000300000001000100010001000300040000000000050000000200010001000400010001000200010001000000020004000300000002000500000001000200090001000600020002000600000004000100010003000300030002000300010000000100000000000100000000000300010001000200010000000000020001000700030002000100070002000400010002000200010000000000000002000300020000000100020001000300030007000000020001000000000001000700010001000400000003000200000002000200030002000500010001000300010006000300070003000100000009000300030000000000010005000000010000000400000001000600000003000600040002000000010002000000000001000000020001000000040001000200070003000100030000000400000005000000010003000000040005000300030001000200010001000100040003000000010002000200030004000200020002000100020001000200020000000100000001000200020002000000040003000500010001000100000002000300010001000400020000000600000002000000030002000000000000000200020003000000000003000500010002000000010002000100000003000000020004000400000000000100010002000000020001000000"> : tensor<20x20xui16>
    %1 = stablehlo.constant dense<"0x0100060003000400000002000000030001000000020000000000020002000100030004000400010002000000000002000100030001000200000000000100050000000000000000000100010000000500000004000200040003000000040000000000030004000000000000000200000003000500030001000000050002000300010003000200010007000000070006000700010004000200010003000000010003000200050000000100010000000200040003000000000001000500010002000100030000000000030005000000000003000400000000000000010005000200030000000100020001000100030002000000000000000600020002000200020003000500010001000000000004000200020005000400020001000400030004000100020003000000030000000000020002000300030001000200000004000400030003000200010000000200010001000600000002000000000000000000020003000000010003000100000004000200010006000400030001000500020000000100000000000200060000000100060002000100030001000300010002000100010000000400000000000300060000000000010003000300010002000400030003000300020001000100000001000000020000000200050001000100030001000200020000000100000002000000030000000000090001000200000000000000010004000100000001000400000005000100010006000200030001000000000000000200040006000400000003000300040002000000040000000200010003000200010001000300040002000000050004000300020002000300040004000000040001000300030000000000000007000100000001000400000008000400030001000000000004000200010001000000030003000000040000000000020000000300030000000200020001000100070003000200020002000200000002000300030000000500000000000000000002000200030000000100000003000000010000000200020001000300000000000800010000000600030003000300020001000000010001000200010000000400010002000400020000000600000002000000"> : tensor<20x20xui16>
    return %0, %1 : tensor<20x20xui16>, tensor<20x20xui16>
  }
  func.func private @expected() -> tensor<20x20xui16> {
    %0 = stablehlo.constant dense<"0x0000010001000000000000000000020001000000020000000000010002000000030003000300010002000000000002000000030001000200000000000000050000000000000000000100010000000200000001000000030001000000040000000000010001000000000000000100000001000300010001000000000002000200010001000100010003000000000002000500000000000200010003000000010003000200040000000000010000000000000003000000000001000000010002000000000000000000010000000000000003000400000000000000010000000100020000000100000001000100020000000000000000000000010000000000020000000200010001000000000001000200020002000100010000000000000000000100020002000000030000000000010001000300030000000200000001000100010001000200010000000000010000000200000001000000000000000000010001000000010003000100000002000200000001000200030001000500020000000100000000000100010000000100030002000100010000000100000000000100000000000300000000000200010000000000010001000300010002000100030002000300010001000100000000000000000000000200020000000100020001000200020000000000000001000000000000000000010001000200000000000000000002000100000001000400000001000100010006000200030001000000000000000200030000000000000003000000010000000000000000000200000003000200010001000000010002000000000001000000020001000000040001000000040001000100030000000000000005000000000001000000000005000300030001000000000001000100010001000000010002000000030000000000020000000100020000000200020000000100000001000200020002000000000002000300010000000100000000000000000001000200020000000100000002000000010000000000000000000200000000000000000000000500010002000000010001000000000001000000010000000400000000000100010000000000000001000000"> : tensor<20x20xui16>
    return %0 : tensor<20x20xui16>
  }
}