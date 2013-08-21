class EntriesController < ApplicationController
  include ActionView::Helpers::TextHelper
  #include ActionView::Helpers::UrlHelper
  #include ActionView::Helpers::OutputSafetyHelper
  #include ActionView::Context
  #include EntriesHelper

  before_filter :require_user, expect: [:show, :add_to_previous]

  def index
    @entries = Entry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @entries }
    end
  end

  def next
    title = params[:title]
    begin
      @entry = current_user.entries.find_by(title: title)
      respond_to do |format|
        format.js
      end
    rescue Mongoid::Errors::DocumentNotFound
      current_user.entries.new(title: title)
    end
  end

  def show
    @entry = Entry.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def new
    @entry = Entry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @entry }
    end
  end

  def edit
    @entry = Entry.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    @entry = Entry.new(params[:entry])

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
        format.json { render json: @entry, status: :created, location: @entry }
      else
        format.html { render action: "new" }
        format.json { render json: @entry.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @entry = Entry.find(params[:id])

    if @entry.update_attributes(params[:entry])
      render js: "$('#current-entry-content').html('#{simple_format @entry.parsed_content}');
                  $('#entry-title-#{@entry.id}').html('#{@entry.title}')"
    end
  end

  # DELETE /entries/1
  # DELETE /entries/1.json
  def destroy
    @entry = Entry.find(params[:id])
    @entry.destroy

    respond_to do |format|
      format.html { redirect_to entries_url }
      format.json { head :no_content }
    end
  end
end
