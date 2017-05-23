require_relative '../lib/includes'

describe '' do
   before{
   
    # $browser = Watir::Browser.new :chrome
    $browser = Watir::Browser.new( :chrome, :switches => %w[ --disable-extensions ] )
    # $browser.driver.manage.window.maximize
    $url = ElsUrl::Test
    $browser.goto $url
}
    context '' do
        
        it '' do
        #    expect(@elsurl.).to eq()
        end
    end
    after(:each) do |example|
	if example.exception != nil
		# driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	end
  end
end