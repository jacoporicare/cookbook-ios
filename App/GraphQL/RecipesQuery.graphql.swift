// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public class RecipesQuery: GraphQLQuery {
  public static let operationName: String = "Recipes"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      query Recipes {
        recipes {
          __typename
          ...RecipeDetails
        }
      }
      """,
      fragments: [RecipeDetails.self]
    ))

  public init() {}

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Query }
    public static var __selections: [Selection] { [
      .field("recipes", [Recipe].self),
    ] }

    public var recipes: [Recipe] { __data["recipes"] }

    /// Recipe
    ///
    /// Parent Type: `Recipe`
    public struct Recipe: API.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { API.Objects.Recipe }
      public static var __selections: [Selection] { [
        .fragment(RecipeDetails.self),
      ] }

      public var id: API.ID { __data["id"] }
      public var title: String { __data["title"] }
      public var gridImageUrl: String? { __data["gridImageUrl"] }
      public var listImageUrl: String? { __data["listImageUrl"] }
      public var fullImageUrl: String? { __data["fullImageUrl"] }
      public var directions: String? { __data["directions"] }
      public var sideDish: String? { __data["sideDish"] }
      public var preparationTime: Int? { __data["preparationTime"] }
      public var servingCount: Int? { __data["servingCount"] }
      public var ingredients: [RecipeDetails.Ingredient]? { __data["ingredients"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var recipeDetails: RecipeDetails { _toFragment() }
      }
    }
  }
}