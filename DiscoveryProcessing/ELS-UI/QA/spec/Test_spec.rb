require_relative '../lib/includes'

describe '' do
   
    context '' do
        
        it '' do
        #    expect(@elsurl.).to eq()
         puts "Test"
        end
    end
    after(:each) do |example|
	if example.exception != nil
		# driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	end
  end

#   Close that browser after each example.
  after :all do
    $browser.close if $browser
  end
end