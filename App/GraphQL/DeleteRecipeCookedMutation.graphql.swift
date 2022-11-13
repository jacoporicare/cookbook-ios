// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public class DeleteRecipeCookedMutation: GraphQLMutation {
  public static let operationName: String = "DeleteRecipeCooked"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation DeleteRecipeCooked($recipeId: ID!, $cookedId: ID!) {
        deleteRecipeCooked(recipeId: $recipeId, cookedId: $cookedId) {
          __typename
          ...RecipeDetails
        }
      }
      """,
      fragments: [RecipeDetails.self]
    ))

  public var recipeId: API.ID
  public var cookedId: API.ID

  public init(
    recipeId: API.ID,
    cookedId: API.ID
  ) {
    self.recipeId = recipeId
    self.cookedId = cookedId
  }

  public var __variables: Variables? { [
    "recipeId": recipeId,
    "cookedId": cookedId
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("deleteRecipeCooked", DeleteRecipeCooked.self, arguments: [
        "recipeId": .variable("recipeId"),
        "cookedId": .variable("cookedId")
      ]),
    ] }

    public var deleteRecipeCooked: DeleteRecipeCooked { __data["deleteRecipeCooked"] }

    /// DeleteRecipeCooked
    ///
    /// Parent Type: `Recipe`
    public struct DeleteRecipeCooked: API.SelectionSet {
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
      public var ingredients: [RecipeDetails.Ingredient] { __data["ingredients"] }
      public var cookedHistory: [RecipeDetails.CookedHistory] { __data["cookedHistory"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(data: DataDict) { __data = data }

        public var recipeDetails: RecipeDetails { _toFragment() }
      }
    }
  }
}
