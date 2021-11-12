feature 'Displaying cookies' do
  before(:each) do
    @user = create_and_signin
    @oven = @user.ovens.first
  end

  scenario 'When cookies have fillings' do
    CookiesHelper.create_cookie_with("chocolate", @user)
    visit root_path
    expect(page).to have_content "chocolate"
  end

  scenario 'When cookies have nil fillings' do
    CookiesHelper.create_cookie_with(nil, @user)
    visit root_path
    expect(page).to have_content "no filling"
  end

  scenario 'When cookies have empty fillings' do
    CookiesHelper.create_cookie_with("", @user)
    visit root_path
    expect(page).to have_content "no filling"
  end

  scenario 'When cookies have whitespace fillings' do 
    CookiesHelper.create_cookie_with("  ", @user)
    visit root_path
    expect(page).to have_content "no filling"
  end
end
