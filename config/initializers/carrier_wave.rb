if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAIP76NFV35SKHRD7A'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['testbucket4112']
  end
end