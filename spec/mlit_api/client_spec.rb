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

  describe :urls do
    let(:id) { 'L01' }
    let(:year) { 2018 }
    let(:xml) { File.read('spec/fixtures/files/KSJUrl.xml') }

    subject { client.urls(identifier: id, fiscalyear: year) }

    before { allow(client).to receive(:url_contents) { xml } }

    it { is_expected.to be_a Array }
    it { expect(subject.length).to eq 48 }
    it { expect(subject.first[:identifier]).to eq 'L01' }
    it { expect(subject.first[:title]).to eq '地価公示' }
    it { expect(subject.first[:field]).to eq '国土（水・土地）' }
    it { expect(subject.first[:year]).to eq '2018' }
    it { expect(subject.first[:areaType]).to eq '3' }
    it { expect(subject.first[:areaCode]).to eq '0' }
    it { expect(subject.first[:datum]).to eq '1' }
    it { expect(subject.first[:zipFileUrl]).to eq 'http://nlftp.mlit.go.jp/ksj/gml/data/L01/L01-18/L01-18_GML.zip' }
    it { expect(subject.first[:zipFileSize]).to eq '15.70MB' }
  end
end
