require 'spec_helper'

#------------------------------------------------------------------------------
describe 'PreferenceDefinitionByDefaultTest' do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications)
  end

  it 'test_should_have_a_name' do
    # assert_equal 'notifications2', @definition.name
    expect('notifications').to eq @definition.name
  end

  it "test_should_not_have_a_default_value" do
    expect(nil).to eq @definition.default_value
  end

  it "test_should_have_a_type" do
    assert_equal :boolean, @definition.type
  end

  it "test_should_type_cast_values_as_booleans" do
    assert_equal nil, @definition.type_cast(nil)
    assert_equal true, @definition.type_cast(true)
    assert_equal false, @definition.type_cast(false)
    assert_equal false, @definition.type_cast(0)
    assert_equal true, @definition.type_cast(1)
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionTest" do
  it "test_should_raise_exception_if_invalid_option_specified" do
    expect {
      Preferences::PreferenceDefinition.new(:notifications, :invalid => true)
    }.to raise_error(ArgumentError)
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithDefaultValueTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :boolean, :default => 1)
  end

  it "test_should_type_cast_default_values" do
    assert_equal true, @definition.default_value
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithGroupDefaultsTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :boolean, :default => 1, :group_defaults => {:chat => 0})
  end

  it "test_should_use_default_for_default_group" do
    assert_equal true, @definition.default_value
  end

  it "test_should_use_default_for_unknown_group" do
    assert_equal true, @definition.default_value('email')
  end

  it "test_should_use_group_default_for_known_group" do
    assert_equal false, @definition.default_value('chat')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithStringifiedTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :any)
  end

  it "test_should_symbolize_type" do
    assert_equal :any, @definition.type
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithAnyTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :any)
  end

  it "test_use_custom_type" do
    assert_equal :any, @definition.type
  end

  it "test_should_not_be_number" do
    assert !@definition.number?
  end

  it "test_should_not_type_cast" do
    assert_equal nil, @definition.type_cast(nil)
    assert_equal 0, @definition.type_cast(0)
    assert_equal 1, @definition.type_cast(1)
    assert_equal false, @definition.type_cast(false)
    assert_equal true, @definition.type_cast(true)
    assert_equal '', @definition.type_cast('')
  end

  it "test_should_query_false_if_value_is_nil" do
    assert_equal false, @definition.query(nil)
  end

  it "test_should_query_true_if_value_is_zero" do
    assert_equal true, @definition.query(0)
  end

  it "test_should_query_true_if_value_is_not_zero" do
    assert_equal true, @definition.query(1)
    assert_equal true, @definition.query(-1)
  end

  it "test_should_query_false_if_value_is_blank" do
    assert_equal false, @definition.query('')
  end

  it "test_should_query_true_if_value_is_not_blank" do
    assert_equal true, @definition.query('hello')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithBooleanTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications)
  end

  it "test_should_not_be_number" do
    assert !@definition.number?
  end

  it "test_should_not_type_cast_if_value_is_nil" do
    assert_equal nil, @definition.type_cast(nil)
  end

  it "test_should_type_cast_to_false_if_value_is_zero" do
    assert_equal false, @definition.type_cast(0)
  end

  it "test_should_type_cast_to_true_if_value_is_not_zero" do
    assert_equal true, @definition.type_cast(1)
  end

  it "test_should_type_cast_to_true_if_value_is_true_string" do
    assert_equal true, @definition.type_cast('true')
  end

  it "test_should_type_cast_to_nil_if_value_is_not_true_string" do
    assert_nil @definition.type_cast('')
  end

  it "test_should_query_false_if_value_is_nil" do
    assert_equal false, @definition.query(nil)
  end

  it "test_should_query_true_if_value_is_one" do
    assert_equal true, @definition.query(1)
  end

  it "test_should_query_false_if_value_not_one" do
    assert_equal false, @definition.query(0)
  end

  it "test_should_query_true_if_value_is_true_string" do
    assert_equal true, @definition.query('true')
  end

  it "test_should_query_false_if_value_is_not_true_string" do
    assert_equal false, @definition.query('')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithNumericTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :integer)
  end

  it "test_should_be_number" do
    assert @definition.number?
  end

  it "test_should_type_cast_true_to_integer" do
    assert_equal 1, @definition.type_cast(true)
  end

  # it "test_should_type_cast_false_to_integer" do
  #   assert_equal 0, @definition.type_cast(false)
  # end

  it "test_should_type_cast_string_to_integer" do
    assert_equal 0, @definition.type_cast('hello')
  end

  it "test_should_query_false_if_value_is_nil" do
    assert_equal false, @definition.query(nil)
  end

  it "test_should_query_true_if_value_is_one" do
    assert_equal true, @definition.query(1)
  end

  it "test_should_query_false_if_value_is_zero" do
    assert_equal false, @definition.query(0)
  end
end

#------------------------------------------------------------------------------
describe "> PreferenceDefinitionWithStringTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :string)
  end

  it "test_should_not_be_number" do
    assert !@definition.number?
  end

  it "test_should_type_cast_integers_to_strings" do
    assert_equal '1', @definition.type_cast('1')
  end

  it "test_should_not_type_cast_booleans" do
    assert_equal 't', @definition.type_cast(true)
  end

  it "test_should_query_false_if_value_is_nil" do
    assert_equal false, @definition.query(nil)
  end

  it "test_should_query_true_if_value_is_one" do
    assert_equal true, @definition.query(1)
  end

  it "test_should_query_true_if_value_is_zero" do
    assert_equal true, @definition.query(0)
  end

  it "test_should_query_false_if_value_is_blank" do
    assert_equal false, @definition.query('')
  end

  it "test_should_query_true_if_value_is_not_blank" do
    assert_equal true, @definition.query('hello')
  end
end
