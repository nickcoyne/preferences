require 'spec_helper'

#------------------------------------------------------------------------------
describe 'PreferenceDefinitionByDefaultTest' do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications)
  end

  it 'test_should_have_a_name' do
    expect('notifications').to eq @definition.name
  end

  it "test_should_not_have_a_default_value" do
    expect(nil).to eq @definition.default_value
  end

  it "test_should_have_a_type" do
    expect(@definition.type).to eq :boolean
  end

  it "test_should_type_cast_values_as_booleans" do
    expect(@definition.type_cast(nil)).to eq nil
    expect(@definition.type_cast(true)).to eq true
    expect(@definition.type_cast(false)).to eq false
    expect(@definition.type_cast(0)).to eq false
    expect(@definition.type_cast(1)).to eq true
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
    expect(@definition.default_value).to eq true
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithGroupDefaultsTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :boolean, :default => 1, :group_defaults => {:chat => 0})
  end

  it "test_should_use_default_for_default_group" do
    expect(@definition.default_value).to eq true
  end

  it "test_should_use_default_for_unknown_group" do
    expect(@definition.default_value('email')).to eq true
  end

  it "test_should_use_group_default_for_known_group" do
    expect(@definition.default_value('chat')).to eq false
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithStringifiedTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :any)
  end

  it "test_should_symbolize_type" do
    expect(@definition.type).to eq :any
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithAnyTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :any)
  end

  it "test_use_custom_type" do
    expect(@definition.type).to eq :any
  end

  it "test_should_not_be_number" do
    expect(!@definition.number?).to eq true
  end

  it "test_should_not_type_cast" do
    expect(@definition.type_cast(nil)).to eq nil
    expect(@definition.type_cast(0)).to eq 0
    expect(@definition.type_cast(1)).to eq 1
    expect(@definition.type_cast(false)).to eq false
    expect(@definition.type_cast(true)).to eq true
    expect(@definition.type_cast('')).to eq ''
  end

  it "test_should_query_false_if_value_is_nil" do
    expect(@definition.query(nil)).to eq false
  end

  it "test_should_query_true_if_value_is_zero" do
    expect(@definition.query(0)).to eq true
  end

  it "test_should_query_true_if_value_is_not_zero" do
    expect(@definition.query(1)).to eq true
    expect(@definition.query(-1)).to eq true
  end

  it "test_should_query_false_if_value_is_blank" do
    expect(@definition.query('')).to eq false
  end

  it "test_should_query_true_if_value_is_not_blank" do
    expect(@definition.query('hello')).to eq true
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithBooleanTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications)
  end

  it "test_should_not_be_number" do
    expect(!@definition.number?).to eq true
  end

  it "test_should_not_type_cast_if_value_is_nil" do
    expect(@definition.type_cast(nil)).to eq nil
  end

  it "test_should_type_cast_to_false_if_value_is_zero" do
    expect(@definition.type_cast(0)).to eq false
  end

  it "test_should_type_cast_to_true_if_value_is_not_zero" do
    expect(@definition.type_cast(1)).to eq true
  end

  it "test_should_type_cast_to_true_if_value_is_true_string" do
    expect(@definition.type_cast('true')).to eq true
  end

  it "test_should_type_cast_to_nil_if_value_is_not_true_string" do
    expect(@definition.type_cast('')).to eq nil
  end

  it "test_should_query_false_if_value_is_nil" do
    expect(@definition.query(nil)).to eq false
  end

  it "test_should_query_true_if_value_is_one" do
    assert_equal true, @definition.query(1)
  end

  it "test_should_query_false_if_value_not_one" do
    expect(@definition.query(0)).to eq false
  end

  it "test_should_query_true_if_value_is_true_string" do
    expect(@definition.query('true')).to eq true
  end

  it "test_should_query_false_if_value_is_not_true_string" do
    expect(@definition.query('')).to eq false
  end
end

#------------------------------------------------------------------------------
describe "PreferenceDefinitionWithNumericTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :integer)
  end

  it "test_should_be_number" do
    expect(@definition.number?).to eq true
  end

  it "test_should_type_cast_true_to_integer" do
    expect(@definition.type_cast(true)).to eq 1
  end

  # it "test_should_type_cast_false_to_integer" do
  #   assert_equal 0, @definition.type_cast(false)
  # end

  it "test_should_type_cast_string_to_integer" do
    expect(@definition.type_cast('hello')).to eq 0
  end

  it "test_should_query_false_if_value_is_nil" do
    expect(@definition.query(nil)).to eq false
  end

  it "test_should_query_true_if_value_is_one" do
    expect(@definition.query(1)).to eq true
  end

  it "test_should_query_false_if_value_is_zero" do
    expect(@definition.query(0)).to eq false
  end
end

#------------------------------------------------------------------------------
describe "> PreferenceDefinitionWithStringTypeTest" do
  before do
    @definition = Preferences::PreferenceDefinition.new(:notifications, :string)
  end

  it "test_should_not_be_number" do
    expect(!@definition.number?).to eq true
  end

  it "test_should_type_cast_integers_to_strings" do
    expect(@definition.type_cast('1')).to eq '1'
  end

  it "test_should_not_type_cast_booleans" do
    expect(@definition.type_cast(true)).to eq 't'
  end

  it "test_should_query_false_if_value_is_nil" do
    expect(@definition.query(nil)).to eq false
  end

  it "test_should_query_true_if_value_is_one" do
    expect(@definition.query(1)).to eq true
  end

  it "test_should_query_true_if_value_is_zero" do
    expect(@definition.query(0)).to eq true
  end

  it "test_should_query_false_if_value_is_blank" do
    expect(@definition.query('')).to eq false
  end

  it "test_should_query_true_if_value_is_not_blank" do
    expect(@definition.query('hello')).to eq true
  end
end
