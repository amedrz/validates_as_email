require File.join(File.dirname(__FILE__), 'test_helper')

class ValidatesEmailFormatOfTest < Test::Unit::TestCase

   def setup
     setup_db
   end

   def teardown
     teardown_db
   end

   def test_valid_domain
      assert_equal(true, UserOne.new(:email => "amed@gmail.com").valid?)
   end

   def test_invalid_formats
      assert_equal(false, UserOne.new(:email => "useroninbox.com").valid?)
      assert_equal(false, UserOne.new(:email => "4use@inbox.com'").valid?)
      assert_equal(false, UserOne.new(:email => "@userinbox@.com").valid?)
      assert_equal(false, UserOne.new(:email => "user.*inbox.com").valid?)
      assert_equal(false, UserOne.new(:email => "user@inbox@.com").valid?)
      assert_equal(false, UserOne.new(:email => "userinbox.!dcom").valid?)
      assert_equal(false, UserOne.new(:email => "userinbox...com").valid?)
   end

   def test_invalid_formats_message
      user = UserOne.new(:email => "useroninbox.com")
      assert_equal(false, user.valid?)
      assert_equal(1, user.errors.full_messages.size)
      assert_equal("Email is invalid", user.errors.full_messages[0])
   end

   def test_validate_uniqueness
      user = UserOne.new(:email => "amed@tractical.com")
      assert_equal(false, user.valid?)
      assert_equal(1, user.errors.full_messages.size)
      assert_equal("Email has already been taken", user.errors.full_messages[0])
   end

   def test_validate_presence
      user = UserOne.new(:email => "")
      assert_equal(false, user.valid?)
      assert_equal(1, user.errors.full_messages.size)
      assert_equal("Email can't be blank", user.errors.full_messages[0])
   end

   def test_valid_domains
      assert_equal(true, UserTwo.new(:email => "user@inbox.com").valid?)
   end

   def test_invalid_domains
      assert_equal(false, UserTwo.new(:email => "user@gmail.com").valid?)
      assert_equal(false, UserTwo.new(:email => "user@hotmail.com").valid?)
   end

   def test_invalid_domains_message
      user = UserTwo.new(:email => "user@gmail.com")
      assert_equal(false, user.valid?)
      assert_equal(1, user.errors.full_messages.size)
      assert_equal("Email is not allowed, try with another address", user.errors.full_messages[0])
   end

end