require "rails_helper"

RSpec.describe "As a user", type: :feature do
  before :each do
    @megan = Merchant.create(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @brian = Merchant.create(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
    @discount_1 = @megan.discounts.create(percent_off: 10, min_quantity: 10)
    @discount_2 = @megan.discounts.create(percent_off: 20, min_quantity: 30)

    @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
    @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
    @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 50 )
    @nessie = @brian.items.create!(name: 'Nessie', description: "I'm a Loch Monster!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: false, inventory: 50 )
    @user = User.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')

    visit item_path(@ogre)
    click_button "Add to Cart"
    visit item_path(@giant)
    click_button "Add to Cart"
    visit item_path(@hippo)
    click_button "Add to Cart"
    visit item_path(@nessie)
    click_button "Add to Cart"

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it "I can see the discount is added to the cart once I add enough of an item" do
    ogre_subtotal = (@ogre.price * 11)
    discount_percent = (1 - (@discount_1.percent_off.to_f / 100))
    discounted_total = (ogre_subtotal * discount_percent)

    order_total = (discounted_total + @giant.price + @hippo.price + @nessie.price)

    visit cart_path

    within "#item-#{@ogre.id}" do
      10.times do
        click_on "More of This!"
      end
    end

    within "#item-#{@ogre.id}" do
      expect(page).to_not have_content("Subtotal: $#{ogre_subtotal}")
      expect(page).to have_content("Subtotal: $#{discounted_total}")
    end

    expect(page).to have_content("Total: $#{order_total.to_f.round(2)}")
  end

  it "I can see the discount is only added when one item is incremented high enough" do
    megan_item_subtotal = @megan.items.map { |item| item.price * 3 }
    brian_item_subtotal = @brian.items.map { |item| item.price * 3 }
    order_total = (megan_item_subtotal.sum + brian_item_subtotal.sum)

    visit cart_path

    @megan.items.each do |item|
      within "#item-#{item.id}" do
        2.times do
          click_on "More of This!"
        end
      end
    end

    @brian.items.each do |item|
      within "#item-#{item.id}" do
        2.times do
          click_on "More of This!"
        end
      end
    end

    expect(page).to have_content("Total: $#{order_total.to_f.round(2)}")
  end

  it "I can see the higher discount applies when both discount criteria is met" do
    ogre_subtotal = (@ogre.price * 31)

    discount_1_discount_percent = (1 - (@discount_1.percent_off.to_f / 100))
    discount_1_discounted_total = (ogre_subtotal * discount_1_discount_percent)
    discount_1_order_total = (discount_1_discounted_total + @giant.price + @hippo.price + @nessie.price)

    discount_2_discount_percent = (1 - (@discount_2.percent_off.to_f / 100))
    discount_2_discounted_total = (ogre_subtotal * discount_2_discount_percent)
    discount_2_order_total = (discount_2_discounted_total + @giant.price + @hippo.price + @nessie.price)

    visit cart_path

    within "#item-#{@ogre.id}" do
      30.times do
        click_on "More of This!"
      end
    end

    within "#item-#{@ogre.id}" do
      expect(page).to_not have_content("Subtotal: $#{ogre_subtotal}")
      expect(page).to have_content("Subtotal: $#{discount_2_discounted_total}")
    end

    expect(page).to_not have_content("Total: $#{discount_1_order_total.to_f.round(2)}")
    expect(page).to have_content("Total: $#{discount_2_order_total.to_f.round(2)}")
  end

  it "I can see the discount does not affect other merchants" do
    ogre_subtotal = (@ogre.price * 11)
    discount_percent = (1 - (@discount_1.percent_off.to_f / 100))
    discounted_total = (ogre_subtotal * discount_percent)

    order_total = (discounted_total + @giant.price + @hippo.price + @nessie.price)

    visit cart_path

    within "#item-#{@ogre.id}" do
      10.times do
        click_on "More of This!"
      end
    end

    within "#item-#{@ogre.id}" do
      expect(page).to_not have_content("Subtotal: $#{ogre_subtotal}")
      expect(page).to have_content("Subtotal: $#{discounted_total}")
    end

    within "#item-#{@giant.id}" do
      expect(page).to have_content("Subtotal: $#{@giant.price}")
    end

    @brian.items.each do |item|
      within "#item-#{item.id}" do
        expect(page).to have_content("Subtotal: $#{item.price}")
      end
    end

    expect(page).to have_content("Total: $#{order_total.to_f.round(2)}")
  end

  it "I can see the discount is carried through checkout" do
    ogre_subtotal = (@ogre.price * 11)
    discount_percent = (1 - (@discount_1.percent_off.to_f / 100))
    discounted_total = (ogre_subtotal * discount_percent)

    order_total = (discounted_total + @giant.price + @hippo.price + @nessie.price)

    visit cart_path

    within "#item-#{@ogre.id}" do
      10.times do
        click_on "More of This!"
      end
    end

    within "#item-#{@ogre.id}" do
      expect(page).to_not have_content("Subtotal: $#{ogre_subtotal}")
      expect(page).to have_content("Subtotal: $#{discounted_total}")
    end

    expect(page).to have_content("Total: $#{order_total.to_f.round(2)}")

    click_on "Check Out"

    expect(page).to have_content("Total: $#{order_total.to_f.round(2)}")
  end

end
