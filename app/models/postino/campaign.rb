module Postino
  class Campaign < ActiveRecord::Base
    belongs_to :parent, class_name: "Postino::Campaign"
    has_many :attachments
    belongs_to :list
    has_one :campaign_template
    has_one :template, through: :campaign_template


    attr_accessor :step

    validates :subject, presence: true , unless: :step_1?
    validates :from_name, presence: true, unless: :step_1?
    validates :from_email, presence: true, unless: :step_1?

    validates :plain_content, presence: true, unless: :step_1?
    validates :html_content, presence: true, unless: :step_1?

    def step_1?
      self.step == 1
    end

  end
end
