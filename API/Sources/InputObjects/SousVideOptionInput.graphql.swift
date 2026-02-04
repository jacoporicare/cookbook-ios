// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct SousVideOptionInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    temperature: Double,
    time: String,
    label: String
  ) {
    __data = InputDict([
      "temperature": temperature,
      "time": time,
      "label": label
    ])
  }

  public var temperature: Double {
    get { __data["temperature"] }
    set { __data["temperature"] = newValue }
  }

  public var time: String {
    get { __data["time"] }
    set { __data["time"] = newValue }
  }

  public var label: String {
    get { __data["label"] }
    set { __data["label"] = newValue }
  }
}
