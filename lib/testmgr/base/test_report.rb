
require 'singleton'

#require 'general_user'

module Testmgr

class TestReport
  include Singleton

  attr_accessor :webApp
  attr_accessor :completed
  attr_accessor :description
  attr_accessor :environment_under_test
  attr_accessor :tStart, :tEnd
  attr_accessor :test_list
  attr_accessor :browser_under_test
  attr_accessor :data_under_test
  attr_accessor :drugUnderTest
  attr_accessor :worksheet_under_test
  attr_accessor :req_list
  attr_accessor :test_patient
  attr_accessor :patient_class_file
  attr_accessor :patient_worksheet    # Worksheet name from patient-class XLS file

  attr_accessor :generalUser

  def initialize()
    puts 'TestReport.initialize()'
    @description=""
    @test_list = []
    @req_list = []
    @environment_under_test=:qa
    @id_under_test=nil
    @patient_worksheet=nil
    @patient_class_file='c:/tmp/patient-class.xls'
    @webApp=nil
    @generalUser=GeneralUser.new()
    @test_patient={}
    @moxywidgets={}
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

#    options=TestUtils.parseOptions()



#    TestReport.instance.setEnvironment(options[:env].to_sym, options[:url])
#    TestReport.instance.setBrowserUnderTest(options[:browser].to_sym)
#    TestReport.instance.setDataUnderTest(options[:dut])
#    TestReport.instance.setWorkSheet(options[:worksheet])
    #TestReport.instance.setPatientWorkSheet(options[:patient_worksheet])
#    @id_under_test=options[:id]
    # GeneralUser
#    TestReport.instance.setLoginPassword(options[:password])
#    TestReport.instance.setLoginId(options[:userid])

#   TestReport.instance.setPatientClassFile(options[:patient_class_file])
  end

  ##
  # START Commands
  ##

  def webApp()
  end




  def setWebApp(w)
    puts __FILE__ + (__LINE__).to_s + " setWebApp(#{w.class.to_s})"
    @webApp=w
  end


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

  def getPatientClassFile()
    @patient_class_file
  end

  def setPatientClassFile(f)
    if !f.nil?
      @patient_class_file=f.to_s
    end
    @patient_class_file
  end

  def setLoginId(s=nil)
    puts __FILE__ + (__LINE__).to_s + " setLoginId(#{s.to_s})"
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

  def setPatientWorkSheet(s)
    @patient_worksheet=s
  end

  def getPatientWorkSheet()
    @patient_worksheet
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
        :qa   => { :name => 'QA',   :description => 'QA Env',  :url => 'https://ww0.drfirst.com'   },
        :qa2  => { :name => 'QA2',  :description => 'QA2 Env', :url => 'https://qa2-187-1001.qa.drfirst.com/login.jsp' },
        :cert => { :name => 'CERT', :description => 'CERT',    :url => 'https://cert.drfirst.com' }
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

    puts __FILE__ + (__LINE__).to_s + " #{description.to_s} : #{rc.to_s}"
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
      puts __FILE__ + (__LINE__).to_s + " == execute() =="

      if procs.has_key?(:setup)
        procs[:setup].call
      else
        puts __FILE__ + (__LINE__).to_s + " | execute default setup()"
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

    puts __FILE__ + (__LINE__).to_s + " == exit execute() =="
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
    puts "Env    : #{@environment_under_test[:name].to_s}"
    puts "URL    : " + @environment_under_test[:url].to_s
    puts "Login  : " + getLoginId().to_s
    puts "DUT    : " + @data_under_test.to_s
    puts "Start/End  : #{@tStart.to_s}" + " / #{@tEnd.to_s}"
    elapsed_time=time_diff_milli(@tStart)
    puts "Elapsed time : #{elapsed_time.to_s} msec."
    puts "\n\nTest Result : #{final_result.to_s}"
  end

end

end
