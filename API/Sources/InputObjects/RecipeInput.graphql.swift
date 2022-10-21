// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct RecipeInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    title: String,
    directions: GraphQLNullable<String> = nil,
    sideDish: GraphQLNullable<String> = nil,
    preparationTime: GraphQLNullable<Int> = nil,
    servingCount: GraphQLNullable<Int> = nil,
    ingredients: GraphQLNullable<[API.IngredientInput]> = nil,
    tags: GraphQLNullable<[String]> = nil
  ) {
    __data = InputDict([
      "title": title,
      "directions": directions,
      "sideDish": sideDish,
      "preparationTime": preparationTime,
      "servingCount": servingCount,
      "ingredients": ingredients,
      "tags": tags
    ])
  }

  public var title: String {
    get { __data.title }
    set { __data.title = newValue }
  }

  public var directions: GraphQLNullable<String> {
    get { __data.directions }
    set { __data.directions = newValue }
  }

  public var sideDish: GraphQLNullable<String> {
    get { __data.sideDish }
    set { __data.sideDish = newValue }
  }

  public var preparationTime: GraphQLNullable<Int> {
    get { __data.preparationTime }
    set { __data.preparationTime = newValue }
  }

  public var servingCount: GraphQLNullable<Int> {
    get { __data.servingCount }
    set { __data.servingCount = newValue }
  }

  public var ingredients: GraphQLNullable<[API.IngredientInput]> {
    get { __data.ingredients }
    set { __data.ingredients = newValue }
  }

  public var tags: GraphQLNullable<[String]> {
    get { __data.tags }
    set { __data.tags = newValue }
  }
}
