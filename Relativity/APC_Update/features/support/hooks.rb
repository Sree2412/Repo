
After do |scenario|
  if scenario.failed?
    Dir::mkdir('screenshots') if not File.directory?('screenshots')
    screenshot = "./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    BROWSERR.screenshot.save(screenshot)
    embed screenshot, 'image/png'
    puts "screenshot is taken"
  	puts "Scenario:: #{scenario.name}"
    puts screenshot
 end
end

After do |scenario|
  APC.new.APCUpdateRun == true if scenario.failed?
end

After do |scenario|
   Cucumber.wants_to_quit = true if scenario.failed?
end

at_exit do
  BROWSERR.close
end