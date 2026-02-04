// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import API

public class CreateRecipeMutation: GraphQLMutation {
  public static let operationName: String = "CreateRecipe"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateRecipe($recipe: RecipeInput!, $imageId: ID) { createRecipe(recipe: $recipe, imageId: $imageId) { __typename ...RecipeDetails } }"#,
      fragments: [RecipeDetails.self]
    ))

  public var recipe: API.RecipeInput
  public var imageId: GraphQLNullable<API.ID>

  public init(
    recipe: API.RecipeInput,
    imageId: GraphQLNullable<API.ID>
  ) {
    self.recipe = recipe
    self.imageId = imageId
  }

  public var __variables: Variables? { [
    "recipe": recipe,
    "imageId": imageId
  ] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("createRecipe", CreateRecipe.self, arguments: [
        "recipe": .variable("recipe"),
        "imageId": .variable("imageId")
      ]),
    ] }
    public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CreateRecipeMutation.Data.self
    ] }

    public var createRecipe: CreateRecipe { __data["createRecipe"] }

    /// CreateRecipe
    ///
    /// Parent Type: `Recipe`
    public struct CreateRecipe: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.Recipe }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(RecipeDetails.self),
      ] }
      public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CreateRecipeMutation.Data.CreateRecipe.self,
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
