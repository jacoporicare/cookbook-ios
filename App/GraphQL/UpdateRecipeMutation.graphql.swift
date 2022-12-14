// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI
@_exported import enum ApolloAPI.GraphQLEnum
@_exported import enum ApolloAPI.GraphQLNullable
import API

public class UpdateRecipeMutation: GraphQLMutation {
  public static let operationName: String = "UpdateRecipe"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation UpdateRecipe($id: ID!, $recipe: RecipeInput!, $image: Upload) {
        updateRecipe(id: $id, recipe: $recipe, image: $image) {
          __typename
          ...RecipeDetails
        }
      }
      """,
      fragments: [RecipeDetails.self]
    ))

  public var id: API.ID
  public var recipe: API.RecipeInput
  public var image: GraphQLNullable<API.Upload>

  public init(
    id: API.ID,
    recipe: API.RecipeInput,
    image: GraphQLNullable<API.Upload>
  ) {
    self.id = id
    self.recipe = recipe
    self.image = image
  }

  public var __variables: Variables? { [
    "id": id,
    "recipe": recipe,
    "image": image
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { API.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("updateRecipe", UpdateRecipe.self, arguments: [
        "id": .variable("id"),
        "recipe": .variable("recipe"),
        "image": .variable("image")
      ]),
    ] }

    public var updateRecipe: UpdateRecipe { __data["updateRecipe"] }

    /// UpdateRecipe
    ///
    /// Parent Type: `Recipe`
    public struct UpdateRecipe: API.SelectionSet {
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
      public var tags: [String] { __data["tags"] }
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
