# frozen_string_literal: true

class TestMailer < ApplicationMailer
  def test_email
    mail(to: "rendyreynaldy@gmail.com", from: '"Change Password" <info.mediamonitor.id@gmail.com>', subject: "Test Email")
  end
end
