require 'spec_helper'

describe package 'Invariant' do
  it { should be_installed }
end

describe package 'Invariant Database' do
  it { should be_installed }
end

describe package 'Invariant Queue Manager' do
  it { should be_installed }
end
