require 'spec_helper'

include Factory

#------------------------------------------------------------------------------
describe "PreferenceByDefaultTest" do
  before do
    @preference = Preference.new
  end

  it "test_should_not_have_a_name" do
    assert @preference.name.blank?
  end

  it "test_should_not_have_an_owner" do
    assert_nil @preference.owner_id
  end

  it "test_should_not_have_an_owner_type" do
    assert @preference.owner_type.blank?
  end

  it "test_should_not_have_a_group_association" do
    assert_nil @preference.group_id
  end

  it "test_should_not_have_a_group_type" do
    assert @preference.group_type.nil?
  end

  it "test_should_not_have_a_value" do
    assert @preference.value.blank?
  end

  it "test_should_not_have_a_definition" do
    assert_nil @preference.definition
  end
end

#------------------------------------------------------------------------------
describe "PreferenceTest" do
  
  it "test_should_be_valid_with_a_set_of_valid_attributes" do
    preference = new_preference
    assert preference.valid?
  end

  it "test_should_require_a_name" do
    preference = new_preference(:name => nil)
    assert !preference.valid?
    assert preference.errors.include?(:name)
  end

  it "test_should_require_an_owner_id" do
    preference = new_preference(:owner => nil)
    assert !preference.valid?
    assert preference.errors.include?(:owner_id)
  end

  it "test_should_require_an_owner_type" do
    preference = new_preference(:owner => nil)
    assert !preference.valid?
    assert preference.errors.include?(:owner_type)
  end

  it "test_should_not_require_a_group_id" do
    preference = new_preference(:group => nil)
    assert preference.valid?
  end

  it "test_should_not_require_a_group_id_if_type_specified" do
    preference = new_preference(:group => nil)
    preference.group_type = 'Car'
    assert preference.valid?
  end

  it "test_should_not_require_a_group_type" do
    preference = new_preference(:group => nil)
    assert preference.valid?
  end

  it "test_should_require_a_group_type_if_id_specified" do
    preference = new_preference(:group => nil)
    preference.group_id = 1
    assert !preference.valid?
    assert preference.errors.include?(:group_type)
  end
end

#------------------------------------------------------------------------------
describe "PreferenceAsAClassTest" do
  it "test_should_be_able_to_split_nil_groups" do
    group_id, group_type = Preference.split_group(nil)
    assert_nil group_id
    assert_nil group_type
  end

  it "test_should_be_able_to_split_non_active_record_groups" do
    group_id, group_type = Preference.split_group('car')
    assert_nil group_id
    assert_equal 'car', group_type

    group_id, group_type = Preference.split_group(:car)
    assert_nil group_id
    assert_equal 'car', group_type

    group_id, group_type = Preference.split_group(10)
    assert_nil group_id
    assert_equal 10, group_type
  end

  it "test_should_be_able_to_split_active_record_groups" do
    car = create_car

    group_id, group_type = Preference.split_group(car)
    assert_equal 1, group_id
    assert_equal 'Car', group_type
  end
end

#------------------------------------------------------------------------------
describe "PreferenceAfterBeingCreatedTest" do
  before do
    User.preference :notifications, :boolean

    @preference = create_preference(:name => 'notifications')
  end

  it "test_should_have_an_owner" do
    expect(@preference.owner.nil?).to eq false
  end

  it "test_should_have_a_definition" do
    expect(@preference.definition.nil?).to eq false
  end

  it "test_should_have_a_value" do
    expect(@preference.value.nil?).to eq false
  end

  it "test_should_not_have_a_group_association" do
    assert_nil @preference.group
  end

  after do
    User.preference_definitions.delete('notifications')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithBasicGroupTest" do
  before do
    @preference = create_preference(:group_type => 'car')
  end

  it "test_should_have_a_group_association" do
    assert_equal 'car', @preference.group
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithActiveRecordGroupTest" do
  before do
    @car = create_car
    @preference = create_preference(:group => @car)
  end

  it "test_should_have_a_group_association" do
    assert_equal @car, @preference.group
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithBooleanTypeTest" do
  before do
    User.preference :notifications, :boolean
  end

  it "test_should_type_cast_nil_values" do
    preference = new_preference(:name => 'notifications', :value => nil)
    assert_nil preference.value
  end

  it "test_should_type_cast_numeric_values" do
    preference = new_preference(:name => 'notifications', :value => 0)
    assert_equal false, preference.value

    preference.value = 1
    assert_equal true, preference.value
  end

  it "test_should_type_cast_boolean_values" do
    preference = new_preference(:name => 'notifications', :value => false)
    assert_equal false, preference.value

    preference.value = true
    assert_equal true, preference.value
  end

  after do
    User.preference_definitions.delete('notifications')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithFloatTypeTest" do
  before do
    User.preference :rate, :float, :default => 10.0
  end

  it "test_should_type_cast_nil_values" do
    preference = new_preference(:name => 'rate', :value => nil)
    assert_nil preference.value
  end

  it "test_should_type_cast_numeric_values" do
    preference = new_preference(:name => 'rate', :value => 1.0)
    assert_equal 1.0, preference.value

    preference.value = "1.1"
    assert_equal 1.1, preference.value
  end

  after do
    User.preference_definitions.delete('rate')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithSTIOwnerTest" do
  before do
    @manager = create_manager
    @preference = create_preference(:owner => @manager, :name => 'health_insurance', :value => true)
  end

  it "test_should_have_an_owner" do
    assert_equal @manager, @preference.owner
  end

  it "test_should_have_an_owner_type" do
    assert_equal 'Employee', @preference.owner_type
  end

  it "test_should_have_a_definition" do
    expect(@preference.definition.nil?).to eq false
  end

  it "test_should_have_a_value" do
    assert_equal true, @preference.value
  end
end
