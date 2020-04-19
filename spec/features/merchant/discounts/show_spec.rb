require "rails_helper"

RSpec.describe "As a merchant employee", type: :feature do

  before :each do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount_1 = @merchant_1.discounts.create(percent_off: 5, min_quantity: 10)
    @discount_2 = @merchant_1.discounts.create(percent_off: 15, min_quantity: 20)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "I can view a discount's show page" do
    visit merchant_discounts_path

    click_link "#{@discount_1.percent_off}% off on #{@discount_1.min_quantity} or more of any individual item"

    expect(current_path).to eq(merchant_discount_path(@discount_1))

    expect(page).to have_content("#{@discount_1.percent_off}% off")
    expect(page).to have_content("#{@discount_1.min_quantity} minimum of any individual item")

    expect(page).to_not have_content("#{@discount_2.percent_off}% off")
    expect(page).to_not have_content("#{@discount_2.min_quantity} minimum of any individual item")
  end

end
