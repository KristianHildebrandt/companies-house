require 'net/http'
require 'uri'
require 'open-uri'
require 'digest/md5'

require 'morph'
require 'nokogiri'
require 'haml'
require 'yaml'

require File.dirname(__FILE__) + '/companies_house/request'
require File.dirname(__FILE__) + '/companies_house/exception'

$KCODE = 'UTF8' unless RUBY_VERSION >= "1.9"

module CompaniesHouse
  VERSION = "0.1.0" unless defined? CompaniesHouse::VERSION

  class << self

    def name_search name, options={}
      xml = CompaniesHouse::Request.name_search_xml options.merge(:company_name => name)
      get_response(xml)
    end

    def number_search number, options={}
      xml = CompaniesHouse::Request.number_search_xml options.merge(:company_number => number)
      get_response(xml)
    end

    def company_details number, options={}
      xml = CompaniesHouse::Request.company_details_xml options.merge(:company_number => number)
      get_response(xml)
    end

    def sender_id= id
      @sender_id = id
    end

    def sender_id
      config_setup('.') if @sender_id.blank?
      @sender_id
    end

    def password= pw
      @password = pw
    end

    def password
      config_setup('.') if @password.blank?
      @password
    end

    def email= e
      @email = e
    end

    def email
      @email
    end

    def digest_method
      'CHMD5'
    end

    def create_transaction_id_and_digest(options={})
      transaction_id = (Time.now.to_f * 100).to_i
      digest = Digest::MD5.hexdigest("#{options[:sender_id] || sender_id}#{options[:password] || password}#{transaction_id}")
      return transaction_id, digest
    end

    def config_setup root
      config_file = "#{root}/config/companies-house.yml"
      config_file = "#{root}/companies-house.yml" unless File.exist? config_file
      if File.exist? config_file
        config = YAML.load_file(config_file)
        self.sender_id= config['sender_id']
        self.password= config['password']
        self.email= config['email']
      end
    end

    private

      def add_to_message attribute, error, message, suffix=''
        if value = error.at(attribute)
          message << "#{value.inner_text}#{suffix}"
        end
      end

      def raise_error doc
        message = []
        if error = doc.at('Error')
          add_to_message 'RaisedBy', error, message
          add_to_message 'Type', error, message
          add_to_message 'Number', error, message, ':'
          add_to_message 'Text', error, message
        end
        raise CompaniesHouse::Exception.new(message.join(' '))
      end

      def get_response(data, root_element='NameSearch')
        begin
          http = Net::HTTP.new("xmlgw.companieshouse.gov.uk", 80)
          res, body = http.post("/v1-0/xmlgw/Gateway", data, {'Content-type'=>'text/xml;charset=utf-8'})
          case res
            when Net::HTTPSuccess, Net::HTTPRedirection
              xml = res.body
              Hash.from_xml xml
            else
              raise CompaniesHouse::Exception.new(res.inspect.to_s)
          end
        rescue URI::InvalidURIError => e
          raise CompaniesHouse::Exception.new(e.class.name + ' ' + e.to_s)
        rescue SocketError => e
          raise CompaniesHouse::Exception.new(e.class.name + ' ' + e.to_s)
        rescue Timeout::Error => e
          raise CompaniesHouse::Exception.new(e.class.name + ' ' + e.to_s)
        end
      end

  end
end
