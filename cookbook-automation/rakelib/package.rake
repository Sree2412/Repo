# packaging
namespace :build do
  desc 'Generate compressed artifacts for deployment'
  Rake::PackageTask.new('cookbook-cookbook-automation', :noversion) do |p|
    p.version = `cat metadata.rb | grep version | awk -F"'" '{print $2}'`.strip
    # store the version for the StoreArtifacts job to read
    File.open('VERSION', 'w') { |file| file.write(p.version) }
    p.need_tar_gz = true
    p.package_dir = 'artifacts/'
    p.package_files.include('attributes/*.rb',
                            'files/**/**',
                            'libraries/**',
                            'providers/**',
                            'definitions/**',
                            'resources/**',
                            'recipes/*.rb',
                            'templates/**/*.erb',
                            'Berksfile',
                            'Gemfile',
                            'metadata.rb',
                            '*.md',
                            'chefignore')
  end
  CLOBBER.include('VERSION')
  CLOBBER.include('artifacts')
end
