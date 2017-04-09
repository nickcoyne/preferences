require 'spec_helper'

# include Factory

#------------------------------------------------------------------------------
describe "PreferenceByDefaultTest" do
  before do
    @preference = Preference.new
  end

  it "test_should_not_have_a_name" do
    expect(@preference.name.blank?).to eq true
  end

  it "test_should_not_have_an_owner" do
    expect(@preference.owner_id).to eq nil
  end

  it "test_should_not_have_an_owner_type" do
    expect(@preference.owner_type.blank?).to eq true
  end

  it "test_should_not_have_a_group_association" do
    expect(@preference.group_id).to eq nil
  end

  it "test_should_not_have_a_group_type" do
    expect(@preference.group_type.nil?).to eq true
  end

  it "test_should_not_have_a_value" do
    expect(@preference.value.blank?).to eq true
  end

  it "test_should_not_have_a_definition" do
    expect(@preference.definition).to eq nil
  end
end

#------------------------------------------------------------------------------
describe "PreferenceTest" do
  
  it "test_should_be_valid_with_a_set_of_valid_attributes" do
    preference = build(:preference)
    expect(preference.valid?).to eq true
  end

  it "test_should_require_a_name" do
    preference = build(:preference, :name => nil)
    expect(preference.valid?).to eq false
    expect(preference.errors.include?(:name)).to eq true
  end

  it "test_should_require_an_owner_id" do
    preference = build(:preference, :owner => nil)
    expect(preference.valid?).to eq false
    expect(preference.errors.include?(:owner_id)).to eq true
  end

  it "test_should_require_an_owner_type" do
    preference = build(:preference, :owner => nil)
    expect(preference.valid?).to eq false
    expect(preference.errors.include?(:owner_type)).to eq true
  end

  it "test_should_not_require_a_group_id" do
    preference = build(:preference, :group => nil)
    expect(preference.valid?).to eq true
  end

  it "test_should_not_require_a_group_id_if_type_specified" do
    preference = build(:preference, :group => nil)
    preference.group_type = 'Car'
    expect(preference.valid?).to eq true
  end

  it "test_should_not_require_a_group_type" do
    preference = build(:preference, :group => nil)
    expect(preference.valid?).to eq true
  end

  it "test_should_require_a_group_type_if_id_specified" do
    preference = build(:preference, :group => nil)
    preference.group_id = 1
    expect(preference.valid?).to eq false
    expect(preference.errors.include?(:group_type)).to eq true
  end
end

#------------------------------------------------------------------------------
describe "PreferenceAsAClassTest" do
  it "test_should_be_able_to_split_nil_groups" do
    group_id, group_type = Preference.split_group(nil)
    expect(group_id).to be_nil
    expect(group_type).to be_nil
  end

  it "test_should_be_able_to_split_non_active_record_groups" do
    group_id, group_type = Preference.split_group('car')
    expect(group_id).to be_nil
    expect(group_type).to eq 'car'

    group_id, group_type = Preference.split_group(:car)
    expect(group_id).to be_nil
    expect(group_type).to eq 'car'

    group_id, group_type = Preference.split_group(10)
    expect(group_id).to be_nil
    expect(group_type).to eq 10
  end

  it "test_should_be_able_to_split_active_record_groups" do
    car = create(:car)

    group_id, group_type = Preference.split_group(car)
    expect(group_id).to eq 1
    expect(group_type).to eq 'Car'
  end
end

#------------------------------------------------------------------------------
describe "PreferenceAfterBeingCreatedTest" do
  before do
    User.preference :notifications, :boolean

    @preference = create(:preference, :name => 'notifications')
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
    expect(@preference.group).to be_nil
  end

  after do
    User.preference_definitions.delete('notifications')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithBasicGroupTest" do
  before do
    @preference = create(:preference, :group_type => 'car')
  end

  it "test_should_have_a_group_association" do
    expect(@preference.group).to eq 'car'
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithActiveRecordGroupTest" do
  before do
    @car = create(:car)
    @preference = create(:preference, :group => @car)
  end

  it "test_should_have_a_group_association" do
    expect(@preference.group).to eq @car
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithBooleanTypeTest" do
  before do
    User.preference :notifications, :boolean
  end

  it "test_should_type_cast_nil_values" do
    preference = build(:preference, :name => 'notifications', :value => nil)
    expect(preference.value).to be_nil
  end

  it "test_should_type_cast_numeric_values" do
    preference = build(:preference, :name => 'notifications', :value => 0)
    expect(preference.value).to eq false

    preference.value = 1
    expect(preference.value).to eq true
  end

  it "test_should_type_cast_boolean_values" do
    preference = build(:preference, :name => 'notifications', :value => false)
    expect(preference.value).to eq false

    preference.value = true
    expect(preference.value).to eq true
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
    preference = build(:preference, :name => 'rate', :value => nil)
    expect(preference.value).to be_nil
  end

  it "test_should_type_cast_numeric_values" do
    preference = build(:preference, :name => 'rate', :value => 1.0)
    expect(preference.value).to eq 1.0

    preference.value = "1.1"
    expect(preference.value).to eq 1.1
  end

  after do
    User.preference_definitions.delete('rate')
  end
end

#------------------------------------------------------------------------------
describe "PreferenceWithSTIOwnerTest" do
  before do
    @manager = create(:manager)
    @preference = create(:preference, :owner => @manager, :name => 'health_insurance', :value => true)
  end

  it "test_should_have_an_owner" do
    expect(@preference.owner).to eq @manager
  end

  it "test_should_have_an_owner_type" do
    expect(@preference.owner_type).to eq 'Employee'
  end

  it "test_should_have_a_definition" do
    expect(@preference.definition.nil?).to eq false
  end

  it "test_should_have_a_value" do
    expect(@preference.value).to eq true
  end
end
