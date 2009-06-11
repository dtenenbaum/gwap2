require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  tests UserMailer
  def test_confirm_password
    @expected.subject = 'UserMailer#confirm_password'
    @expected.body    = read_fixture('confirm_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_confirm_password(@expected.date).encoded
  end

  def test_register
    @expected.subject = 'UserMailer#register'
    @expected.body    = read_fixture('register')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_register(@expected.date).encoded
  end

end
