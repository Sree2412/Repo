desc 'Archive artifacts to HLNAS00'
task 'archive' do
  FileUtils.mkdir_p(
    "/mnt/hlnas00/tech/Packages/#{ENV['JOB_NAME']}/#{version?}"
  )
  Dir.glob('artifacts/*.tar.gz').each do |archive_file|
    FileUtils.cp(
      archive_file,
      "/mnt/hlnas00/tech/Packages/#{ENV['JOB_NAME']}/#{version?}/"
    )
  end
end
