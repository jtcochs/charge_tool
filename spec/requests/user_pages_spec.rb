require 'spec_helper'

describe "User Pages" do
  subject { page }

  describe "index" do

    let(:admin) { FactoryGirl.create(:admin) }

    before(:each) do
      FactoryGirl.create(:user)
      sign_in admin
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "delete links" do
      it { should have_link('delete', href: user_path(User.first)) }
      it "should be able to delete another user" do
        expect { click_link('delete') }.to change(User, :count).by(-1)
      end
      it { should_not have_link('delete', href: user_path(admin)) }
    end

    describe "edit links" do
      it { should have_link('edit', href: edit_user_path(User.first)) }

      it "should link to the user's edit page" do
        click_link "edit"
        page.should have_selector 'title', text: full_title('Edit user')
      end
    end

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit user_path(user)
    end

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: full_title(user.name)) }
  end

  describe "registration page" do
    before { visit register_path }

    it { should have_selector('h1',    text: 'Register') }
    it { should have_selector('title', text: full_title('Register')) }
  end

  describe "register new user" do

    before { visit register_path }

    let(:submit) { "Create Account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: full_title('Register')) }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before { fill_in_valid_user_info }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_success_message('Registration') }
        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update user profile") }
      it { should have_selector('title', text: "Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_success_message }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

    describe "as admin" do
      let(:admin) { FactoryGirl.create(:admin) }
      before do
        sign_in admin
        visit edit_user_path(user)
      end
      let(:new_name)  { "Admin's Choice" }
      let(:new_email) { "updated@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_success_message }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end
  end
end
