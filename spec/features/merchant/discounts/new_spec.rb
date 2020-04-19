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

  it "I can create a new discount for a merchant" do
    percent_off = 45
    min_quantity = 50

    visit merchant_discounts_path

    click_link "New Bulk Discount"

    expect(current_path).to eq(new_merchant_discount_path)

    fill_in "Percent Discount", with: percent_off
    fill_in "Minimum Quantity Required", with: min_quantity
    click_button 'Create Bulk Discount'

    expect(current_path).to eq(merchant_discounts_path)
    expect(page).to have_content("Your bulk discount has been created!")
    expect(page).to have_link("#{percent_off}% off on #{min_quantity} or more of any individual item")
  end

  it 'I can not create a discount for a merchant with an incomplete form' do
    percent_off = 45

    visit merchant_discounts_path

    click_link "New Bulk Discount"

    expect(current_path).to eq(new_merchant_discount_path)

    fill_in "Percent Discount", with: percent_off
    click_button 'Create Bulk Discount'

    expect(page).to have_content("Min quantity can't be blank and Min quantity is not a number")
    expect(page).to have_button('Create Bulk Discount')
  end

  it 'I can not create a discount for a merchant with invalid data types' do
    visit merchant_discounts_path

    click_link "New Bulk Discount"

    expect(current_path).to eq(new_merchant_discount_path)

    fill_in "Percent Discount", with: "20%"
    fill_in "Minimum Quantity Required", with: 35.5
    click_button 'Create Bulk Discount'

    expect(page).to have_content("Percent off is not a number and Min quantity must be an integer")
    expect(page).to have_button('Create Bulk Discount')
  end

end
