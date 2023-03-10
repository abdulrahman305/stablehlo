// RUN-DISABLED: stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt -inline | stablehlo-translate --interpret
// RUN: diff <(stablehlo-translate --deserialize %s.0_9_0.bc | stablehlo-opt) <(stablehlo-opt %s)
// RUN: diff <(stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt) <(stablehlo-opt %s)

module @jit_testcase {
  func.func public @main() -> tensor<i1> {
    %0 = stablehlo.constant dense<[[0, 1], [2, 3]]> : tensor<2x2xi32>
    %1:2 = call @inputs() : () -> (tensor<5x6x7xf16>, tensor<2x7xf16>)
    %2 = call @expected() : () -> tensor<5x6x7xf16>
    %3 = "stablehlo.scatter"(%1#0, %0, %1#1) ({
    ^bb0(%arg0: tensor<f16>, %arg1: tensor<f16>):
      %5 = stablehlo.minimum %arg0, %arg1 : tensor<f16>
      stablehlo.return %5 : tensor<f16>
    }) {scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [1], inserted_window_dims = [0, 1], scatter_dims_to_operand_dims = [0, 1], index_vector_dim = 1>, unique_indices = true} : (tensor<5x6x7xf16>, tensor<2x2xi32>, tensor<2x7xf16>) -> tensor<5x6x7xf16>
    %4 = stablehlo.custom_call @check.eq(%3, %2) : (tensor<5x6x7xf16>, tensor<5x6x7xf16>) -> tensor<i1>
    return %4 : tensor<i1>
  }
  func.func private @inputs() -> (tensor<5x6x7xf16>, tensor<2x7xf16>) {
    %0 = stablehlo.constant dense<"0x4144D2BF3E3CC74074C0C43B8A3F1E41B93F24C1122DDEB714457DC0BDC2D0C5B33FF1BC73418DC4D43A803898C88FB09E2CAAAF3B3D143CE5BF17417BBE36BF82BCF2406D3D79C2184377B95DC02BC1043373C4C0C55D42DBC1A7BC47434C3C62420CC1A3B870BCC5C02CC4AF3F0D40D2BC27C75A3EC1C5A2C1CB44F7347E383EBFFEC24C44543809C001BCA13F9B3ADA3F324236BF77C53DC2D6BBBBA18F35893C283720BDE246FFC077C2F9BD49C4C7C490400CBDED3D12BD8A449A3D3AACB6BB48B86140B0C0F2BCA2BC0D3E473438C60438D3438FC5F4B5964632BFC2BFAE4077C4E9364044DAB48CB99DC252C77144814596B44CB6EC3DF0C3E0C4D4C0663C8539FD40C2C3D8BFBF3B93C4AC41444472BE433F0E4121C7C1365A420DC0D33CF94453BB3AC02BC241429A4070C1213E6EC45D3E47BC0D3AEBB9563DEAB9044494454140B043BEBE59C5BDBF0639C0C48A3CB5BCF2B93CC0A042CA44EA40A3B0E5BEAC3F16A8B9C014BDB242D6431E41D33F69C5864416C10DBDF142F74489C1A4C27B3E41B901C67B4526C0DD3A583E45AA00B5B139B0B972BF3EBB12C00545ACC2"> : tensor<5x6x7xf16>
    %1 = stablehlo.constant dense<[[5.654300e-01, -2.453130e+00, -2.898440e+00, 1.128910e+00, 1.200200e+00, 3.453130e+00, -4.269530e+00], [-7.221670e-01, 8.203130e-01, -3.896480e+00, 2.296880e+00, 6.718750e-01, 3.343750e+00, 5.914060e+00]]> : tensor<2x7xf16>
    return %0, %1 : tensor<5x6x7xf16>, tensor<2x7xf16>
  }
  func.func private @expected() -> tensor<5x6x7xf16> {
    %0 = stablehlo.constant dense<"0x4144D2BF3E3CC74074C0C43B8A3F8638E8C0CCC1122DDEB7E84245C4BDC2D0C5B33FF1BC73418DC4D43A803898C88FB09E2CAAAF3B3D143CE5BF17417BBE36BF82BCF2406D3D79C2184377B95DC02BC1043373C4C0C55D42DBC1A7BC47434C3C62420CC1A3B870BCC5C02CC4AF3F0D40D2BC27C75A3EC1C5A2C1CB44F7347E383EBFFEC24C44543809C001BCA13F9B3ADA3F324236BF77C53DC2D6BBBBA18F35893C283720BDE246FFC077C2F9BD49C4C7C490400CBDED3D12BD8A449A3D3AACB6BB48B86140B0C0F2BCA2BC0D3E473438C6C7B9903A8FC5F4B5603932BFC2BFAE4077C4E9364044DAB48CB99DC252C77144814596B44CB6EC3DF0C3E0C4D4C0663C8539FD40C2C3D8BFBF3B93C4AC41444472BE433F0E4121C7C1365A420DC0D33CF94453BB3AC02BC241429A4070C1213E6EC45D3E47BC0D3AEBB9563DEAB9044494454140B043BEBE59C5BDBF0639C0C48A3CB5BCF2B93CC0A042CA44EA40A3B0E5BEAC3F16A8B9C014BDB242D6431E41D33F69C5864416C10DBDF142F74489C1A4C27B3E41B901C67B4526C0DD3A583E45AA00B5B139B0B972BF3EBB12C00545ACC2"> : tensor<5x6x7xf16>
    return %0 : tensor<5x6x7xf16>
  }
}
