feature 'Displaying cookies' do
  before(:each) do
    @user = create_and_signin
    @oven = @user.ovens.first
  end

  scenario 'When cookies have fillings' do
    new_cookie = FactoryGirl.create(:cookie, fillings: "chocolate", storage: @user)

    visit root_path
    expect(page).to have_content "chocolate"
  end

  scenario 'When cookies have nil fillings' do
    new_cookie = FactoryGirl.create(:cookie, fillings: nil, storage: @user)
    
    visit root_path
    expect(page).to have_content "no fillings"
  end

  scenario 'When cookies have empty fillings' do
    new_cookie = FactoryGirl.create(:cookie, fillings: "", storage: @user)
    
    visit root_path
    expect(page).to have_content "no fillings"
  end
end
