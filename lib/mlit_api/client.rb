# frozen_string_literal: true

require 'faraday'
require 'rexml/document'

module MlitApi
  class Client
    def initialize
      @conn = Faraday.new 'http://nlftp.mlit.go.jp'
    end

    # @return [Array]
    def summaries
      doc = REXML::Document.new summary_contents
      REXML::XPath.match(doc,'//KSJ_SUMMARY/item').map do |node|
        summary_attributes.each_with_object({}) do |attr, h|
          h[attr] = node.elements[attr.to_s]&.text
        end
      end
    end

    private

    def summary_resource_path
      'ksj/api/1.0b/index.php/app/getKSJSummary.xml'
    end

    def summary_params
      {
        appId: 'ksjapibeta1',
        lang: 'J',
        dataformat: 1
      }
    end

    def summary_contents
      @conn.get(summary_resource_path, summary_params).body
    end

    def summary_attributes
      %i(identifier title field1 field2 areaType)
    end
  end
end
