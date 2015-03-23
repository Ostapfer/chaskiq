require_dependency "postino/application_controller"

module Postino
  class Manage::CampaignWizardController < ApplicationController

    before_filter :authentication_method

    include Wicked::Wizard

    steps :list, :setup, :template, :design, :confirm

    def show
      @campaign = Postino::Campaign.find(params[:campaign_id])
      render_wizard
    end

    def design
      @campaign = Postino::Campaign.find(params[:campaign_id])
      render_wizard
      render :show , layout: false
    end

    def update
      @campaign = Postino::Campaign.find(params[:campaign_id])
      @campaign.update_attributes(resource_params)
      render_wizard @campaign
    end

    def create
      @campaign = Postino::Campaign.create(resource_params)
      redirect_to manage_wizard_path(steps.first, :campaign_id => @campaign.id)
    end

    protected

    def resource_params
      return [] if request.get?
      params.require(:campaign).permit!
    end

  end
end
