require_relative 'spec_helper'
require '../lib/ProfileTest'
# require 'FileUtils'

describe 'Smoke Test' do
    before :all do
        @url = ProdAppUrl.const_get($env)
        @url = 'http://productions.consilio.com/' # 'http://mtpctscid961/ProductionsWeb/'
        $browser.goto @url
        @profile = ProfileTest.new
        @profile_name = 'QA_H11344_10R'
        @profile.OpenProfile(@profile_name)     
        @output_path = @profile.SetGeneralSettings(ProfileMock::H11344_10R_Mock)                      
    end
    context 'Set Fields, Groups and Transforms' do
        before {}
        it 'Create Fields' do
            $browser.button(:text => 'Fields').wait_until_present.click
            $browser.span(:class => 'glyphicon glyphicon-remove').wait_until_present.click             
            expect(@profile.CreateField('ProdBeg','Production Begin')).to be true
            expect(@profile.CreateField('ProdEnd','Production End')).to be true
            expect(@profile.CreateField('Create DateTime','Create Date')).to be true
            expect(@profile.CreateField('Create DateTime','Create Time')).to be true
            expect(@profile.CreateField('Create DateTime','Extended Date')).to be true
        end
        it 'Add Transform Groups' do
            @profile.RemoveExistingTransforms                        
            expect(@profile.AddGroup('DateTime Transforms', 'DateTimeFormat HH:mm')).to be true
            expect(@profile.AddGroup('ProdBeg Transforms', 'Trim BAPE')).to be true
            expect(@profile.AddGroup('ProdEnd Transforms', 'NULL')).to be true
        end
        it 'Associates Transforms to Fields' do
            expect(@profile.MatchTransforms('ProdBeg','Production Begin', 'Trim BAPE')).to be true
            expect(@profile.MatchTransforms('ProdEnd','Production End', 'NULL')).to be true            
            expect(@profile.MatchTransforms('Create DateTime','Create Time', 'DateTimeFormat HH:mm')).to be true
            expect(@profile.MatchTransforms('Create DateTime','Create Date', 'DateTimeFormat mm/dd/yyyy')).to be true
            expect(@profile.MatchTransforms('Create DateTime','Extended Date', 'DateTimeFormat dddd, MMMM dd, yyyy')).to be true
        end
        it 'Saves Profile' do
            expect(@profile.Save(@profile_name)).to be true
        end
    end
    context 'Compares Output to Mock Smoke File' do
        it 'Runs Transform and Compares Output' do
            $browser.ElementByCss('#production-tabs > div > ul > li:nth-child(2) > a').click
            sleep 4
            expect(FileUtils.compare_file(ProfileMock::Output['H11344_10R'], @output_path)).to be true            
        end
    end
end