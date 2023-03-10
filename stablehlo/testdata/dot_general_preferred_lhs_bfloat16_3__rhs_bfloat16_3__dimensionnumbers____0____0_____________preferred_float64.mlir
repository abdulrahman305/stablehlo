// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0:2 = call @inputs() : () -> (tensor<3xbf16>, tensor<3xbf16>)
    %1 = call @expected() : () -> tensor<f32>
    %2 = "stablehlo.dot_general"(%0#0, %0#1) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [0], rhs_contracting_dimensions = [0]>} : (tensor<3xbf16>, tensor<3xbf16>) -> tensor<f32>
    %3 = stablehlo.custom_call @check.eq(%2, %1) : (tensor<f32>, tensor<f32>) -> tensor<i1>
    return %3 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<3xbf16>, tensor<3xbf16>) {
    %0 = stablehlo.constant dense<[4.656250e+00, -1.273440e+00, -4.000000e+00]> : tensor<3xbf16>
    %1 = stablehlo.constant dense<[1.476560e+00, -9.765620e-01, -2.156250e+00]> : tensor<3xbf16>
    return %0, %1 : tensor<3xbf16>, tensor<3xbf16>
  }
  func.func private @expected() -> tensor<f32> {
    %0 = stablehlo.constant dense<16.7438354> : tensor<f32>
    return %0 : tensor<f32>
  }
}
