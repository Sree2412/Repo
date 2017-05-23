require 'spec_helper'

describe package 'Relativity' do
  it { should be_installed }
end

describe package 'Relativity Service Host' do
  it { should be_installed }
end

describe package 'Relativity Web' do
  it { should be_installed }
end
