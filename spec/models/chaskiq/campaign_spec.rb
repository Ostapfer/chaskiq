require 'rails_helper'

module Chaskiq
  RSpec.describe Campaign, type: :model do

    it{ should have_many :attachments }
    it{ should have_many :metrics }
    #it{ should have_one :campaign_template }
    #it{ should have_one(:template).through(:campaign_template) }
    it{ should belong_to :list }
    it{ should belong_to :template }

    let(:html_content){
      "<p>hola {{name}} {{email}}</p> <a href='http://google.com'>google</a>"
    }
    let(:template){ FactoryGirl.create(:chaskiq_template, body: html_content ) }
    let(:list){ FactoryGirl.create(:chaskiq_list) }
    let(:subscriber){ FactoryGirl.create(:chaskiq_subscriber, list: list)}
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
          FactoryGirl.create(:chaskiq_subscriber, list: list)
        end

        @c = FactoryGirl.create(:chaskiq_campaign, template: template, list: list)

        allow(@c).to receive(:premailer).and_return("<p>hi</p>")
        allow_any_instance_of(Chaskiq::Campaign).to receive(:apply_premailer).and_return(true)

      end

      it "will send newsletter & create deliver metrics" do
        allow_any_instance_of(ActionMailer::MessageDelivery).to receive(:deliver_now).and_return(true)
        expect(Chaskiq::CampaignMailer).to receive(:newsletter).exactly(10).times.and_return(ActionMailer::MessageDelivery.new(1,2))
        @c.send_newsletter
        expect(@c.metrics.deliveries.size).to be == 10
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
