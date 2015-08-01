require 'spec_helper'

describe "ModelPreferenceTest" do
  after do
    User.preference_definitions.clear
  end

  #------------------------------------------------------------------------------
  describe "ModelWithoutPreferencesTest" do
    it "test_should_not_create_preference_definitions" do
      assert !Car.respond_to?(:preference_definitions)
    end

    it "test_should_not_create_stored_preferences_association" do
      assert !Car.new.respond_to?(:stored_preferences)
    end

    it "test_should_not_create_preference_scopes" do
      assert !Car.respond_to?(:with_preferences)
      assert !Car.respond_to?(:without_preferences)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterFirstBeingDefinedTest" do
    before do
      User.preference :notifications
      @user = new_user
    end

    it "test_should_create_preference_definitions" do
      assert User.respond_to?(:preference_definitions)
    end

    it "test_should_create_preference_scopes" do
      assert User.respond_to?(:with_preferences)
      assert User.respond_to?(:without_preferences)
    end

    it "test_should_create_stored_preferences_associations" do
      assert @user.respond_to?(:stored_preferences)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterBeingDefinedTest" do
    before do
      @definition = User.preference :notifications
      @user = new_user
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
      assert_equal 'notifications', @definition.name
    end

    it "test_should_create_preferred_query_method" do
      assert @user.respond_to?(:preferred_notifications?)
    end

    it "test_should_create_prefers_query_method" do
      assert @user.respond_to?(:prefers_notifications?)
    end

    it "test_should_create_preferred_reader" do
      assert @user.respond_to?(:preferred_notifications)
    end

    it "test_should_create_prefers_reader" do
      assert @user.respond_to?(:prefers_notifications)
    end

    it "test_should_create_preferred_writer" do
      assert @user.respond_to?(:preferred_notifications=)
    end

    it "test_should_create_prefers_writer" do
      assert @user.respond_to?(:prefers_notifications=)
    end

    it "test_should_create_preferred_changed_query" do
      assert @user.respond_to?(:preferred_notifications_changed?)
    end

    it "test_should_create_prefers_changed_query" do
      assert @user.respond_to?(:prefers_notifications_changed?)
    end

    it "test_should_create_preferred_was" do
      assert @user.respond_to?(:preferred_notifications_was)
    end

    it "test_should_create_prefers_was" do
      assert @user.respond_to?(:prefers_notifications_was)
    end

    it "test_should_create_preferred_change" do
      assert @user.respond_to?(:preferred_notifications_change)
    end

    it "test_should_create_prefers_change" do
      assert @user.respond_to?(:prefers_notifications_change)
    end

    it "test_should_create_preferred_will_change" do
      assert @user.respond_to?(:preferred_notifications_will_change!)
    end

    it "test_should_create_prefers_will_change" do
      assert @user.respond_to?(:prefers_notifications_will_change!)
    end

    it "test_should_create_preferred_reset" do
      assert @user.respond_to?(:reset_preferred_notifications!)
    end

    it "test_should_create_prefers_reset" do
      assert @user.respond_to?(:reset_prefers_notifications!)
    end

    it "test_should_include_new_definitions_in_preference_definitions" do
      assert_equal User.preference_definitions['notifications'], @definition
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesTypeCasted" do
    before do
      @definition = User.preference :rate, :float, :default => 1.0
      @user = new_user
    end

    it "test_should_have_float_type" do
      assert_equal :float, @definition.type
    end

    it "test_should_only_have_default_preferences" do
      assert_equal e = {'rate' => 1.0}, @user.preferences
    end

    it "test_should_type_cast_changed_values" do
      @user.write_preference(:rate, "1.1")
      assert_equal e = {'rate' => 1.1}, @user.preferences
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesByDefaultTest" do
    before do
      include Factory

      @definition = User.preference :notifications
      @user = new_user
    end

    it "test_should_have_boolean_type" do
      assert_equal :boolean, @definition.type
    end

    it "test_should_not_have_default_value" do
      assert_nil @definition.default_value
    end

    it "test_should_only_have_default_preferences" do
      # assert_equal e = {'notifications' => nil}, @user.preferences
      assert_equal e = {'notifications' => nil}, @user.preferences
    end

    it "test_should_not_query_preferences_changed" do
      assert_equal false, @user.preferences_changed?
    end

    it "test_should_not_query_group_preferences_changed" do
      assert_equal false, @user.preferences_changed?(:chat)
    end

    it "test_should_not_have_preferences_changed" do
      assert_equal [], @user.preferences_changed
    end

    it "test_should_not_have_group_preferences_changed" do
      assert_equal [], @user.preferences_changed(:chat)
    end

    it "test_should_not_have_preference_changes" do
      assert_equal e = {}, @user.preference_changes
    end

    it "test_should_not_have_group_preference_changes" do
      assert_equal e = {}, @user.preference_changes(:chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithCustomTypeTest" do
    before do
      @definition = User.preference :vehicle_id, :integer
      @user = new_user
    end

    it "test_should_have_integer_type" do
      assert_equal :integer, @definition.type
    end

    it "test_should_not_have_default_value" do
      assert_nil @definition.default_value
    end

    it "test_should_only_have_default_preferences" do
      assert_equal e = {'vehicle_id' => nil}, @user.preferences
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithCustomDefaultTest" do
    before do
      @definition = User.preference :color, :string, :default => 'red'
      @user = new_user
    end

    it "test_should_have_boolean_type" do
      assert_equal :string, @definition.type
    end

    it "test_should_have_default_value" do
      assert_equal 'red', @definition.default_value
    end

    it "test_should_only_have_default_preferences" do
      assert_equal e = {'color' => 'red'}, @user.preferences
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithMultipleDefinitionsTest" do
    before do
      User.preference :notifications, :default => true
      User.preference :color, :string, :default => 'red'
      @user = new_user
    end

    it "test_should_only_have_default_preferences" do
      assert_equal e = {'notifications' => true, 'color' => 'red'}, @user.preferences
    end
  end

#------------------------------------------------------------------------------
  describe "PreferencesAfterBeingCreatedTest" do
    before do
      User.preference :notifications, :default => true
      @user = create_user
    end

    it "test_should_not_have_any_stored_preferences" do
      assert @user.stored_preferences.empty?
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesReaderTest" do
    before do
      User.preference :notifications, :default => true
      User.preference :rate, :float, :default => 1.0
      @user = create_user
    end

    it "test_should_raise_exception_if_invalid_preference_read" do
      expect {
        @user.preferred(:invalid) 
      }.to raise_error(ArgumentError, 'Unknown preference: invalid')
    end

    it "test_use_default_value_if_not_stored" do
      assert_equal true, @user.preferred(:notifications)
    end

    it "test_should_use_group_default_value_if_not_stored" do
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
      assert_equal 'English', @user.preferred(:language)
    end

    it "test_should_use_stored_value_if_stored" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      assert_equal false, @user.preferred(:notifications)
    end

    it "test_should_type_cast_based_on_preference_definition" do
      @user.write_preference(:notifications, 'false')
      assert_equal false, @user.preferred(:notifications)
      @user.write_preference(:rate, "1.2")
      assert_equal 1.2, @user.preferred(:rate)
    end

    it "test_should_cache_stored_values" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      assert_queries(1) { @user.preferred(:notifications) }
      assert_queries(0) { @user.preferred(:notifications) }
    end

    it "test_should_not_query_if_preferences_already_loaded" do
      @user.preferences
      assert_queries(0) { @user.preferred(:notifications) }
    end

    it "test_should_use_value_from_preferences_lookup" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      @user.preferences

      assert_queries(0) { assert_equal false, @user.preferred(:notifications) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      assert_equal true, @user.prefers_notifications
    end

    it "test_should_be_able_to_use_preferred_reader" do
      assert_equal true, @user.preferred_notifications
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupReaderTest" do
    before do
      User.preference :notifications, :default => true
      @user = create_user
    end

    it "test_should_use_default_value_if_not_stored" do
      assert_equal true, @user.preferred(:notifications, :chat)
    end

    it "test_should_use_group_default_value_if_not_stored" do
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}
      assert_equal 'Latin', @user.preferred(:language, :chat)
    end

    it "test_should_use_stored_value_if_stored" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      assert_equal false, @user.preferred(:notifications, :chat)
    end

    it "test_should_cache_stored_values" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      assert_queries(1) { @user.preferred(:notifications, :chat) }
      assert_queries(0) { @user.preferred(:notifications, :chat) }
    end

    it "test_should_not_query_if_preferences_already_loaded" do
      @user.preferences(:chat)
      assert_queries(0) { @user.preferred(:notifications, :chat) }
    end

    it "test_should_use_value_from_preferences_lookup" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      @user.preferences(:chat)

      assert_queries(0) { assert_equal false, @user.preferred(:notifications, :chat) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      assert_equal true, @user.prefers_notifications(:chat)
    end

    it "test_should_be_able_to_use_preferred_reader" do
      assert_equal true, @user.preferred_notifications(:chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupReaderTest" do
    before do
      @car = create_car

      User.preference :notifications, :default => true
      @user = create_user
    end

    it "test_use_default_value_if_not_stored" do
      assert_equal true, @user.preferred(:notifications, @car)
    end

    it "test_should_use_stored_value_if_stored" do
      create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      assert_equal false, @user.preferred(:notifications, @car)
    end

    it "test_should_use_value_from_preferences_lookup" do
      create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      @user.preferences(@car)

      assert_queries(0) { assert_equal false, @user.preferred(:notifications, @car) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      assert_equal true, @user.prefers_notifications(@car)
    end

    it "test_should_be_able_to_use_preferred_reader" do
      assert_equal true, @user.preferred_notifications(@car)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesQueryTest" do
    before do
      User.preference :language, :string
      @user = create_user
    end

    it "test_should_raise_exception_if_invalid_preference_queried" do
      expect {
        @user.preferred?(:invalid)
      }.to raise_error(ArgumentError, 'Unknown preference: invalid')
    end

    it "test_should_be_true_if_present" do
      @user.preferred_language = 'English'
      assert_equal true, @user.preferred?(:language)
    end

    it "test_should_be_false_if_not_present" do
      assert_equal false, @user.preferred?(:language)
    end

    it "test_should_use_stored_value_if_stored" do
      create_preference(:owner => @user, :name => 'language', :value => 'English')
      assert_equal true, @user.preferred?(:language)
    end

    it "test_should_cache_stored_values" do
      create_preference(:owner => @user, :name => 'language', :value => 'English')
      assert_queries(1) { @user.preferred?(:language) }
      assert_queries(0) { @user.preferred?(:language) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      assert_equal false, @user.prefers_language?
    end

    it "test_should_be_able_to_use_preferred_reader" do
      assert_equal false, @user.preferred_language?
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupQueryTest" do
    before do
      User.preference :language, :string
      @user = create_user
    end

    it "test_should_be_true_if_present" do
      @user.preferred_language = 'English', :chat
      assert_equal true, @user.preferred?(:language, :chat)
    end

    it "test_should_be_false_if_not_present" do
      assert_equal false, @user.preferred?(:language, :chat)
    end

    it "test_should_use_stored_value_if_stored" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'language', :value => 'English')
      assert_equal true, @user.preferred?(:language, :chat)
    end

    it "test_should_cache_stored_values" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'language', :value => 'English')
      assert_queries(1) { @user.preferred?(:language, :chat) }
      assert_queries(0) { @user.preferred?(:language, :chat) }
    end

    it "test_should_be_able_to_use_prefers_reader" do
      assert_equal false, @user.prefers_language?(:chat)
    end

    it "test_should_be_able_to_use_preferred_reader" do
      assert_equal false, @user.preferred_language?(:chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupQueryTest" do
    before do
      @car = create_car

      User.preference :language, :string
      @user = create_user
    end

    it "test_should_be_true_if_present" do
      @user.preferred_language = 'English', @car
      assert_equal true, @user.preferred?(:language, @car)
    end

    it "test_should_be_false_if_not_present" do
      assert_equal false, @user.preferred?(:language, @car)
    end

    it "test_should_use_stored_value_if_stored" do
      create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'language', :value => 'English')
      assert_equal true, @user.preferred?(:language, @car)
    end

    it "test_should_be_able_to_use_prefers_reader" do
      assert_equal false, @user.prefers_language?(@car)
    end

    it "test_should_be_able_to_use_preferred_reader" do
      assert_equal false, @user.preferred_language?(@car)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWriterTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create_user(:login => 'admin')
    end

    it "test_should_raise_exception_if_invalid_preference_written" do
      expect {
        @user.write_preference(:invalid, true)
      }.to raise_error(ArgumentError, 'Unknown preference: invalid')
    end

    it "test_should_have_same_value_if_not_changed" do
      @user.write_preference(:notifications, true)
      assert_equal true, @user.preferred(:notifications)
    end

    it "test_should_use_new_value_if_changed" do
      @user.write_preference(:notifications, false)
      assert_equal false, @user.preferred(:notifications)
    end

    it "test_should_not_save_record_after_changing_preference" do
      @user.login = 'test'
      @user.write_preference(:notifications, false)

      assert_equal 'admin', User.find(@user.id).login
    end

    it "test_should_not_create_stored_preferences_immediately" do
      @user.write_preference(:notifications, false)
      assert @user.stored_preferences.empty?
    end

    it "test_should_not_create_stored_preference_if_value_not_changed" do
      @user.write_preference(:notifications, true)
      @user.save!

      assert_equal 0, @user.stored_preferences.count
    end

    it "test_should_not_create_stored_integer_preference_if_typecast_not_changed" do
      User.preference :age, :integer

      @user.write_preference(:age, '')
      @user.save!

      assert_equal 0, @user.stored_preferences.count
    end

    it "test_should_create_stored_integer_preference_if_typecast_changed" do
      User.preference :age, :integer, :default => 0

      @user.write_preference(:age, '')
      @user.save!

      assert_nil @user.preferred(:age)
      assert_equal 1, @user.stored_preferences.count
    end

    it "test_should_create_stored_preference_if_value_changed" do
      @user.write_preference(:notifications, false)
      @user.save!

      assert_equal 1, @user.stored_preferences.count
    end

    it "test_should_overwrite_existing_stored_preference_if_value_changed" do
      preference = create_preference(:owner => @user, :name => 'notifications', :value => true)

      @user.write_preference(:notifications, false)
      @user.save!

      preference.reload
      assert_equal false, preference.value
    end

    it "test_should_not_remove_preference_if_set_to_default" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)

      @user.write_preference(:notifications, true)
      @user.save!
      @user.reload

      assert_equal 1, @user.stored_preferences.size
      preference = @user.stored_preferences.first
      assert_equal true, preference.value
    end

    it "test_should_not_remove_preference_if_set_to_nil" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)

      @user.write_preference(:notifications, nil)
      @user.save!
      @user.reload

      assert_equal 1, @user.stored_preferences.size
      preference = @user.stored_preferences.first
      assert_nil preference.value
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
      @user = create_user(:login => 'admin')
    end

    it "test_should_have_same_value_if_not_changed" do
      @user.write_preference(:notifications, true, :chat)
      assert_equal true, @user.preferred(:notifications, :chat)
    end

    it "test_should_use_new_value_if_changed" do
      @user.write_preference(:notifications, false, :chat)
      assert_equal false, @user.preferred(:notifications, :chat)
    end

    it "test_should_not_create_stored_preference_if_value_not_changed" do
      @user.write_preference(:notifications, true, :chat)
      @user.save!

      assert_equal 0, @user.stored_preferences.count
    end

    it "test_should_create_stored_preference_if_value_changed" do
      @user.write_preference(:notifications, false, :chat)
      @user.save!

      assert_equal 1, @user.stored_preferences.count
    end

    it "test_should_set_group_attributes_on_stored_preferences" do
      @user.write_preference(:notifications, false, :chat)
      @user.save!

      preference = @user.stored_preferences.first
      assert_equal 'chat', preference.group_type
      assert_nil preference.group_id
    end

    it "test_should_overwrite_existing_stored_preference_if_value_changed" do
      preference = create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => true)

      @user.write_preference(:notifications, false, :chat)
      @user.save!

      preference.reload
      assert_equal false, preference.value
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesARGroupWriterTest" do
    before do
      @car = create_car

      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create_user(:login => 'admin')
    end

    it "test_should_have_same_value_if_not_changed" do
      @user.write_preference(:notifications, true, @car)
      assert_equal true, @user.preferred(:notifications, @car)
    end

    it "test_should_use_new_value_if_changed" do
      @user.write_preference(:notifications, false, @car)
      assert_equal false, @user.preferred(:notifications, @car)
    end

    it "test_should_not_create_stored_preference_if_value_not_changed" do
      @user.write_preference(:notifications, true, @car)
      @user.save!

      assert_equal 0, @user.stored_preferences.count
    end

    it "test_should_create_stored_preference_if_value_changed" do
      @user.write_preference(:notifications, false, @car)
      @user.save!

      assert_equal 1, @user.stored_preferences.count
    end

    it "test_should_set_group_attributes_on_stored_preferences" do
      @user.write_preference(:notifications, false, @car)
      @user.save!

      preference = @user.stored_preferences.first
      assert_equal 'Car', preference.group_type
      assert_equal @car.id, preference.group_id
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterChangingPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create_user

      @user.write_preference(:notifications, false)
    end

    it "test_should_query_preferences_changed" do
      assert_equal true, @user.preferences_changed?
    end

    it "test_should_query_preference_changed" do
      assert_equal true, @user.prefers_notifications_changed?
    end

    it "test_should_not_query_preferences_changed_for_group" do
      assert_equal false, @user.preferences_changed?(:chat)
    end

    it "test_should_not_query_preference_changed_for_group" do
      assert_equal false, @user.prefers_notifications_changed?(:chat)
    end

    it "test_should_have_preferences_changed" do
      assert_equal ['notifications'], @user.preferences_changed
    end

    it "test_should_not_build_same_preferences_changed_result" do
      expect(@user.preferences_changed).to_not be @user.preferences_changed
    end

    it "test_should_not_have_preferences_changed_for_group" do
      assert_equal [], @user.preferences_changed(:chat)
    end

    it "test_should_track_multiple_preferences_changed" do
      @user.write_preference(:language, 'Latin')
      assert_equal ['language', 'notifications'], @user.preferences_changed.sort
    end

    it "test_should_have_preference_changes" do
      assert_equal e = {'notifications' => [true, false]}, @user.preference_changes
    end

    it "test_should_not_build_same_preference_changes_result" do
      expect(@user.preference_changes).to_not be @user.preference_changes
    end

    it "test_should_have_preference_change" do
      assert_equal [true, false], @user.prefers_notifications_change
    end

    it "test_should_have_preference_was" do
      assert_equal true, @user.prefers_notifications_was
    end

    it "test_should_not_have_preference_changes_for_group" do
      assert_equal e = {}, @user.preference_changes(:chat)
    end

    it "test_should_not_have_preference_change_for_group" do
      assert_nil @user.prefers_notifications_change(:chat)
    end

    it "test_should_have_preference_was_for_group" do
      assert_equal true, @user.prefers_notifications_was(:chat)
    end

    it "test_should_use_latest_value_for_preference_changes" do
      @user.write_preference(:notifications, nil)
      assert_equal e = {'notifications' => [true, nil]}, @user.preference_changes
    end

    it "test_should_use_cloned_old_value_for_preference_changes" do
      old_value = @user.preferred(:language)
      @user.write_preference(:language, 'Latin')

      tracked_old_value = @user.preference_changes['language'][0]
      assert_equal old_value, tracked_old_value
      expect(old_value).to_not be tracked_old_value
    end

    it "test_should_track_multiple_preference_changes" do
      @user.write_preference(:language, 'Latin')
      assert_equal e = {'notifications' => [true, false], 'language' => ['English', 'Latin']}, @user.preference_changes
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterChangingGroupPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'
      @user = create_user

      @user.write_preference(:notifications, false, :chat)
    end

    it "test_should_not_query_preferences_changed" do
      assert_equal false, @user.preferences_changed?
    end

    it "test_not_should_query_preference_changed" do
      assert_equal false, @user.prefers_notifications_changed?
    end

    it "test_should_query_preferences_changed_for_group" do
      assert_equal true, @user.preferences_changed?(:chat)
    end

    it "test_should_query_preference_changed_for_group" do
      assert_equal true, @user.prefers_notifications_changed?(:chat)
    end

    it "test_should_have_preferences_changed" do
      assert_equal [], @user.preferences_changed
    end

    it "test_should_not_have_preferences_changed_for_group" do
      assert_equal ['notifications'], @user.preferences_changed(:chat)
    end

    it "test_should_have_preference_changes" do
      assert_equal e = {}, @user.preference_changes
    end

    it "test_should_not_have_preference_change" do
      assert_nil @user.prefers_notifications_change
    end

    it "test_should_have_preference_was" do
      assert_equal true, @user.prefers_notifications_was
    end

    it "test_should_not_have_preference_changes_for_group" do
      assert_equal e = {'notifications' => [true, false]}, @user.preference_changes(:chat)
    end

    it "test_should_have_preference_change_for_group" do
      assert_equal [true, false], @user.prefers_notifications_change(:chat)
    end

    it "test_should_have_preference_was_for_group" do
      assert_equal true, @user.prefers_notifications_was(:chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterRevertPreferenceChangeTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create_user
      @user.write_preference(:notifications, false)
      @user.write_preference(:notifications, true)
    end

    it "test_should_not_query_preferences_changed" do
      assert_equal false, @user.preferences_changed?
    end

    it "test_should_not_have_preferences_changed" do
      assert_equal [], @user.preferences_changed
    end

    it "test_should_not_have_preference_changes" do
      assert_equal e = {}, @user.preference_changes
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterForcingChangeTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create_user
      @user.prefers_notifications_will_change!
      @user.save
    end

    it "test_should_store_preference" do
      assert_equal 1, @user.stored_preferences.count

      preference = @user.stored_preferences.first
      assert_equal nil, preference.group_type
      assert_equal nil, preference.group_id
      assert_equal true, preference.value
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterForcingChangeForGroupTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create_user
      @user.prefers_notifications_will_change!(:chat)
      @user.save
    end

    it "test_should_store_preference" do
      assert_equal 1, @user.stored_preferences.count

      preference = @user.stored_preferences.first
      assert_equal 'chat', preference.group_type
      assert_equal nil, preference.group_id
      assert_equal true, preference.value
    end

    it "test_should_use_cloned_value_for_tracking_old_value" do
      old_value = @user.preferred(:language)
      @user.preferred_language_will_change!

      tracked_old_value = @user.preferred_language_was
      assert_equal old_value, tracked_old_value
      expect(old_value).to_not be tracked_old_value
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterResettingPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create_user
      @user.write_preference(:notifications, false)
      @user.write_preference(:notifications, false, :chat)
      @user.reset_prefers_notifications!
    end

    it "test_should_revert_to_original_value" do
      assert_equal true, @user.preferred(:notifications)
    end

    it "test_should_not_reset_groups" do
      assert_equal false, @user.preferred(:notifications, :chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterResettingPreferenceTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create_user
      @user.write_preference(:notifications, false)
      @user.write_preference(:notifications, false, :chat)
      @user.reset_prefers_notifications!(:chat)
    end

    it "test_should_revert_to_original_value" do
      assert_equal true, @user.preferred(:notifications, :chat)
    end

    it "test_should_not_reset_default_group" do
      assert_equal false, @user.preferred(:notifications)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesLookupTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}

      @user = create_user
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Latin')
      assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences
    end

    it "test_should_use_unsaved_changes_over_stored_preferences" do
      create_preference(:owner => @user, :name => 'notifications', :value => true)
      @user.write_preference(:notifications, false)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences
    end

    it "test_should_typecast_unsaved_changes" do
      @user.write_preference(:notifications, 'true')
      assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
    end

    it "test_should_cache_results" do
      assert_queries(1) { @user.preferences }
      assert_queries(0) { @user.preferences }
    end

    it "test_should_not_query_if_stored_preferences_eager_loaded" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      user = User.includes(:stored_preferences).where(id: @user.id).first
      assert_queries(0) do
        assert_equal e = {'notifications' => false, 'language' => 'English'}, user.preferences
      end
    end

    it "test_should_not_generate_same_object_twice" do
      expect(@user.preferences).to_not be @user.preferences
    end

    it "test_should_use_preferences_for_prefs" do
      assert_equal @user.preferences, @user.prefs
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesGroupLookupTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English', :group_defaults => {:chat => 'Latin'}

      @user = create_user
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      assert_equal e = {'notifications' => true, 'language' => 'Latin'}, @user.preferences(:chat)
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false, :chat)
      assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(:chat)
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(:chat)
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Spanish', :chat)
      assert_equal e = {'notifications' => false, 'language' => 'Spanish'}, @user.preferences(:chat)
    end

    it "test_should_typecast_unsaved_changes" do
      @user.write_preference(:notifications, 'true', :chat)
      assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
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
      @car = create_car

      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create_user
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences(@car)
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false, @car)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(@car)
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(@car)
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create_preference(:owner => @user, :group_type => 'Car', :group_id => @car.id, :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Latin', @car)
      assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(@car)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesNilGroupLookupTest" do
    before do
      @car = create_car

      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create_user
    end

    it "test_should_only_have_defaults_if_nothing_customized" do
      assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences(nil)
    end

    it "test_should_merge_defaults_with_unsaved_changes" do
      @user.write_preference(:notifications, false)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(nil)
    end

    it "test_should_merge_defaults_with_saved_changes" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      assert_equal e = {'notifications' => false, 'language' => 'English'}, @user.preferences(nil)
    end

    it "test_should_merge_stored_preferences_with_unsaved_changes" do
      create_preference(:owner => @user, :name => 'notifications', :value => false)
      @user.write_preference(:language, 'Latin')
      assert_equal e = {'notifications' => false, 'language' => 'Latin'}, @user.preferences(nil)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesLookupWithGroupsTest" do
    before do
      User.preference :notifications, :boolean, :default => true
      User.preference :language, :string, :default => 'English'

      @user = create_user
      create_preference(:owner => @user, :group_type => 'chat', :name => 'notifications', :value => false)
    end

    it "test_not_include_group_preferences_by_default" do
      assert_equal e = {'notifications' => true, 'language' => 'English'}, @user.preferences
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesAfterBeingReloadedTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create_user
      @user.write_preference(:notifications, false)
      @user.reload
    end

    it "test_should_reset_unsaved_preferences" do
      assert_equal true, @user.preferred(:notifications)
    end

    it "test_should_not_save_reset_preferences" do
      @user.save!
      assert @user.stored_preferences.empty?
    end

    it "test_should_reset_preferences" do
      assert_equal e = {'notifications' => true}, @user.preferences
    end

    it "test_should_clear_query_cache_for_preferences" do
      assert_queries(1) { @user.preferences }
    end

    it "test_should_reset_preferences_changed_query" do
      assert_equal false, @user.preferences_changed?
    end

    it "test_should_reset_preferences_changed" do
      assert_equal [], @user.preferences_changed
    end

    it "test_should_reset_preference_changes" do
      assert_equal e = {}, @user.preference_changes
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesForGroupAfterBeingReloadedTest" do
    before do
      User.preference :notifications, :boolean, :default => true

      @user = create_user
      @user.write_preference(:notifications, false, :chat)
      @user.reload
    end

    it "test_should_reset_unsaved_preferences" do
      assert_equal true, @user.preferred(:notifications, :chat)
    end

    it "test_should_reset_preferences" do
      assert_equal e = {'notifications' => true}, @user.preferences(:chat)
    end

    it "test_should_clear_query_cache_for_preferences" do
      assert_queries(1) { @user.preferences(:chat) }
    end

    it "test_should_reset_preferences_changed_query" do
      assert_equal false, @user.preferences_changed?(:chat)
    end

    it "test_should_reset_preferences_changed" do
      assert_equal [], @user.preferences_changed(:chat)
    end

    it "test_should_reset_preference_changes" do
      assert_equal e = {}, @user.preference_changes(:chat)
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithScopeTest" do
    before do
      User.preference :notifications
      User.preference :language, :string, :default => 'English'
      User.preference :color, :string, :default => 'red'

      @user = create_user
      @customized_user = create_user(:login => 'customized',
        :prefers_notifications => false,
        :preferred_language => 'Latin'
      )
      @customized_user.prefers_notifications = false, :chat
      @customized_user.preferred_language = 'Latin', :chat
      @customized_user.save!
    end

    it "test_should_not_find_if_no_preference_matched" do
      assert_equal [], User.with_preferences(:language => 'Italian')
    end

    it "test_should_find_with_null_preference" do
      assert_equal [@user], User.with_preferences(:notifications => nil)
    end

    it "test_should_find_with_default_preference" do
      assert_equal [@user], User.with_preferences(:language => 'English')
    end

    it "test_should_find_with_multiple_default_preferences" do
      assert_equal [@user], User.with_preferences(:notifications => nil, :language => 'English')
    end

    it "test_should_find_with_custom_preference" do
      assert_equal [@customized_user], User.with_preferences(:language => 'Latin')
    end

    it "test_should_find_with_multiple_custom_preferences" do
      assert_equal [@customized_user], User.with_preferences(:notifications => false, :language => 'Latin')
    end

    it "test_should_find_with_mixed_default_and_custom_preferences" do
      assert_equal [@customized_user], User.with_preferences(:color => 'red', :language => 'Latin')
    end

    it "test_should_find_with_default_group_preference" do
      assert_equal [@user], User.with_preferences(:chat => {:language => 'English'})
    end

    it "test_should_find_with_customized_default_group_preference" do
      User.preference :country, :string, :default => 'US', :group_defaults => {:chat => 'UK'}
      @customized_user.preferred_country = 'US', :chat
      @customized_user.save!

      assert_equal [@user], User.with_preferences(:chat => {:country => 'UK'})
    end

    it "test_should_find_with_multiple_default_group_preferences" do
      assert_equal [@user], User.with_preferences(:chat => {:notifications => nil, :language => 'English'})
    end

    it "test_should_find_with_custom_group_preference" do
      assert_equal [@customized_user], User.with_preferences(:chat => {:language => 'Latin'})
    end

    it "test_should_find_with_multiple_custom_group_preferences" do
      assert_equal [@customized_user], User.with_preferences(:chat => {:notifications => false, :language => 'Latin'})
    end

    it "test_should_find_with_mixed_default_and_custom_group_preferences" do
      assert_equal [@customized_user], User.with_preferences(:chat => {:color => 'red', :language => 'Latin'})
    end

    it "test_should_find_with_mixed_basic_and_group_preferences" do
      @customized_user.preferred_language = 'English'
      @customized_user.save!

      assert_equal [@customized_user], User.with_preferences(:language => 'English', :chat => {:language => 'Latin'})
    end

    it "test_should_allow_chaining" do
      assert_equal [@user], User.with_preferences(:language => 'English').with_preferences(:color => 'red')
    end
  end

  #------------------------------------------------------------------------------
  describe "PreferencesWithoutScopeTest" do
    before do
      User.preference :notifications
      User.preference :language, :string, :default => 'English'
      User.preference :color, :string, :default => 'red'

      @user = create_user
      @customized_user = create_user(:login => 'customized',
        :prefers_notifications => false,
        :preferred_language => 'Latin'
      )
      @customized_user.prefers_notifications = false, :chat
      @customized_user.preferred_language = 'Latin', :chat
      @customized_user.save!
    end

    it "test_should_not_find_if_no_preference_matched" do
      assert_equal [], User.without_preferences(:color => 'red')
    end

    it "test_should_find_with_null_preference" do
      assert_equal [@user], User.without_preferences(:notifications => false)
    end

    it "test_should_find_with_default_preference" do
      assert_equal [@user], User.without_preferences(:language => 'Latin')
    end

    it "test_should_find_with_multiple_default_preferences" do
      assert_equal [@user], User.without_preferences(:language => 'Latin', :notifications => false)
    end

    it "test_should_find_with_custom_preference" do
      assert_equal [@customized_user], User.without_preferences(:language => 'English')
    end

    it "test_should_find_with_multiple_custom_preferences" do
      assert_equal [@customized_user], User.without_preferences(:language => 'English', :notifications => nil)
    end

    it "test_should_find_with_mixed_default_and_custom_preferences" do
      assert_equal [@customized_user], User.without_preferences(:language => 'English', :color => 'blue')
    end

    it "test_should_find_with_default_group_preference" do
      assert_equal [@user], User.without_preferences(:chat => {:language => 'Latin'})
    end

    it "test_should_find_with_customized_default_group_preference" do
      User.preference :country, :string, :default => 'US', :group_defaults => {:chat => 'UK'}
      @customized_user.preferred_country = 'US', :chat
      @customized_user.save!

      assert_equal [@user], User.without_preferences(:chat => {:country => 'US'})
    end

    it "test_should_find_with_multiple_default_group_preferences" do
      assert_equal [@user], User.without_preferences(:chat => {:language => 'Latin', :notifications => false})
    end

    it "test_should_find_with_custom_group_preference" do
      assert_equal [@customized_user], User.without_preferences(:chat => {:language => 'English'})
    end

    it "test_should_find_with_multiple_custom_group_preferences" do
      assert_equal [@customized_user], User.without_preferences(:chat => {:language => 'English', :notifications => nil})
    end

    it "test_should_find_with_mixed_default_and_custom_group_preferences" do
      assert_equal [@customized_user], User.without_preferences(:chat => {:language => 'English', :color => 'blue'})
    end

    it "test_should_find_with_mixed_basic_and_group_preferences" do
      @customized_user.preferred_language = 'English'
      @customized_user.save!

      assert_equal [@customized_user], User.without_preferences(:language => 'Latin', :chat => {:language => 'English'})
    end

    it "test_should_allow_chaining" do
      assert_equal [@user], User.without_preferences(:language => 'Latin').without_preferences(:color => 'blue')
    end
  end
end