# encoding: utf-8
class ContactController < ApplicationController
  before_filter :track

  def contact
    @message = Message.new
    #@message.textcaptcha
  end

  def new_message
    @message = Message.create(params[:message])

    if @message.save
      flash.notice = 'Thank you, I will try to respond shortly!'
      redirect_to root_path and return
    else
      render :contact
    end
  end
end
