// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import API

public class UpdateRecipeMutation: GraphQLMutation {
  public static let operationName: String = "UpdateRecipe"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateRecipe($id: ID!, $recipe: RecipeInput!, $imageId: ID) { updateRecipe(id: $id, recipe: $recipe, imageId: $imageId) { __typename ...RecipeDetails } }"#,
      fragments: [RecipeDetails.self]
    ))

  public var id: API.ID
  public var recipe: API.RecipeInput
  public var imageId: GraphQLNullable<API.ID>

  public init(
    id: API.ID,
    recipe: API.RecipeInput,
    imageId: GraphQLNullable<API.ID>
  ) {
    self.id = id
    self.recipe = recipe
    self.imageId = imageId
  }

  public var __variables: Variables? { [
    "id": id,
    "recipe": recipe,
    "imageId": imageId
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateRecipe", UpdateRecipe.self, arguments: [
        "id": .variable("id"),
        "recipe": .variable("recipe"),
        "imageId": .variable("imageId")
      ]),
    ] }
    public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      UpdateRecipeMutation.Data.self
    ] }

    public var updateRecipe: UpdateRecipe { __data["updateRecipe"] }

    /// UpdateRecipe
    ///
    /// Parent Type: `Recipe`
    public struct UpdateRecipe: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Recipe }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RecipeDetails.self),
      ] }
      public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        UpdateRecipeMutation.Data.UpdateRecipe.self,
        RecipeDetails.self
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
      public var ingredients: [Ingredient] { __data["ingredients"] }
      public var cookedHistory: [CookedHistory] { __data["cookedHistory"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var recipeDetails: RecipeDetails { _toFragment() }
      }

      public typealias Ingredient = RecipeDetails.Ingredient

      public typealias CookedHistory = RecipeDetails.CookedHistory
    }
  }
}
