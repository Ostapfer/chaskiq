module Postino
  class Campaign < ActiveRecord::Base

    belongs_to :parent, class_name: "Postino::Campaign"
    belongs_to :list
    has_many :attachments
    #has_one :campaign_template
    #has_one :template, through: :campaign_template
    belongs_to :template
    #accepts_nested_attributes_for :template, :campaign_template

    attr_accessor :step

    validates :subject, presence: true , unless: :step_1?
    validates :from_name, presence: true, unless: :step_1?
    validates :from_email, presence: true, unless: :step_1?

    #validates :plain_content, presence: true, unless: :template_step?
    validates :html_content, presence: true, if: :template_step?

    before_save :detect_changed_template

    def step_1?
      self.step == 1
    end

    def template_step?
      self.step == "template"
    end

    def send_newsletter
      #send newsletter here
    end

    def detect_changed_template
      if self.changes.include?("template_id")
        copy_template
      end
    end

    def copy_template
      self.html_content = self.template.html_content
    end

  end
end
