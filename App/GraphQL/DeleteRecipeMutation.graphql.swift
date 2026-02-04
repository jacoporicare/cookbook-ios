// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import API

public class DeleteRecipeMutation: GraphQLMutation {
  public static let operationName: String = "DeleteRecipe"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeleteRecipe($id: ID!) { deleteRecipe(id: $id) }"#
    ))

  public var id: API.ID

  public init(id: API.ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("deleteRecipe", Bool.self, arguments: ["id": .variable("id")]),
    ] }
    public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      DeleteRecipeMutation.Data.self
    ] }

    public var deleteRecipe: Bool { __data["deleteRecipe"] }
  }
}
