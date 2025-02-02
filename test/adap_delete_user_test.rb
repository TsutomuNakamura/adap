
require "test_helper"

class ModAdapTest < Minitest::Test
  def test_delete_user_should_failed_if_ldap_delete_was_failed
    mock                            = mock_ad_and_ldap_connections()
    mock_ldap_get_operation_result  = mock()

    # @ldap_client.delete
    mock[:ldap_client]
      .expects(:delete)
      .with(:dn => "uid=foo,ou=Users,dc=mysite,dc=example,dc=com")
      .returns(true)

    # @ldap_client.get_operation_result.code of @ldap_client.delete
    mock_ldap_get_operation_result.expects(:code).returns(1)
    mock_ldap_get_operation_result.expects(:error_message).returns("Some error")
    mock[:ldap_client]
      .expects(:get_operation_result)
      .returns(mock_ldap_get_operation_result).times(2)

    adap = Adap.new({
      :ad_host              => "localhost",
      :ad_bind_dn           => "CN=Administrator,CN=Users,DC=mysite,DC=example,DC=com",
      :ad_user_base_dn      => "CN=Users,DC=mysite,DC=example,DC=com",
      :ad_group_base_dn     => "CN=Users,DC=mysite,DC=example,DC=com",
      :ad_password          => "ad_secret",
      :ldap_host            => "ldap_server",
      :ldap_bind_dn         => "uid=Administrator,ou=Users,dc=mysite,dc=example,dc=com",
      :ldap_user_base_dn    => "ou=Users,dc=mysite,dc=example,dc=com",
      :ldap_group_base_dn   => "ou=Groups,dc=mysite,dc=example,dc=com",
      :ldap_password        => "ldap_secret"
    })

    ret = adap.delete_user("uid=foo,ou=Users,dc=mysite,dc=example,dc=com")
    assert_equal({:code => 1, :operations => [:delete_user], :message => "Failed to delete a user uid=foo,ou=Users,dc=mysite,dc=example,dc=com in delete_user() - Some error"}, ret)
  end

  def test_delete_user_should_success
    mock                            = mock_ad_and_ldap_connections()
    mock_ldap_get_operation_result  = mock()

    # @ldap_client.delete
    mock[:ldap_client]
      .expects(:delete)
      .with(:dn => "uid=foo,ou=Users,dc=mysite,dc=example,dc=com").returns(true)

    # @ldap_client.get_operation_result.code of @ldap_client.delete
    mock_ldap_get_operation_result
      .expects(:code).returns(0)
    mock[:ldap_client]
      .expects(:get_operation_result).returns(mock_ldap_get_operation_result)

    adap = Adap.new({
      :ad_host              => "localhost",
      :ad_bind_dn           => "CN=Administrator,CN=Users,DC=mysite,DC=example,DC=com",
      :ad_user_base_dn      => "CN=Users,DC=mysite,DC=example,DC=com",
      :ad_group_base_dn     => "CN=Users,DC=mysite,DC=example,DC=com",
      :ad_password          => "ad_secret",
      :ldap_host            => "ldap_server",
      :ldap_bind_dn         => "uid=Administrator,ou=Users,dc=mysite,dc=example,dc=com",
      :ldap_user_base_dn    => "ou=Users,dc=mysite,dc=example,dc=com",
      :ldap_group_base_dn   => "ou=Groups,dc=mysite,dc=example,dc=com",
      :ldap_password        => "ldap_secret"
    })

    ret = adap.delete_user("uid=foo,ou=Users,dc=mysite,dc=example,dc=com")
    assert_equal({:code => 0, :operations => [:delete_user], :message => nil}, ret)
  end
end
