
require_relative '../lib/includes'

describe 'Search Project' do
   
    context 'Get Project' do
        
        it '' do
            # $browser = Watir::Browser.new :chrome
    $browser = Watir::Browser.new( :chrome, :switches => %w[ --disable-extensions ] )
    # $browser.driver.manage.window.maximize
    $url = ElsUrl::Test
     $browser.goto $url
            @searchByProject = ProjectsPage.new
            # @searchByProject.SearchProject('Project Starboard')
            @searchByProject.SearchProject(ProjectName::Project)
        #    expect(@elsurl.).to eq()
         puts "Projects"
        end
    end
    after(:each) do |example|
	if example.exception != nil
		# driver.save_screenshot "C:/RubyScripts/rspec/error.png"
	end
  end
end