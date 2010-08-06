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
   
   def test_validate_uniqueness
      assert_equal(false, UserOne.new(:email => "amed@tractical.com").valid?)
   end

   def test_validate_presence
      assert_equal(false, UserOne.new(:email => "").valid?)
   end

   def test_validate_min_length
      assert_equal(false, UserOne.new(:email => "a@a.c").valid?)
   end

   def test_valid_domains
      assert_equal(true, UserTwo.new(:email => "user@inbox.com").valid?)
   end

   def test_invalid_domains
      assert_equal(false, UserTwo.new(:email => "user@gmail.com").valid?)
      assert_equal(false, UserTwo.new(:email => "user@hotmail.com").valid?)
   end

end