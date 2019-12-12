require "test_helper"

class ModAdapTest < Minitest::Test
  #def test_that_it_has_a_version_number
  #  refute_nil ::ModAdap::VERSION
  #end

#  def test_raise_error_if_params_is_nil
#    exception = assert_raises RuntimeError do
#      Adap.new(nil)
#    end
#    assert_equal(exception.message, "Initialize Adap was failed. params must not be nil")
#  end
#
#  def test_raise_error_if_params_doesnt_have_ad_host
#    exception = assert_raises RuntimeError do
#      Adap.new({
#        :ad_binddn => "CN=Administrator,CN=Users,DC=mysite,DC=example,DC=com",
#        :ad_basedn => "CN=Users,DC=mysite,DC=example,DC=com",
#        :nt_host   => "192.168.1.12",
#        :nt_binddn => "uid=Administrator,ou=Users,dc=mysite,dc=example,dc=com",
#        :nt_basedn => "dc=mysite,dc=example,dc=com"
#      })
#    end
#  end

  # get_operation_result will returns...
  #   if success:
  #     #<OpenStruct extended_response=nil, code=0, error_message="", matched_dn="", message="Success">
  #   else if failed:
  #     #<OpenStruct extended_response=nil, code=65, error_message="no objectClass attribute", matched_dn="", message="Object Class Violation">

  def test_add_user_should_failed_if_ldap_add_was_failed

    mock = MiniTest::Mock.new
    mock_get_operation_result = MiniTest::Mock.new

    def mock_get_operation_result
      return 1
    end

    # @ldap_client.add
    mock.expect(
      :add, true, [{
        :dn => "uid=foo,ou=Users,dc=mysite,dc=example,dc=com",
        :attributes => {
          :objectclass => ["top", "person"],
          :cn => "foo"
        }
      }]
    )

    # @ldap_client.get_operation_result.code
    mock_get_operation_result.expect(:code, 1, [])
    mock.expect(:get_operation_result, mock_get_operation_result, [])
    # :ret => get_operation_result.code
    mock_get_operation_result.expect(:code, 1, [])
    mock.expect(:get_operation_result, mock_get_operation_result, [])
    # :message => get_operation_result.error_message
    mock_get_operation_result.expect(:error_message, "Some error", [])
    mock.expect(:get_operation_result, mock_get_operation_result, [])

    Net::LDAP.stub :new, mock do
      adap = Adap.new({
        :ad_host   => "localhost",
        :ad_binddn => "CN=Administrator,CN=Users,DC=mysite,DC=example,DC=com",
        :ad_basedn => "CN=Users,DC=mysite,DC=example,DC=com",
        :ldap_host   => "192.168.1.12",
        :ldap_binddn => "uid=Administrator,ou=Users,dc=mysite,dc=example,dc=com",
        :ldap_basedn => "dc=mysite,dc=example,dc=com"
      })
      ret = adap.add_user(
        "uid=foo,ou=Users,dc=mysite,dc=example,dc=com",
        {:objectclass => ["top", "person"], :cn => "foo"},
        "secret"
      )
      assert_equal({:code => 1, :message => "ERROR: Failed to ldap add - Some error"}, ret)
    end

  end

#  def test_it_does_something_useful
#    adnt = Adap.new({
#      :ad_host => "192.168.1.10",
#      :ad_binddn => "CN=Administrator,CN=Users,DC=mysite,DC=example,DC=com",
#      :ad_basedn => "DC=mysite,DC=example,DC=com",
#    })
#    puts adnt.display()
#  end


end
