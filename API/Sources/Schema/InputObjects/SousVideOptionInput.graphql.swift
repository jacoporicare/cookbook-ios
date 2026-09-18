// @generated
// This file was automatically generated and should not be edited.

@_spi(Internal) @_spi(Unsafe) import ApolloAPI

nonisolated public struct SousVideOptionInput: InputObject {
  @_spi(Unsafe) public private(set) var __data: InputDict

  @_spi(Unsafe) public init(_ data: InputDict) {
    __data = data
  }

  public init(
    temperature: Double,
    toTemperature: GraphQLNullable<Double> = nil,
    time: GraphQLNullable<String> = nil,
    label: String
  ) {
    __data = InputDict([
      "temperature": temperature,
      "toTemperature": toTemperature,
      "time": time,
      "label": label
    ])
  }

  public var temperature: Double {
    get { __data["temperature"] }
    set { __data["temperature"] = newValue }
  }

  public var toTemperature: GraphQLNullable<Double> {
    get { __data["toTemperature"] }
    set { __data["toTemperature"] = newValue }
  }

  public var time: GraphQLNullable<String> {
    get { __data["time"] }
    set { __data["time"] = newValue }
  }

  public var label: String {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }
}
