# frozen_string_literal: true

module Admin
  class MessageTemplatesController < AdminController
    before_action :check_and_create_message_templates

    def index
      @message_templates = current_client.message_templates
    end

    def edit
      @message_template = current_client.message_templates.find params[:id]
    end

    def update
      @message_template = current_client.message_templates.find params[:id]
      if @message_template.update message_template_params
        redirect_to admin_message_templates_path, notice: t('.success')
      else
        render :edit
      end
    end

    def destroy
      current_client.message_templates.find(params[:id]).destroy
      redirect_to admin_message_templates_path, notice: t('.success')
    end

    private

    def message_template_params
      params.require(:message_template).permit(:subject, :body)
    end

    def check_and_create_message_templates
      StockMessageTemplate.all.each do |stock_template|
        current_client.message_templates.find_or_create_by category: stock_template.category do |template|
          template.subject = stock_template.subject
          template.body = stock_template.body
        end
      end
    end
  end
end
