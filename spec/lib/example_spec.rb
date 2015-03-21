require 'spec_helper'
require 'aws-sdk'

RSpec.describe Aws::S3 do
  let(:s3_client) do
    Aws::S3::Client.new(
      :access_key_id => 'YOUR_ACCESS_KEY_ID',
      :secret_access_key => 'YOUR_SECRET_ACCESS_KEY',
      :region => 'ap-northeast-1',
      :endpoint => "http://#{Glint::Server.info[:fakes3][:address]}/",
      :force_path_style => true)
  end

  before do
    Aws::S3::Resource.new(client: s3_client)
      .create_bucket(bucket: 'mybucket')
      .put_object(key: 'myobject', body: 'this is a pen.')
  end

  it 'バケットを作れること' do
    expect(Aws::S3::Resource.new(client: s3_client).bucket('mybucket'))
      .to be_an_instance_of Aws::S3::Bucket
  end

  it 'オブジェクトを作れること' do
    expect(s3_client.get_object(bucket: 'mybucket', key: 'myobject').body.read).to eq 'this is a pen.'
  end
end
