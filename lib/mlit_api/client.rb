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

    def urls(**args)
      params = args.slice(:identifier, :fiscalyear)
      doc = REXML::Document.new url_contents(params)
      REXML::XPath.match(doc, '//KSJ_URL/item').map do |node|
        url_attributes.each_with_object({}) do |attr, h|
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

    def url_resource_path
      'ksj/api/1.0b/index.php/app/getKSJURL.xml'
    end

    def url_contents(**params)
      base_params = { appId: 'ksjapibeta1', lang: 'J', dataformat: 1 }
      @conn.get(url_resource_path, base_params.merge(params)).body
    end

    def url_attributes
      %i(identifier title field year areaType areaCode datum zipFileUrl zipFileSize)
    end
  end
end
