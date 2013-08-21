# coding: utf-8
require 'spec_helper'

describe "Entry", type: :feature do
  include Login
  it 'edit', js: true do
    visit "/users/#{user.id}"
    within '#current-entry .active' do
      find('.edit-entry').click
      page.driver.render('tmp/capybara/entry.png', :full => true)
      page.should have_selector "form"
      fill_in "entry_title", with: "The new entry"
      fill_in "entry_content", with: "New entry's content"
      click_button "提交"
      #page.should_not have_selector "form"
      page.should have_content "New entry's content"
    end
    within "#entry-previous" do
      page.should have_content "The new entry"
    end
  end
end

