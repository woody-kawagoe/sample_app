require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost count" do
    before { visit root_path }
    it { should have_content('0 micropost') }

    describe "with 1 micropost" do
      before do
        fill_in "micropost_content" , with: "Foo"
        click_button "Post"
      end
      it { should have_content('1 micropost') }

      describe "with 2 microposts" do
        before do
          fill_in "micropost_content" , with: "Foo"
          click_button "Post"
        end
        it { should have_content('2 microposts') }
      end
    end
  end

  describe "pagination" do
    before do
      31.times { FactoryGirl.create(:micropost, user: user) } 
      visit root_path
    end
    after { Micropost.delete_all }

    it { should have_selector('div.pagination') }

    it "should list each micropost" do
      Micropost.paginate(page: 1).each do |micropost|
        expect(page).to have_selector('li', text: micropost.content)
      end
    end
  end

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with invalid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end
end
