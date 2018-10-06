# frozen_string_literal: true

RSpec.describe MlitApi::Client do
  let(:client) { MlitApi::Client.new }
  let(:xml) { File.read('spec/fixtures/files/KSJSummary.xml') }

  before { allow(client).to receive(:summary_contents) { xml } }

  describe :summaries do
    subject { client.summaries }

    it { is_expected.to be_a Array }
    it { expect(client.summaries.length).to eq 108 }
    it { expect(client.summaries.first[:identifier]).to eq 'A03' }
    it { expect(client.summaries.first[:title]).to eq '三大都市圏計画区域' }
    it { expect(client.summaries.first[:field1]).to eq '政策区域' }
    it { expect(client.summaries.first[:field2]).to eq '大都市圏' }
    it { expect(client.summaries.first[:areaType]).to eq '2' }
  end
end
