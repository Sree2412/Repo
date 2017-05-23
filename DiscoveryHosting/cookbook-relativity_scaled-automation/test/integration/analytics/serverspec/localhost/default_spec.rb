require 'spec_helper'

describe 'Directories were created' do
  describe file 'F:\Analytics\Indexes' do
    it { should be_directory }
  end
end
