
require 'singleton'

#require 'general_user'

module Testmgr

class TestReport
  include Singleton

  DEFAULT_REQ='__TBD__'

  attr_accessor :completed
  attr_accessor :description
  attr_accessor :environment_under_test
  attr_accessor :tStart, :tEnd
  attr_accessor :test_list
  attr_accessor :browser_under_test
  attr_accessor :data_under_test
  attr_accessor :worksheet_under_test
  attr_accessor :req_list
  attr_accessor :requirements

  attr_accessor :current_rec

  attr_accessor :verbose
  attr_accessor :generalUser


  def initialize()
    @verbose=false
    @description=""
    @current_rec = { :req => DEFAULT_REQ, :tc => DEFAULT_REQ}
    @test_list = []
    @req_list = []
    @requirements=[]
    @environment_under_test=:qa
    @id_under_test=nil
    @tStart=Time.now


    @generalUser=GeneralUser.new()
  end

  def verbose
    @verbose
  end

  def enableVerbose
    @verbose=true
  end

  def disableVerbose
    @verbose=false
  end

  def setCurrentReq(_r=DEFAULT_REQ)
    @current_rec[:req]=_r
  end

  def setCurrentRequirement(_r=DEFAULT_REQ)
    setReq(_r)
  end

  def getCurrentReq()
    @current_rec[:req]
  end

  def getCurrentRequirement()
    getReq()
  end

  def getCurrentTC()
    @current_rec[:tc]
  end

  def getCurrentTestCase()
    getTC()
  end

  def setCurrentTC(_t=DEFAULT_REQ)
    @current_rec[:tc]=_t
  end

  def setCurrentTestCase(_t=DEFAULT_REQ)
    setTC(_t)
  end

  def setDescription(s)
    @description=s.to_s
  end

  def getDescription()
    @description.to_s
  end

  # Environments
  # => :qa
  # => :cert
  # => :dev
  # => :prod
  def setup(description="TBD")
    TestReport.instance.setDescription(description)

    @tStart=Time.now()
    @completed=false
  end

  ##
  # START Commands
  ##


  ##
  # END Commands
  ##

  def completed()
    @completed=true
    @tCompleted=Time.now
  end

  def completedDate()
    @tCompleted
  end


  def completed?
    @completed
  end

  def getUser()
    @generalUser
  end

  def getGeneralUser()
    @generalUser
  end

  def getId()
    @id_under_test
  end


  def setLoginId(s=nil)
    @generalUser.setLoginId(s)
  end

  def setLoginPassword(s=nil)
    @generalUser.setLoginPassword(s)
  end

  def getLoginPassword()
    @generalUser.getLoginPassword()
  end

  def setWorkSheet(s)
    @worksheet_under_test=s
  end





  def getWorkSheet()
    @worksheet_under_test
  end

  def getLoginId()
    @generalUser.getLoginId()
  end

  def teardown()
    TestReport.instance.generateReport()
  end

  def endTest()
    @tEnd=Time.now()
  end

  def setDataUnderTest(d)
    @data_under_test=d
  end

  def getDataUnderTest()
    @data_under_test
  end

  # Environments
  # => :qa
  # => :cert
  # => :dev
  # => :prod
  def setEnvironment(e=:qa, url=nil)
    env={
        :qa   => { :name => 'QA',   :description => 'QA Env',  :url => 'https://www.qa.com'   },
        :qa2  => { :name => 'QA2',  :description => 'QA2 Env', :url => 'https://www.qa2.com' },
        :prod => { :name => 'PROD', :description => 'CERT',    :url => 'https://www.prod.com' }
    }


    if url.nil?
      @environment_under_test=env[e]
    else
      @environment_under_test={ :name => 'custom', :url => url.to_s }
    end


  end

  def getEnvironment()
    @environment_under_test
  end

  def setBrowserUnderTest(bType=:firefox)
    @browser_under_test=bType
    TestUtils.setDefaultBrowser(bType)
  end

  # if the requirement doesn't exist, then add it.
  def getReq(req)
    @requirements.each do |r|
      if r.get_name==req
        return r
      end
    end

    addRequirement(req).last
  #  return nil
  end

  def addRequirement(req)
    @requirements << Testmgr::TestComposite.new(req)
  end

  def addReq(r)
    @req_list << r.to_s
  end

  def add(rc, description)

    if !rc
      begin
        raise "Failed QA Test"
      rescue Exception => e
        puts e.backtrace
      end

      TestUtils.hitKey(__FILE__ + (__LINE__).to_s + " Test Fail : #{description.to_s}- HIT KEY")
    end

    puts __FILE__ + (__LINE__).to_s + " #{description.to_s} : #{rc.to_s}" if @verbose
    @test_list.push({ :rc => rc, :description => description})
    rc
  end

  # Obtain time diff in milliseconds
  # Example:
  # => t1 = Time.now
  # => ....
  # => t2 = Time.now
  # => TestUtils.time_diff_milli(t2, t1)
  def time_diff_milli(start, finish=Time.now)
    rc=(finish - start) * 1000.0
  end

  def execute(procs)

    begin
      puts __FILE__ + (__LINE__).to_s + " == execute() ==" if @verbose

      if procs.has_key?(:setup)
        procs[:setup].call
      else
        puts __FILE__ + (__LINE__).to_s + " | execute default setup()" if @verbose
        TestReport.instance.setup
      end

      if procs.has_key?(:execute)
        procs[:execute].call
      end

      TestReport.instance.completed()

    rescue Exception => e
      puts __FILE__ + (__LINE__).to_s + " == Message :\n" + e.message
      puts $@

    ensure

      if procs.has_key?(:teardown)
        procs[:teardown].call
      else
        TestReport.instance.teardown()
      end

    end

    puts __FILE__ + (__LINE__).to_s + " == exit execute() ==" if @verbose
  end


  def report()
    puts "\n\n== Test Report ==\n"

    @requirements.each do |r|
      r.print
    end
  end

  def _passed?(metrics)
    metrics[:total] > 0 && metrics[:passed] > 0 && metrics[:failed] == 0
  end


  def getMetrics()
    puts "\n\n== Test Metrics ==\n"

    asserts_metrics={:passed => 0, :failed => 0, :skipped => 0, :total => 0, :result => nil}

    tc_metrics = {:passed => 0, :failed => 0, :skipped => 0, :total => 0 }

    rq_metrics = {:passed => 0, :failed => 0, :skipped => 0, :total => 0 }

    rc=true

    @requirements.each do |r|
      puts "#{r.class.to_s}"

      rq_metrics[:total]+=1

      if r.is_a?(Testmgr::TestComposite)
        _m=r.getMetrics
        asserts_metrics[:total]  += _m[:total]
        asserts_metrics[:passed] += _m[:passed]
        asserts_metrics[:failed] += _m[:failed]


        tc_metrics[:total]+=r.totalTestCases()
        if _passed?(_m)
          tc_metrics[:passed]+=1
        else
          tc_metrics[:failed]+=1
        end

      else
        puts "Unhandled : #{r.class.to_s}"
      end

      if _passed?(tc_metrics)
        rq_metrics[:passed]+=1
      else
        rq_metrics[:failed]+=1
      end


    end

    rc = rq_metrics[:failed] == 0 && tc_metrics[:failed] && asserts_metrics[:failed]==0


    asserts_metrics[:result] = _passed?(asserts_metrics)

    { :rc => rc, :assertions => asserts_metrics, :testcases => tc_metrics, :requirements => rq_metrics }
  end

  def generateReport()
    endTest()

    puts "\n\n==== TEST REPORT SUMMARY ====\n"
    final_result=true
    passed=0
    failed=0

    i=0
    @test_list.each do |rc|
      puts i.to_s + '. ' + rc[:description].to_s + ' : ' + rc[:rc].to_s
      final_result &&= rc[:rc]

      if rc[:rc]
        passed += 1
      else
        failed += 1
      end

      i+=1
    end

    nAsserts = @test_list.size

    final_result &&=@completed

    puts "\n\nRequirements : " + @req_list.join(', ').to_s
    puts "Description : #{@description.to_s}"
    puts "Total assertions : #{nAsserts.to_s}"
    puts "\n\nPassed : #{passed.to_s}/#{nAsserts.to_s}"
    puts "Failed : #{failed.to_s}/#{nAsserts.to_s}"
    puts "Completed : #{@completed.to_s}"
    puts "Browser: #{@browser_under_test.to_s}"
#    puts "Env    : #{@environment_under_test[:name].to_s}"
#    puts "URL    : " + @environment_under_test[:url].to_s
#    puts "Login  : " + getLoginId().to_s
#    puts "DUT    : " + @data_under_test.to_s
    puts "Start/End  : #{@tStart.to_s}" + " / #{@tEnd.to_s}"
    elapsed_time=time_diff_milli(@tStart)
    puts "Elapsed time : #{elapsed_time.to_s} msec."
    puts "\n\nT*** Test Result : #{final_result.to_s} ***"
  end

end

end
