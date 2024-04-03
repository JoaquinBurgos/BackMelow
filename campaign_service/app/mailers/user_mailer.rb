class UserMailer < ApplicationMailer
  
    def send_campaign_email(user, email_action)
        @user = user
        @subject = email_action.subject
        @body = email_action.body
        mail(to: @user.email, subject: @subject)
      end
  end
  