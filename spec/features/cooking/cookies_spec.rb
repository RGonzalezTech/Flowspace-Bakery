require 'sidekiq/testing'

feature 'Cooking cookies' do
  before(:all) do
    Sidekiq::Testing.fake!
  end

  before(:each) do
    BakerWorker.clear
  end

  scenario 'Cooking a single cookie' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'

    expect(BakerWorker.jobs.length).to be_zero

    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    expect(BakerWorker.jobs.length).to eql(1)

    oven.cookie.set_ready(true)
    visit oven_path(oven)
    expect(page).to have_content 'Your Cookie is Ready'

    click_button 'Retrieve Cookie'
    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '1 Cookie'
    end
  end

  scenario 'Trying to bake a cookie while oven is full' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    click_link_or_button 'Prepare Cookie'
    fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    click_link_or_button  'Prepare Cookie'
    expect(page).to have_content 'A cookie is already in the oven!'
    expect(current_path).to eq(oven_path(oven))
    expect(page).to_not have_button 'Mix and bake'
  end

  scenario 'Baking multiple cookies' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)
    expect(BakerWorker.jobs.length).to be_zero

    3.times do
      click_link_or_button 'Prepare Cookie'
      fill_in 'Fillings', with: 'Chocolate Chip'
      click_button 'Mix and bake'

      expect(page).to_not have_content "Your Cookie is Ready"

      # update oven with latest DB changes
      oven.reload
      # quickly set cookie state to ready, no waiting for BG worker
      oven.cookie.set_ready(true)
      # re-render the page
      visit oven_path(oven)

      expect(page).to have_content "Your Cookie is Ready"

      click_button 'Retrieve Cookie'
    end

    expect(BakerWorker.jobs.length).to eql(3)

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '3 Cookies'
    end
  end
end
