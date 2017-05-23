require "spec_helper"
require 'pry'
require 'models/HlmcBilling'
require 'models/ContractTerms'
require 'byebug'

describe "Hlmc Billing" do
  before {
    @url = HlmcBillingUrl.const_get($env)
	  $browser.goto @url
  	@hlmc = HlmcBilling.new
  }
  
  context 'While deleting Billing item' do
     before {
       @hlmc.ProjectBillingDelete
     }
     it "should verify billing items delete" do
       expect($browser.ElementByCss("body > div.main-container > div > div.container > div.billingMoveUp > table > tbody > tr > td:nth-child(2) > div > div:nth-child(2) > a").visible?).to eq(true)
     end
   end
  context 'While adding billing item' do
  	before {
  		@hlmc.AddBillingItem(HlmcBillingMock::AddBillingMock)
      @hlmc.SelectBillingPeriod("04/2016")
    }
      it "should add new billing Item" do
          expect(@hlmc.GetProjectBillingItemModels()[0]).to eq(HlmcBillingMock::VerifyBillingMock)
    	end
    end

      context 'While adding billing item' do
      	before {
      		@hlmc.AddBillingItem(HlmcBillingMock::AddBillingMock)
          @hlmc.SelectBillingPeriod("04/2016")
        }
          it "should add new billing Item" do
              expect(@hlmc.GetProjectBillingItemModels()[0]).to eq(HlmcBillingMock::VerifyBillingMock)
        	end
        end

      context 'While editing Billing item' do
      	before {
      		@hlmc.ProjectBillingEdit(HlmcBillingMock::EditBillingMock)
          @hlmc.SelectBillingPeriod("04/2016")
        }
          it "should edit Billing Item" do
        			expect(@hlmc.GetProjectBillingItemModels()[0]).to eq(HlmcBillingMock::VerifyEditBillingMock)
        	end
      end

       context 'While attaching files to Billing items' do
         before {
             @hlmc.ProjectBillingAttach
         }
         it "should verify attaching files to Billing items" do
             expect(@hlmc.ProjectBillingAttach)
         end
       end
       context 'While deleting Billing item' do
          before {
            @hlmc.ProjectBillingDelete
          }
          it "should verify billing items delete" do
            expect($browser.ElementByCss("body > div.main-container > div > div.container > div.billingMoveUp > table > tbody > tr > td:nth-child(2) > div > div:nth-child(2) > a").visible?).to eq(true)
          end
        end

      context 'While auditing Billing item' do
        before {
            @hlmc.ProjectBillingAudithistory
        }
        it "should verify ProjectBillingAudit" do
            expect($browser.ElementByCss("#auditHistoryDiv > a").visible?).to eq(true)
        end
      end
      context 'While opening Timecard Roll up' do
        before {
            @hlmc.ProjectBillingTimecardRollup
        }
        it "should verify ProjectBillingTimecardRollup" do
          expect($browser.ElementByCss("#eliteRollupDiv > a").visible?).to eq(true)
       end
      end

      context 'While opening Project Billing report' do
        before {
            @hlmc.ProjectBillingReport
        }
        it "should verify ProjectBillingReport" do
           expect($browser.ElementByCss("body > div.main-container > div > div.container > div.ProjectBillingReportDiv > a").visible?).to eq(true)
        end
      end
      context 'While opening Engagement Billing report' do
        before {
            @hlmc.EngagementBillingReport
        }
        it "should verify Engagement Billing report" do
          expect($browser.ElementByCss("body > div.main-container > div > div.container > div.billingMoveUp > div:nth-child(3) > a").visible?).to eq(true)
        end
      end
      context 'While Cetifying Billing Items' do
      	before {
      		  @hlmc.ProjectBillingCertify
        }
        it "should verify ProjectBillingCertify" do
          expect($browser.ElementByCss("#billingPeriodStatusDiv > div:nth-child(1) > a > div").visible?).to eq(true)
        end
      end
      context 'While locking Billing item' do
        before {
            @hlmc.ProjectBillingLock
        }
        it "should verify ProjectBillingLock" do
           expect($browser.ElementByCss(".billingPeriodLockIcon").visible?).to eq(true)
        end
      end

    end
