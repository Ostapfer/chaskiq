require_dependency "chaskiq/application_controller"

module Chaskiq
  class Manage::CampaignsController < ApplicationController

    before_filter :authentication_method, except: [:preview, :premailer_preview]
    before_filter :find_campaign, except: [:index, :create, :new]
    helper Chaskiq::Manage::CampaignsHelper


    def index
      @q = Chaskiq::Campaign.ransack(params[:q])
      @campaigns = @q.result
      .page(params[:page])
      .per(8)
    end

    def new
      @campaign = Chaskiq::Campaign.new
    end

    def create

      @campaign = Chaskiq::Campaign.new
      @campaign.step = 1

      @campaign.assign_attributes(resource_params)

      if @campaign.save && @campaign.errors.blank?
        redirect_to manage_campaign_wizard_path(@campaign, "setup")
      else
        render "new"
      end
    end

    def show
      find_campaign
      @metrics = @campaign.metrics
      @q = @metrics.ransack(params[:q])
      @metrics = @q.result
      .includes(:trackable)
      .page(params[:page])
      .per(8)
    end

    def preview
      find_campaign
      @campaign.apply_premailer(exclude_gif: true)
      render layout: false
    end

    def premailer_preview
      find_campaign
      render layout: false
    end

    def editor
      find_campaign
      render "editor_frame", layout: false
    end

    def test
      find_campaign
      @campaign.test_newsletter
      flash[:notice] = "test sended"
      redirect_to manage_campaigns_path()
    end

    def deliver
      find_campaign
      @campaign.send_newsletter
      flash[:notice] = "newsletter sended"
      redirect_to manage_campaigns_path()
    end

    def clone
      find_campaign
      new_campaign = @campaign.clone_newsletter
      if new_campaign.save
        flash[:notice] = "cloned"
        redirect_to manage_campaign_path(new_campaign)
      else
        flash[:error] = "whoops!"
        redirect_to manage_campaign_path(@campaign)
      end
    end

    def purge
      find_campaign
      @campaign.purge_metrics
      flash[:notice] = "cleaned data!"
      redirect_to manage_campaign_path(@campaign)
    end

  protected

    def find_campaign
      @campaign = Chaskiq::Campaign.find(params[:id])
    end

    def resource_params
      return [] if request.get?
      params.require(:campaign).permit(:list_id)
    end

  end
end
