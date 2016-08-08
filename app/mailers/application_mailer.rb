require 'mustache'

class ApplicationMailer < ActionMailer::Base

  def tryme
      campaign = Chaskiq::Campaign.first
      mail( from: "ostapfer@gmail.com",
        to: "rafaqat@gmail.com",
        subject: "campaign.subject",
        body: "campaign.reply_email",
        content_type: "text/plain" ) do |format|
      format.html { render text:'newsletter' }
    end
  end

end
