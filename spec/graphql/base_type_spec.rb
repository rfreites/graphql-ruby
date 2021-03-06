# frozen_string_literal: true
require "spec_helper"

describe GraphQL::BaseType do
  it "becomes non-null with !" do
    type = GraphQL::EnumType.new
    non_null_type = !type
    assert_equal(GraphQL::TypeKinds::NON_NULL, non_null_type.kind)
    assert_equal(type, non_null_type.of_type)
    assert_equal(GraphQL::TypeKinds::NON_NULL, (!GraphQL::STRING_TYPE).kind)
  end

  it "can be compared" do
    obj_type = Dummy::MilkType
    assert_equal(!GraphQL::INT_TYPE, !GraphQL::INT_TYPE)
    refute_equal(!GraphQL::FLOAT_TYPE, GraphQL::FLOAT_TYPE)
    assert_equal(
      GraphQL::ListType.new(of_type: obj_type),
      GraphQL::ListType.new(of_type: obj_type)
    )
    refute_equal(
      GraphQL::ListType.new(of_type: obj_type),
      GraphQL::ListType.new(of_type: !obj_type)
    )
  end

  it "Accepts arbitrary metadata" do
    assert_equal ["Cheese"], Dummy::CheeseType.metadata[:class_names]
  end

  describe "#dup" do
    let(:obj_type) {
      GraphQL::ObjectType.define do
        name "SomeObject"
        field :id, types.Int
      end
    }

    it "resets connection types" do
      # Make sure the defaults have been calculated
      obj_edge = obj_type.edge_type
      obj_conn = obj_type.connection_type
      obj_2 = obj_type.dup
      obj_2.name = "Cheese2"
      refute_equal obj_edge, obj_2.edge_type
      refute_equal obj_edge, obj_2.connection_type
    end
  end
end
