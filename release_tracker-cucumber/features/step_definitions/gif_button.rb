@gif

And (/^I click on "Brand New Feature"$/) do 
  Brand_New.click
end

Then (/^I have a title page "demo.gif" and the image is loaded$/) do
  sleep 2
  BROWSER.image(:src, /.*demo.gif.*/).loaded?.should be true
  sleep 1
  #BROWSER.screenshot.save "results\\gif.png"
end

at_exit do
  BROWSER.close
end
