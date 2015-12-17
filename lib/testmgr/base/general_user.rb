
class GeneralUser
  attr_accessor :login_id, :login_password, :role

  def initialize
    @login_id=''
    @login_password=''
    @role=''
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
