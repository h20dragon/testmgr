
class GeneralUser
  attr_accessor :login_id, :login_password, :role

  def initialize
    @login_id='lsmith@test.com'
    @login_password='1qaz@WSX'
    @role='PrescriberAgent'
  end

  def setLoginPassword(s=nil)
    @login_password=s.to_s
  end

  def setLoginId(s=nil)
    @login_id=s.to_s
  end

  def getLoginId()
    @login_id
  end

  def getLoginPassword()
    @login_password
  end

end
