// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct IngredientInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    amount: GraphQLNullable<Double> = nil,
    amountUnit: GraphQLNullable<String> = nil,
    name: String,
    isGroup: GraphQLNullable<Bool> = nil
  ) {
    __data = InputDict([
      "amount": amount,
      "amountUnit": amountUnit,
      "name": name,
      "isGroup": isGroup
    ])
  }

  public var amount: GraphQLNullable<Double> {
    get { __data.amount }
    set { __data.amount = newValue }
  }

  public var amountUnit: GraphQLNullable<String> {
    get { __data.amountUnit }
    set { __data.amountUnit = newValue }
  }

  public var name: String {
    get { __data.name }
    set { __data.name = newValue }
  }

  public var isGroup: GraphQLNullable<Bool> {
    get { __data.isGroup }
    set { __data.isGroup = newValue }
  }
}
