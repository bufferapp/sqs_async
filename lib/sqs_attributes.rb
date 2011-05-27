require 'nokogiri'
require 'json'
require 'base64'
require 'ostruct'

class SQSAttributes
  attr_accessor :approximate_number_of_messages,
    :approximate_number_of_messages_not_visible,
    :visibility_timeout,
    :create_timestamp,
    :last_modified_timestamp,
    :policy,
    :maximum_message_size,
    :message_retention_period,
    :queue_arn

  def self.parse(xml)
    doc = Nokogiri::XML(xml)
    queue_data = SQSAttributes.new
    doc.search("Attribute").each do |attribute|
      meth = underscore(attribute.at("Name").text.strip)
      if queue_data.respond_to? meth.to_sym
        queue_data.send "#{meth}=", attribute.at("Value").text.strip
      end
    end
    queue_data
  end

  # Taken from ActiveSupport. License information can be found at rubyonrails.org
  def self.underscore(camel_cased_word)
    word = camel_cased_word.to_s.dup
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end
