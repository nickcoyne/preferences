require 'spec_helper'

describe "ModelPreferenceTest" do
  after do
    User.preference_definitions.clear
  end

  #------------------------------------------------------------------------------
  describe "ModelWithoutPreferencesTest" do
    it "test_should_not_create_preference_definitions" do
      expect(!Car.respond_to?(:preference_definitions)).to eq true
    end

    it "test_should_not_create_stored_preferences_association" do
      expect(!Car.new.respond_to?(:stored_preferences)).to eq true
    end

    it "test_should_not_create_preference_scopes" do
      expect(!Car.respond_to?(:with_preferences)).to eq true
      expect(!Car.respond_to?(:without_preferences)).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterFirstBeingDefinedTest" do
    before do
      User.preference :notifications
      @user = build(:user)
    end

    it "test_should_create_preference_definitions" do
      expect(User.respond_to?(:preference_definitions)).to eq true
    end

    it "test_should_create_preference_scopes" do
      expect(User.respond_to?(:with_preferences)).to eq true
      expect(User.respond_to?(:without_preferences)).to eq true
    end

    it "test_should_create_stored_preferences_associations" do
      expect(@user.respond_to?(:stored_preferences)).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterBeingDefinedTest" do
    before do
      @definition = User.preference :notifications
      @user = build(:user)
    end

    it "test_should_raise_exception_if_invalid_options_specified" do
      expect {
        User.preference :notifications, :invalid => true
      }.to raise_error(ArgumentError)
      expect {
        User.preference :notifications, :boolean, :invalid => true
      }.to raise_error(ArgumentError)
    end

    it "test_should_create_definition" do
      expect(@definition.nil?).to eq false
      expect(@definition.name).to eq 'notifications'
    end

    it "test_should_create_preferred_query_method" do
      expect(@user.respond_to?(:preferred_notifications?)).to eq true
    end

    it "test_should_create_prefers_query_method" do
      expect(@user.respond_to?(:prefers_notifications?)).to eq true
    end

    it "test_should_create_preferred_reader" do
      expect(@user.respond_to?(:preferred_notifications)).to eq true
    end

    it "test_should_create_prefers_reader" do
      expect(@user.respond_to?(:prefers_notifications)).to eq true
    end

    it "test_should_create_preferred_writer" do
      expect(@user.respond_to?(:preferred_notifications=)).to eq true
    end

    it "test_should_create_prefers_writer" do
      expect(@user.respond_to?(:prefers_notifications=)).to eq true
    end

    it "test_should_create_preferred_changed_query" do
      expect(@user.respond_to?(:preferred_notifications_changed?)).to eq true
    end

    it "test_should_create_prefers_changed_query" do
      expect(@user.respond_to?(:prefers_notifications_changed?)).to eq true
    end

    it "test_should_create_preferred_was" do
      expect(@user.respond_to?(:preferred_notifications_was)).to eq true
    end

    it "test_should_create_prefers_was" do
      expect(@user.respond_to?(:prefers_notifications_was)).to eq true
    end

    it "test_should_create_preferred_change" do
      expect(@user.respond_to?(:preferred_notifications_change)).to eq true
    end

    it "test_should_create_prefers_change" do
      expect(@user.respond_to?(:prefers_notifications_change)).to eq true
    end

    it "test_should_create_preferred_will_change" do
      expect(@user.respond_to?(:preferred_notifications_will_change!)).to eq true
    end

    it "test_should_create_prefers_will_change" do
      expect(@user.respond_to?(:prefers_notifications_will_change!)).to eq true
    end

    it "test_should_create_preferred_reset" do
      expect(@user.respond_to?(:reset_preferred_notifications!)).to eq true
    end

    it "test_should_create_prefers_reset" do
      expect(@user.respond_to?(:reset_prefers_notifications!)).to eq true
    end

    it "test_should_include_new_definitions_in_preference_definitions" do
      expect(@definition).to eq User.preference_definitions['notifications']
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesTypeCasted" do
    before do
      @definition = User.preference :rate, :float, :default => 1.0
      @user = build(:user)
    end

    it "test_should_have_float_type" do
      expect(@definition.type).to eq :float
    end

    it "test_should_only_have_default_preferences" do
      expect(@user.preferences).to eq ({'rate' => 1.0})
    end

    it "test_should_type_cast_changed_values" do
      @user.write_preference(:rate, "1.1")
      expect(@user.preferences).to eq ({'rate' => 1.1})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesByDefaultTest" do
    before do
      @definition = User.preference :notifications
      @user = build(:user)
    end

    it "test_should_have_boolean_type" do
      expect(@definition.type).to eq :boolean
    end

    it "test_should_not_have_default_value" do
      expect(@definition.default_value).to eq nil
    end

    it "test_should_only_have_default_preferences" do
      expect(@user.preferences).to eq ({'notifications' => nil})
    end

    it "test_should_not_query_preferences_changed" do
      expect(@user.preferences_changed?).to eq false
    end

    it "test_should_not_query_group_preferences_changed" do
      expect(@user.preferences_changed?(:chat)).to eq false
    end

    it "test_should_not_have_preferences_changed" do
      expect(@user.preferences_changed).to eq []
    end

    it "test_should_not_have_group_preferences_changed" do
      expect(@user.preferences_changed(:chat)).to eq []
    end

    it "test_should_not_have_preference_changes" do
      expect(@user.preference_changes).to eq ({})
    end

    it "test_should_not_have_group_preference_changes" do
      expect(@user.preference_changes(:chat)).to eq ({})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithCustomTypeTest" do
    before do
      @definition = User.preference :vehicle_id, :integer
      @user = build(:user)
    end

    it "test_should_have_integer_type" do
      expect(@definition.type).to eq :integer
    end

    it "test_should_not_have_default_value" do
      expect(@definition.default_value).to eq nil
    end

    it "test_should_only_have_default_preferences" do
      expect(@user.preferences).to eq ({'vehicle_id' => nil})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithCustomDefaultTest" do
    before do
      @definition = User.preference :color, :string, :default => 'red'
      @user = build(:user)
    end

    it "test_should_have_boolean_type" do
      expect(@definition.type).to eq :string
    end

    it "test_should_have_default_value" do
      expect(@definition.default_value).to eq 'red'
    end

    it "test_should_only_have_default_preferences" do
      expect(@user.preferences).to eq ({'color' => 'red'})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithMultipleDefinitionsTest" do
    before do
      User.preference_definitions.clear
      User.preference :notifications, :default => true
      User.preference :color, :string, :default => 'red'
      @user = build(:user)
    end

    it "test_should_only_have_default_preferences" do
      expect(@user.preferences).to eq ({'notifications' => true, 'color' => 'red'})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterBeingCreatedTest" do
    before do
      User.preference :notifications, :default => true
      @user = create(:user)
    end

    it "test_should_not_have_any_stored_preferences" do
      expect(@user.stored_preferences.empty?).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesReaderTest" do
    before do
      User.preference :notifications, :default => true
      User.preference :rate, :float, :default => 1.0
      @user = create(:user)
    end

    it "test_should_raise_exception_if_invalid_preference_read" do
      expect {
        @user.preferred(:invalid) 
      }.to raise_error(ArgumentError, 'Unknown preference: invalid')
    end

    it "test_use_default_value_if_not_stored" do
      expect(@user.preferred(:notifications)).to eq true
    end

    it "test_should_use_group_default_value_if_not_stored" do
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
      expect(@user.preferred(:language)).to eq 'English'
    end

    it "test_should_use_stored_value_if_stored" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      expect(@user.preferred(:notifications)).to eq false
    end

    it "test_should_type_cast_based_on_preference_definition" do
      @user.write_preference(:notifications, 'false')
      expect(@user.preferred(:notifications)).to eq false
      @user.write_preference(:rate, "1.2")
      expect(@user.preferred(:rate)).to eq 1.2
    end

    it "test_should_cache_stored_values" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      assert_queries(1) { @user.preferred(:notifications) }
      assert_queries(0) { @user.preferred(:notifications) }
    end

    it "test_should_not_query_if_preferences_already_loaded" do
      @user.preferences
      assert_queries(0) { @user.preferred(:notifications) }
    end

    it "test_should_use_value_from_preferences_lookup" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      @user.preferences

      assert_queries(0) { assert_equal false, @user.preferred(:notifications) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      expect(@user.prefers_notifications).to eq true
    end

    it "test_should_be_able_to_use_preferred_reader" do
      expect(@user.preferred_notifications).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupReaderTest" do
    before do
      User.preference :notifications, :default => true
      @user = create(:user)
    end

    it "test_should_use_default_value_if_not_stored" do
      expect(@user.preferred(:notifications, :chat)).to eq true
    end

    it "test_should_use_group_default_value_if_not_stored" do
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
      expect(@user.preferred(:language, :chat)).to eq 'Latin'
    end

    it "test_should_use_stored_value_if_stored" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      expect(@user.preferred(:notifications, :chat)).to eq false
    end

    it "test_should_cache_stored_values" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      assert_queries(1) { @user.preferred(:notifications, :chat) }
      assert_queries(0) { @user.preferred(:notifications, :chat) }
    end

    it "test_should_not_query_if_preferences_already_loaded" do
      @user.preferences(:chat)
      assert_queries(0) { @user.preferred(:notifications, :chat) }
    end

    it "test_should_use_value_from_preferences_lookup" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      @user.preferences(:chat)

      assert_queries(0) { assert_equal false, @user.preferred(:notifications, :chat) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      expect(@user.prefers_notifications(:chat)).to eq true
    end

    it "test_should_be_able_to_use_preferred_reader" do
      expect(@user.preferred_notifications(:chat)).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupReaderTest" do
    before do
      @car = create(:car)

      User.preference :notifications, :default => true
      @user = create(:user)
    end

    it "test_use_default_value_if_not_stored" do
      expect(@user.preferred(:notifications, @car)).to eq true
    end

    it "test_should_use_stored_value_if_stored" do
      create(:preference, :owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      expect(@user.preferred(:notifications, @car)).to eq false
    end

    it "test_should_use_value_from_preferences_lookup" do
      create(:preference, :owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      @user.preferences(@car)

      assert_queries(0) { assert_equal false, @user.preferred(:notifications, @car) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      expect(@user.prefers_notifications(@car)).to eq true
    end

    it "test_should_be_able_to_use_preferred_reader" do
      expect(@user.preferred_notifications(@car)).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesQueryTest" do
    before do
      User.preference :language, :string
      @user = create(:user)
    end

    it "test_should_raise_exception_if_invalid_preference_queried" do
      expect {
        @user.preferred?(:invalid)
      }.to raise_error(ArgumentError, 'Unknown preference: invalid')
    end

    it "test_should_be_true_if_present" do
      @user.preferred_language = 'English'
      expect(@user.preferred?(:language)).to eq true
    end

    it "test_should_be_false_if_not_present" do
      expect(@user.preferred?(:language)).to eq false
    end

    it "test_should_use_stored_value_if_stored" do
      create(:preference, :owner => @user, :name => 'language', :value => 'English')
      expect(@user.preferred?(:language)).to eq true
    end

    it "test_should_cache_stored_values" do
      create(:preference, :owner => @user, :name => 'language', :value => 'English')
      assert_queries(1) { @user.preferred?(:language) }
      assert_queries(0) { @user.preferred?(:language) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      expect(@user.prefers_language?).to eq false
    end

    it "test_should_be_able_to_use_preferred_reader" do
      expect(@user.preferred_language?).to eq false
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupQueryTest" do
    before do
      User.preference :language, :string
      @user = create(:user)
    end

    it "test_should_be_true_if_present" do
      @user.preferred_language = 'English', :chat
      expect(@user.preferred?(:language, :chat)).to eq true
    end

    it "test_should_be_false_if_not_present" do
      expect(@user.preferred?(:language, :chat)).to eq false
    end

    it "test_should_use_stored_value_if_stored" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'language', :value => 'English')
      expect(@user.preferred?(:language, :chat)).to eq true
    end

    it "test_should_cache_stored_values" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'language', :value => 'English')
      assert_queries(1) { @user.preferred?(:language, :chat) }
      assert_queries(0) { @user.preferred?(:language, :chat) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      expect(@user.prefers_language?(:chat)).to eq false
    end

    it "test_should_be_able_to_use_preferred_reader" do
      expect(@user.preferred_language?(:chat)).to eq false
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupQueryTest" do
    before do
      @car = create(:car)

      User.preference :language, :string
      @user = create(:user)
    end

    it "test_should_be_true_if_present" do
      @user.preferred_language = 'English', @car
      expect(@user.preferred?(:language, @car)).to eq true
    end

    it "test_should_be_false_if_not_present" do
      expect(@user.preferred?(:language, @car)).to eq false
    end

    it "test_should_use_stored_value_if_stored" do
      create(:preference, :owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'language', :value => 'English')
      expect(@user.preferred?(:language, @car)).to eq true
    end

    it "test_should_be_able_to_use_prefers_reader" do
      expect(@user.prefers_language?(@car)).to eq false
    end

    it "test_should_be_able_to_use_preferred_reader" do
      expect(@user.preferred_language?(@car)).to eq false
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWriterTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create(:user, :login => 'admin')
    end

    it "test_should_raise_exception_if_invalid_preference_written" do
      expect {
        @user.write_preference(:invalid, true)
      }.to raise_error(ArgumentError, 'Unknown preference: invalid')
    end

    it "test_should_have_same_value_if_not_changed" do
      @user.write_preference(:notifications, true)
      expect(@user.preferred(:notifications)).to eq true
    end

    it "test_should_use_new_value_if_changed" do
      @user.write_preference(:notifications, false)
      expect(@user.preferred(:notifications)).to eq false
    end

    it "test_should_not_save_record_after_changing_preference" do
      @user.login = 'test'
      @user.write_preference(:notifications, false)

      expect(User.find(@user.id).login).to eq 'admin'
    end

    it "test_should_not_create_stored_preferences_immediately" do
      @user.write_preference(:notifications, false)
      expect(@user.stored_preferences.empty?).to eq true
    end

    it "test_should_not_create_stored_preference_if_value_not_changed" do
      @user.write_preference(:notifications, true)
      @user.save!

      expect(@user.stored_preferences.count).to eq 0
    end

    it "test_should_not_create_stored_integer_preference_if_typecast_not_changed" do
      User.preference :age, :integer

      @user.write_preference(:age, '')
      @user.save!

      expect(@user.stored_preferences.count).to eq 0
    end

    it "test_should_create_stored_integer_preference_if_typecast_changed" do
      User.preference :age, :integer, :default => 0

      @user.write_preference(:age, '')
      @user.save!

      expect(@user.preferred(:age)).to eq nil
      expect(@user.stored_preferences.count).to eq 1
    end

    it "test_should_create_stored_preference_if_value_changed" do
      @user.write_preference(:notifications, false)
      @user.save!

      expect(@user.stored_preferences.count).to eq 1
    end

    it "test_should_overwrite_existing_stored_preference_if_value_changed" do
      preference = create(:preference, :owner => @user, :name => 'notifications', :value => true)

      @user.write_preference(:notifications, false)
      @user.save!

      preference.reload
      expect(preference.value).to eq false
    end

    it "test_should_not_remove_preference_if_set_to_default" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)

      @user.write_preference(:notifications, true)
      @user.save!
      @user.reload

      expect(@user.stored_preferences.size).to eq 1
      preference = @user.stored_preferences.first
      expect(preference.value).to eq true
    end

    it "test_should_not_remove_preference_if_set_to_nil" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)

      @user.write_preference(:notifications, nil)
      @user.save!
      @user.reload

      expect(@user.stored_preferences.size).to eq 1
      preference = @user.stored_preferences.first
      expect(preference.value).to eq nil
    end

    it "test_should_not_query_for_old_value_if_preferences_loaded" do
      @user.preferences

      assert_queries(0) { @user.write_preference(:notifications, false) }
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupWriterTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create(:user, :login => 'admin')
    end

    it "test_should_have_same_value_if_not_changed" do
      @user.write_preference(:notifications, true, :chat)
      expect(@user.preferred(:notifications, :chat)).to eq true
    end

    it "test_should_use_new_value_if_changed" do
      @user.write_preference(:notifications, false, :chat)
      expect(@user.preferred(:notifications, :chat)).to eq false
    end

    it "test_should_not_create_stored_preference_if_value_not_changed" do
      @user.write_preference(:notifications, true, :chat)
      @user.save!

      expect(@user.stored_preferences.count).to eq 0
    end

    it "test_should_create_stored_preference_if_value_changed" do
      @user.write_preference(:notifications, false, :chat)
      @user.save!

      expect(@user.stored_preferences.count).to eq 1
    end

    it "test_should_set_group_attributes_on_stored_preferences" do
      @user.write_preference(:notifications, false, :chat)
      @user.save!

      preference = @user.stored_preferences.first
      expect(preference.group_type).to eq 'chat'
      expect(preference.group_id).to eq nil
    end

    it "test_should_overwrite_existing_stored_preference_if_value_changed" do
      preference = create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => true)

      @user.write_preference(:notifications, false, :chat)
      @user.save!

      preference.reload
      expect(preference.value).to eq false
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupWriterTest" do
    before do
      @car = create(:car)

      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create(:user, :login => 'admin')
    end

    it "test_should_have_same_value_if_not_changed" do
      @user.write_preference(:notifications, true, @car)
      expect(@user.preferred(:notifications, @car)).to eq true
    end

    it "test_should_use_new_value_if_changed" do
      @user.write_preference(:notifications, false, @car)
      expect(@user.preferred(:notifications, @car)).to eq false
    end

    it "test_should_not_create_stored_preference_if_value_not_changed" do
      @user.write_preference(:notifications, true, @car)
      @user.save!

      expect(@user.stored_preferences.count).to eq 0
    end

    it "test_should_create_stored_preference_if_value_changed" do
      @user.write_preference(:notifications, false, @car)
      @user.save!

      expect(@user.stored_preferences.count).to eq 1
    end

    it "test_should_set_group_attributes_on_stored_preferences" do
      @user.write_preference(:notifications, false, @car)
      @user.save!

      preference = @user.stored_preferences.first
      expect(preference.group_type).to eq 'Car'
      expect(preference.group_id).to eq @car.id
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterChangingPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create(:user)

      @user.write_preference(:notifications, false)
    end

    it "test_should_query_preferences_changed" do
      expect(@user.preferences_changed?).to eq true
    end

    it "test_should_query_preference_changed" do
      expect(@user.prefers_notifications_changed?).to eq true
    end

    it "test_should_not_query_preferences_changed_for_group" do
      expect(@user.preferences_changed?(:chat)).to eq false
    end

    it "test_should_not_query_preference_changed_for_group" do
      expect(@user.prefers_notifications_changed?(:chat)).to eq false
    end

    it "test_should_have_preferences_changed" do
      expect(@user.preferences_changed).to eq ['notifications']
    end

    it "test_should_not_build_same_preferences_changed_result" do
      expect(@user.preferences_changed).to_not be @user.preferences_changed
    end

    it "test_should_not_have_preferences_changed_for_group" do
      expect(@user.preferences_changed(:chat)).to eq []
    end

    it "test_should_track_multiple_preferences_changed" do
      @user.write_preference(:language, 'Latin')
      expect(@user.preferences_changed.sort).to eq ['language', 'notifications']
    end

    it "test_should_have_preference_changes" do
      expect(@user.preference_changes).to eq ({'notifications' => [true, false]})
    end

    it "test_should_not_build_same_preference_changes_result" do
      expect(@user.preference_changes).to_not be @user.preference_changes
    end

    it "test_should_have_preference_change" do
      expect(@user.prefers_notifications_change).to eq [true, false]
    end

    it "test_should_have_preference_was" do
      expect(@user.prefers_notifications_was).to eq true
    end

    it "test_should_not_have_preference_changes_for_group" do
      expect(@user.preference_changes(:chat)).to eq ({})
    end

    it "test_should_not_have_preference_change_for_group" do
      expect(@user.prefers_notifications_change(:chat)).to eq nil
    end

    it "test_should_have_preference_was_for_group" do
      expect(@user.prefers_notifications_was(:chat)).to eq true
    end

    it "test_should_use_latest_value_for_preference_changes" do
      @user.write_preference(:notifications, nil)
      expect(@user.preference_changes).to eq ({'notifications' => [true, nil]})
    end

    it "test_should_use_cloned_old_value_for_preference_changes" do
      old_value = @user.preferred(:language)
      @user.write_preference(:language, 'Latin')

      tracked_old_value = @user.preference_changes['language'][0]
      expect(tracked_old_value).to eq old_value
      expect(old_value).to_not be tracked_old_value
    end

    it "test_should_track_multiple_preference_changes" do
      @user.write_preference(:language, 'Latin')
      expect(@user.preference_changes).to eq ({'notifications' => [true, false], 'language' => ['English', 'Latin']})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterChangingGroupPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create(:user)

      @user.write_preference(:notifications, false, :chat)
    end

    it "test_should_not_query_preferences_changed" do
      expect(@user.preferences_changed?).to eq false
    end

    it "test_not_should_query_preference_changed" do
      expect(@user.prefers_notifications_changed?).to eq false
    end

    it "test_should_query_preferences_changed_for_group" do
      expect(@user.preferences_changed?(:chat)).to eq true
    end

    it "test_should_query_preference_changed_for_group" do
      expect(@user.prefers_notifications_changed?(:chat)).to eq true
    end

    it "test_should_have_preferences_changed" do
      expect(@user.preferences_changed).to eq []
    end

    it "test_should_not_have_preferences_changed_for_group" do
      expect(@user.preferences_changed(:chat)).to eq ['notifications']
    end

    it "test_should_have_preference_changes" do
      expect(@user.preference_changes).to eq ({})
    end

    it "test_should_not_have_preference_change" do
      expect(@user.prefers_notifications_change).to eq nil
    end

    it "test_should_have_preference_was" do
      expect(@user.prefers_notifications_was).to eq true
    end

    it "test_should_not_have_preference_changes_for_group" do
      expect(@user.preference_changes(:chat)).to eq ({'notifications' => [true, false]})
    end

    it "test_should_have_preference_change_for_group" do
      expect(@user.prefers_notifications_change(:chat)).to eq [true, false]
    end

    it "test_should_have_preference_was_for_group" do
      expect(@user.prefers_notifications_was(:chat)).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterRevertPreferenceChangeTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create(:user)
      @user.write_preference(:notifications, false)
      @user.write_preference(:notifications, true)
    end

    it "test_should_not_query_preferences_changed" do
      expect(@user.preferences_changed?).to eq false
    end

    it "test_should_not_have_preferences_changed" do
      expect(@user.preferences_changed).to eq []
    end

    it "test_should_not_have_preference_changes" do
      expect(@user.preference_changes).to eq ({})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterForcingChangeTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create(:user)
      @user.prefers_notifications_will_change!
      @user.save
    end

    it "test_should_store_preference" do
      expect(@user.stored_preferences.count).to eq 1

      preference = @user.stored_preferences.first
      expect(preference.group_type).to eq nil
      expect(preference.group_id).to eq nil
      expect(preference.value).to eq true
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterForcingChangeForGroupTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create(:user)
      @user.prefers_notifications_will_change!(:chat)
      @user.save
    end

    it "test_should_store_preference" do
      expect(@user.stored_preferences.count).to eq 1

      preference = @user.stored_preferences.first
      expect(preference.group_type).to eq 'chat'
      expect(preference.group_id).to eq nil
      expect(preference.value).to eq true
    end

    it "test_should_use_cloned_value_for_tracking_old_value" do
      old_value = @user.preferred(:language)
      @user.preferred_language_will_change!

      tracked_old_value = @user.preferred_language_was
      expect(tracked_old_value).to eq old_value
      expect(old_value).to_not be tracked_old_value
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterResettingPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create(:user)
      @user.write_preference(:notifications, false)
      @user.write_preference(:notifications, false, :chat)
      @user.reset_prefers_notifications!
    end

    it "test_should_revert_to_original_value" do
      expect(@user.preferred(:notifications)).to eq true
    end

    it "test_should_not_reset_groups" do
      expect(@user.preferred(:notifications, :chat)).to eq false
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterResettingPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create(:user)
      @user.write_preference(:notifications, false)
      @user.write_preference(:notifications, false, :chat)
      @user.reset_prefers_notifications!(:chat)
    end

    it "test_should_revert_to_original_value" do
      expect(@user.preferred(:notifications, :chat)).to eq true
    end

    it "test_should_not_reset_default_group" do
      expect(@user.preferred(:notifications)).to eq false
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesLookupTest" do
    before do
      User.preference_definitions.clear
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}

      @user = create(:user)
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      expect(@user.preferences).to eq ({'notifications' => true, 'language' => 'English'})
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false)
      expect(@user.preferences).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      expect(@user.preferences).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Latin')
      expect(@user.preferences).to eq ({'notifications' => false, 'language' => 'Latin'})
    end

    it "test_should_use_unsaved_changes_over_stored_preferences" do
      create(:preference, :owner => @user, :name => 'notifications', :value => true)
      @user.write_preference(:notifications, false)
      expect(@user.preferences).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_typecast_unsaved_changes" do
      @user.write_preference(:notifications, 'true')
      expect(@user.preferences).to eq ({'notifications' => true, 'language' => 'English'})
    end

    it "test_should_cache_results" do
      assert_queries(1) { @user.preferences }
      assert_queries(0) { @user.preferences }
    end

    it "test_should_not_query_if_stored_preferences_eager_loaded" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      user = User.includes(:stored_preferences).where(id: @user.id).first
      assert_queries(0) do
        expect(user.preferences).to eq ({'notifications' => false, 'language' => 'English'})
      end
    end

    it "test_should_not_generate_same_object_twice" do
      expect(@user.preferences).to_not be @user.preferences
    end

    it "test_should_use_preferences_for_prefs" do
      expect(@user.prefs).to eq @user.preferences
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupLookupTest" do
    before do
      User.preference_definitions.clear
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}

      @user = create(:user)
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      expect(@user.preferences(:chat)).to eq ({'notifications' => true, 'language' => 'Latin'})
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false, :chat)
      expect(@user.preferences(:chat)).to eq ({'notifications' => false, 'language' => 'Latin'})
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      expect(@user.preferences(:chat)).to eq ({'notifications' => false, 'language' => 'Latin'})
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Spanish', :chat)
      expect(@user.preferences(:chat)).to eq ({'notifications' => false, 'language' => 'Spanish'})
    end

    it "test_should_typecast_unsaved_changes" do
      @user.write_preference(:notifications, 'true', :chat)
      expect(@user.preferences).to eq ({'notifications' => true, 'language' => 'English'})
    end

    it "test_should_cache_results" do
      assert_queries(1) { @user.preferences(:chat) }
      assert_queries(0) { @user.preferences(:chat) }
    end

    it "test_should_not_query_if_all_preferences_individually_loaded" do
      @user.preferred(:notifications, :chat)
      @user.preferred(:language, :chat)

      assert_queries(0) { @user.preferences(:chat) }
    end

    it "test_should_not_generate_same_object_twice" do
      expect(@user.preferences(:chat)).to_not be @user.preferences(:chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupLookupTest" do
    before do
      @car = create(:car)

      User.preference_definitions.clear
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create(:user)
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      expect(@user.preferences(@car)).to eq ({'notifications' => true, 'language' => 'English'})
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false, @car)
      expect(@user.preferences(@car)).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create(:preference, :owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      expect(@user.preferences(@car)).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create(:preference, :owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Latin', @car)
      expect(@user.preferences(@car)).to eq ({'notifications' => false, 'language' => 'Latin'})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesNilGroupLookupTest" do
    before do
      @car = create(:car)

      User.preference_definitions.clear
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create(:user)
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      expect(@user.preferences(nil)).to eq ({'notifications' => true, 'language' => 'English'})
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false)
      expect(@user.preferences(nil)).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      expect(@user.preferences(nil)).to eq ({'notifications' => false, 'language' => 'English'})
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create(:preference, :owner => @user, :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Latin')
      expect(@user.preferences(nil)).to eq ({'notifications' => false, 'language' => 'Latin'})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesLookupWithGroupsTest" do
    before do
      User.preference_definitions.clear
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create(:user)
      create(:preference, :owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    end

    it "test_not_include_group_preferences_by_default" do
      expect(@user.preferences).to eq ({'notifications' => true, 'language' => 'English'})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterBeingReloadedTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create(:user)
      @user.write_preference(:notifications, false)
      @user.reload
    end

    it "test_should_reset_unsaved_preferences" do
      expect(@user.preferred(:notifications)).to eq true
    end

    it "test_should_not_save_reset_preferences" do
      @user.save!
      expect(@user.stored_preferences.empty?).to eq true
    end

    it "test_should_reset_preferences" do
      expect(@user.preferences).to eq ({'notifications' => true})
    end

    it "test_should_clear_query_cache_for_preferences" do
      assert_queries(1) { @user.preferences }
    end

    it "test_should_reset_preferences_changed_query" do
      expect(@user.preferences_changed?).to eq false
    end

    it "test_should_reset_preferences_changed" do
      expect(@user.preferences_changed).to eq []
    end

    it "test_should_reset_preference_changes" do
      expect(@user.preference_changes).to eq ({})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesForGroupAfterBeingReloadedTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create(:user)
      @user.write_preference(:notifications, false, :chat)
      @user.reload
    end

    it "test_should_reset_unsaved_preferences" do
      expect(@user.preferred(:notifications, :chat)).to eq true
    end

    it "test_should_reset_preferences" do
      expect(@user.preferences(:chat)).to eq ({'notifications' => true})
    end

    it "test_should_clear_query_cache_for_preferences" do
      assert_queries(1) { @user.preferences(:chat) }
    end

    it "test_should_reset_preferences_changed_query" do
      expect(@user.preferences_changed?(:chat)).to eq false
    end

    it "test_should_reset_preferences_changed" do
      expect(@user.preferences_changed(:chat)).to eq []
    end

    it "test_should_reset_preference_changes" do
      expect(@user.preference_changes(:chat)).to eq ({})
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithScopeTest" do
    before do
      User.preference :notifications
      User.preference :language, :string, :default => 'English'
      User.preference :color, :string, :default => 'red'

      @user = create(:user)
      @customized_user = create(:user,:login => 'customized',
        :prefers_notifications => false,
        :preferred_language => 'Latin'
      )
      @customized_user.prefers_notifications = false, :chat
      @customized_user.preferred_language = 'Latin', :chat
      @customized_user.save!
    end

    it "test_should_not_find_if_no_preference_matched" do
      expect(User.with_preferences(:language => 'Italian')).to eq []
    end

    it "test_should_find_with_null_preference" do
      expect(User.with_preferences(:notifications => nil)).to eq [@user]
    end

    it "test_should_find_with_default_preference" do
      expect(User.with_preferences(:language => 'English')).to eq [@user]
    end

    it "test_should_find_with_multiple_default_preferences" do
      expect(User.with_preferences(:notifications => nil, :language => 'English')).to eq [@user]
    end

    it "test_should_find_with_custom_preference" do
      expect(User.with_preferences(:language => 'Latin')).to eq [@customized_user]
    end

    it "test_should_find_with_multiple_custom_preferences" do
      expect(User.with_preferences(:notifications => false, :language => 'Latin')).to eq [@customized_user]
    end

    it "test_should_find_with_mixed_default_and_custom_preferences" do
      expect(User.with_preferences(:color => 'red', :language => 'Latin')).to eq [@customized_user]
    end

    it "test_should_find_with_default_group_preference" do
      expect(User.with_preferences(:chat => {:language => 'English'})).to eq [@user]
    end

    it "test_should_find_with_customized_default_group_preference" do
      User.preference :country, :string, :default => 'US', :group_defaults => {:chat => 'UK'}
      @customized_user.preferred_country = 'US', :chat
      @customized_user.save!

      expect(User.with_preferences(:chat => {:country => 'UK'})).to eq [@user]
    end

    it "test_should_find_with_multiple_default_group_preferences" do
      expect(User.with_preferences(:chat => {:notifications => nil, :language => 'English'})).to eq [@user]
    end

    it "test_should_find_with_custom_group_preference" do
      expect(User.with_preferences(:chat => {:language => 'Latin'})).to eq [@customized_user]
    end

    it "test_should_find_with_multiple_custom_group_preferences" do
      expect(User.with_preferences(:chat => {:notifications => false, :language => 'Latin'})).to eq [@customized_user]
    end

    it "test_should_find_with_mixed_default_and_custom_group_preferences" do
      expect(User.with_preferences(:chat => {:color => 'red', :language => 'Latin'})).to eq [@customized_user]
    end

    it "test_should_find_with_mixed_basic_and_group_preferences" do
      @customized_user.preferred_language = 'English'
      @customized_user.save!

      expect(User.with_preferences(:language => 'English', :chat => {:language => 'Latin'})).to eq [@customized_user]
    end

    it "test_should_allow_chaining" do
      expect(User.with_preferences(:language => 'English').with_preferences(:color => 'red')).to eq [@user]
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithoutScopeTest" do
    before do
      User.preference :notifications
      User.preference :language, :string, :default => 'English'
      User.preference :color, :string, :default => 'red'

      @user = create(:user)
      @customized_user = create(:user, :login => 'customized',
        :prefers_notifications => false,
        :preferred_language => 'Latin'
      )
      @customized_user.prefers_notifications = false, :chat
      @customized_user.preferred_language = 'Latin', :chat
      @customized_user.save!
    end

    it "test_should_not_find_if_no_preference_matched" do
      expect(User.without_preferences(:color => 'red')).to eq []
    end

    it "test_should_find_with_null_preference" do
      expect(User.without_preferences(:notifications => false)).to eq [@user]
    end

    it "test_should_find_with_default_preference" do
      expect(User.without_preferences(:language => 'Latin')).to eq [@user]
    end

    it "test_should_find_with_multiple_default_preferences" do
      expect(User.without_preferences(:language => 'Latin', :notifications => false)).to eq [@user]
    end

    it "test_should_find_with_custom_preference" do
      expect(User.without_preferences(:language => 'English')).to eq [@customized_user]
    end

    it "test_should_find_with_multiple_custom_preferences" do
      expect(User.without_preferences(:language => 'English', :notifications => nil)).to eq [@customized_user]
    end

    it "test_should_find_with_mixed_default_and_custom_preferences" do
      expect(User.without_preferences(:language => 'English', :color => 'blue')).to eq [@customized_user]
    end

    it "test_should_find_with_default_group_preference" do
      expect(User.without_preferences(:chat => {:language => 'Latin'})).to eq [@user]
    end

    it "test_should_find_with_customized_default_group_preference" do
      User.preference :country, :string, :default => 'US', :group_defaults => {:chat => 'UK'}
      @customized_user.preferred_country = 'US', :chat
      @customized_user.save!

      expect(User.without_preferences(:chat => {:country => 'US'})).to eq [@user]
    end

    it "test_should_find_with_multiple_default_group_preferences" do
      expect(User.without_preferences(:chat => {:language => 'Latin', :notifications => false})).to eq [@user]
    end

    it "test_should_find_with_custom_group_preference" do
      expect(User.without_preferences(:chat => {:language => 'English'})).to eq [@customized_user]
    end

    it "test_should_find_with_multiple_custom_group_preferences" do
      expect(User.without_preferences(:chat => {:language => 'English', :notifications => nil})).to eq [@customized_user]
    end

    it "test_should_find_with_mixed_default_and_custom_group_preferences" do
      expect(User.without_preferences(:chat => {:language => 'English', :color => 'blue'})).to eq [@customized_user]
    end

    it "test_should_find_with_mixed_basic_and_group_preferences" do
      @customized_user.preferred_language = 'English'
      @customized_user.save!

      expect(User.without_preferences(:language => 'Latin', :chat => {:language => 'English'})).to eq [@customized_user]
    end

    it "test_should_allow_chaining" do
      expect(User.without_preferences(:language => 'Latin').without_preferences(:color => 'blue')).to eq [@user]
    end
  end
end