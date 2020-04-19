require "rails_helper"

RSpec.describe "As a merchant employee", type: :feature do

  before :each do
    @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
    @discount = @merchant_1.discounts.create(percent_off: 5, min_quantity: 10)
    @discount_2 = @merchant_1.discounts.create(percent_off: 15, min_quantity: 20)

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
  end

  it "I can edit a discount for a merchant" do
    percent_off = 45

    visit merchant_discount_path(@discount)

    click_link "Edit"

    expect(current_path).to eq(edit_merchant_discount_path(@discount))

    expect(find_field("Percent Discount").value).to eq(@discount.percent_off.to_s)
    expect(find_field("Minimum Quantity Required").value).to eq(@discount.min_quantity.to_s)

    fill_in "Percent Discount", with: percent_off
    click_button 'Update Bulk Discount'

    expect(current_path).to eq(merchant_discount_path(@discount))
    expect(page).to have_content("Your bulk discount has been updated.")
    expect(page).to have_content("#{percent_off}% off")
    expect(page).to have_content("#{@discount.min_quantity} minimum of any individual item")
  end

  it 'I can not update a discount for a merchant with an incomplete form' do
    visit merchant_discount_path(@discount)

    click_link "Edit"

    expect(current_path).to eq(edit_merchant_discount_path(@discount))

    expect(find_field("Percent Discount").value).to eq(@discount.percent_off.to_s)
    expect(find_field("Minimum Quantity Required").value).to eq(@discount.min_quantity.to_s)

    fill_in "Percent Discount", with: 45
    fill_in "Minimum Quantity Required", with: nil
    click_button 'Update Bulk Discount'

    expect(current_path).to eq(merchant_discount_path(@discount))

    expect(page).to have_content("Min quantity can't be blank and Min quantity is not a number")
    expect(page).to have_button('Update Bulk Discount')
  end

  it 'I can not create a discount for a merchant with invalid data types' do
    visit merchant_discount_path(@discount)

    click_link "Edit"

    expect(current_path).to eq(edit_merchant_discount_path(@discount))

    expect(find_field("Percent Discount").value).to eq(@discount.percent_off.to_s)
    expect(find_field("Minimum Quantity Required").value).to eq(@discount.min_quantity.to_s)

    fill_in "Percent Discount", with: "20%"
    fill_in "Minimum Quantity Required", with: 35.5
    click_button 'Update Bulk Discount'

    expect(current_path).to eq(merchant_discount_path(@discount))

    expect(page).to have_content("Percent off is not a number and Min quantity must be an integer")
    expect(page).to have_button('Update Bulk Discount')
  end

end
