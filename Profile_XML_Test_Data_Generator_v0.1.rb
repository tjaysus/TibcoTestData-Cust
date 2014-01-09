# encoding: utf-8
# Creation of Customer Profile Service test data for Tesco-Dunnhumby Tibco testing.
# All data follows suggested format but is aimed to be hyperthetical, non-live data

# To reference output directories and filenames 
module Outputs
	Output_Directory = 'D:\Code\TibcoTestDataGenerator\\'
	Output_Filename = 'profile_service_fake_response.xml'
end

# A Profile Record to return keys and values for each parameter returned by the Profile Service and setup all static data
# Records are built from random selection from these data arrays. One array for each of the parameters returned from the Profile Service. 

class ProfileRecord
  @count = 0
  class << self
    attr_accessor :count
  end

	@customerIdentifier
  
  attr_accessor :customerIdentifier
  
  def initialize
    self.class.count += 1
	end
  def get_customerIdentifier
    self.customerIdentifier = "86b28834-12c4-4c16-898d-" + "%012d" % ProfileRecord.count
    @customerIdentifier
  end
  def create_record
    @profile_record = 
      "<customer>
        <versionedCustomerIdentifier>
          <uniqueCustomerIdentifier>#{self.get_customerIdentifier}</uniqueCustomerIdentifier>
          <version>1</version>
        </versionedCustomerIdentifier>
        <joinDate>1800-01-01T00:00:00</joinDate>
        <birthday>
          <month>1</month>
          <day>1</day>
        </birthday>
        <accountRelationshipId>0123456789</accountRelationshipId>
        <gender>UNKNOWN</gender>
        <postalAddresses>
          <item>
            <postalAddressType>OTHER</postalAddressType>
            <postcode>AL7 1RZ</postcode>
            <migrationId>1</migrationId>
          </item>
          <item>
            <postalAddressType>OTHER</postalAddressType>
            <postcode>AB12 3DE</postcode>
            <migrationId>2</migrationId>
          </item>
        </postalAddresses>
        <externalCustomerIdentifiers>
          <item>
            <externalSystem>CG</externalSystem>
            <externalCustomerId>1234567</externalCustomerId>
          </item>
        </externalCustomerIdentifiers>
        <electronicAddressTypes>
          <item>EMAIL</item>
        </electronicAddressTypes>
      </customer>"
  end
end

# Profile Response returns a correctly formatted XML response as per the Profile Service
class ProfileResponse
	include Outputs

	def initialize
		@XML_resp_head = 
      "<CustomerChangeEvent xmlns=\"http://services.tesco.com/domain/CustomerProfile/CustomerProfileOutboundBlue-0.0.7\">"
    @XML_resp_tail = 
      "<CustomerChangeEvent xmlns>"
		@XML_resp
	end

	def create_new_response(n) # n, number of records to be returned
    @XML_resp = @XML_resp_head
    n.times do |rec|
  	  rec = ProfileRecord.new.create_record
  	  @XML_resp += rec
  	end
    @XML_resp += @XML_resp_tail
  end

	def write_response_to_file
		File.open("#{Outputs::Output_Directory + Outputs::Output_Filename}", 'w') { |file| file.write(@XML_resp) }
		puts "Profile Service response written to file #{Outputs::Output_Directory + Outputs::Output_Filename}"
	end
end


# prompt user in line for integer value for number of records to be returned
puts "How many fake records do you want to create?"
n = gets.chomp.to_i
resp = ProfileResponse.new
resp.create_new_response(n)
resp.write_response_to_file
