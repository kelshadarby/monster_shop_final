require "rails_helper"

RSpec.describe "As a merchant employee", type: :feature do
  before :each do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount_1 = @merchant_1.discounts.create(percent_off: 5, min_quantity: 10)
    @discount_2 = @merchant_1.discounts.create(percent_off: 15, min_quantity: 20)

    @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @discount_3 = @merchant_2.discounts.create(percent_off: 25, min_quantity: 30)
    @discount_4 = @merchant_2.discounts.create(percent_off: 35, min_quantity: 40)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end
  it "I can view all discounts I have" do
    visit merchant_discounts_path

    within "#discount-#{@discount_1.id}" do
      expect(page).to have_content(@discount_1.percent_off)
      expect(page).to have_content(@discount_1.min_quantity)
    end

    within "#discount-#{@discount_2.id}" do
      expect(page).to have_content(@discount_2.percent_off)
      expect(page).to have_content(@discount_2.min_quantity)
    end

    expect(page).to_not have_content(@discount_3.percent_off)
    expect(page).to_not have_content(@discount_3.min_quantity)
    expect(page).to_not have_content(@discount_4.percent_off)
    expect(page).to_not have_content(@discount_4.min_quantity)
  end
end
