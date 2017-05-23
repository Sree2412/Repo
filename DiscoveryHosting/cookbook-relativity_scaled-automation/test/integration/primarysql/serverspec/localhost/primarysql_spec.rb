require 'spec_helper'

describe package 'Relativity' do
  it { should be_installed }
end

describe package 'Relativity Primary Database' do
  it { should be_installed }
end

describe package 'Relativity Primary Procuro' do
  it { should be_installed }
end
