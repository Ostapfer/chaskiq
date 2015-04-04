require 'rails_helper'
require 'active_job/test_helper'

module Chaskiq
  RSpec.describe Campaign, type: :model do

    it{ should have_many :attachments }
    it{ should have_many :metrics }
    #it{ should have_one :campaign_template }
    #it{ should have_one(:template).through(:campaign_template) }
    it{ should belong_to :list }
    it{ should have_many(:subscribers).through(:list) }
    it{ should belong_to :template }

    let(:html_content){
      "<p>hola {{name}} {{email}}</p> <a href='http://google.com'>google</a>"
    }
    let(:template){ FactoryGirl.create(:chaskiq_template, body: html_content ) }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){
      #list.create_subscriber(subscriber)
      list.create_subscriber FactoryGirl.attributes_for(:chaskiq_subscriber)
    }
    let(:campaign){ FactoryGirl.create(:chaskiq_campaign, template: template) }
    let(:premailer_template){"<p>{{name}} {{last_name}} {{email}} {{campaign_url}} {{campaign_subscribe}} {{campaign_unsubscribe}}this is the template</p>"}

    describe "creation" do
      it "will create a pending campaign by default" do
        @c = FactoryGirl.create(:chaskiq_campaign)
        expect(@c).to_not be_sent
        allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return(premailer_template)
      end
    end

    context "template step" do

      it "will copy template" do
        campaign.template = template
        campaign.save
        expect(campaign.html_content).to be == template.body
      end

      it "will copy template on creation" do
        expect(campaign.html_content).to be == template.body
      end

    end

    context "send newsletter" do
      before do
        10.times do
          list.create_subscriber FactoryGirl.attributes_for(:chaskiq_subscriber)
        end

        @c = FactoryGirl.create(:chaskiq_campaign, template: template, list: list)

        allow(@c).to receive(:premailer).and_return("<p>hi</p>")
        allow_any_instance_of(Chaskiq::Campaign).to receive(:apply_premailer).and_return(true)
      end

      it "will prepare mail to" do
        expect(@c.prepare_mail_to(subscriber)).to be_an_instance_of(ActionMailer::MessageDelivery)
      end

      it "will prepare mail to can send inline" do
        @c.prepare_mail_to(subscriber).deliver_now
        expect(ActionMailer::Base.deliveries.size).to be 1
      end

      it "will send newsletter & create deliver metrics" do
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 0
        @c.send_newsletter
        expect(@c.metrics.deliveries.size).to be == 10
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.size).to eq 10
      end

    end

    context "template compilation" do

      it "will render subscriber attributes" do
        campaign.template = template
        campaign.save
        expect(campaign.html_content).to be == template.body
        allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return("{{name}}")
        expect(campaign.mustache_template_for(subscriber)).to include(subscriber.name)
      end

      it "will render subscriber and compile links with host ?r=link" do
        campaign.template = template
        campaign.save
        allow_any_instance_of(Chaskiq::Campaign).to receive(:premailer).and_return("<a href='http://google.com'>google</a>")
        expect(campaign.compiled_template_for(subscriber)).to include("?r=http://google.com")
        expect(campaign.compiled_template_for(subscriber)).to include(campaign.host)
      end

    end

  end
end
