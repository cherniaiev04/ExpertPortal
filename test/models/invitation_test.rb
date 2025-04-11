require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  setup do
    @valid_email = 'newuser@example.com'
  end

  test 'should create invitation with valid email' do
    invitation = Invitation.new(email: @valid_email)
    assert invitation.save, 'Failed to save a valid invitation'
    assert_not_nil invitation.token, 'Token was not generated on invitation creation'
  end

  test 'should generate a unique token on creation' do
    invitation = Invitation.create(email: @valid_email)
    invitation1 = Invitation.create(email: @valid_email)
    assert_not_nil invitation.token, 'Token was not generated'
    assert(invitation != invitation1)
  end

  test 'should not create invitation without email' do
    invitation = Invitation.new
    assert_not invitation.save, 'Saved the invitation without an email'
  end

  test 'should mark invitation as expired when past expiration date' do
    invitation = Invitation.create!(
      email: @valid_email,
      created_at: 3.weeks.ago,
      expires_at: 1.weeks.ago
    )
    assert invitation.expired?, 'Invitation should be marked as expired'
  end

  test 'should mark invitation as used' do
    invitation = Invitation.create!(email: @valid_email)
    invitation.update!(used: true)

    assert invitation.used?, 'Invitation should be marked as used'
  end
end
