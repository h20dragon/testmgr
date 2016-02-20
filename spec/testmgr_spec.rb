require 'rspec'
require 'spec_helper'  # Needed for resolving Testmgr classes


describe Testmgr do
  it 'has a version number' do
    expect(Testmgr::VERSION).not_to be nil
  end

  describe('Dynamic add req') do
    it 'should add req is missing' do
      Testmgr::TestReport.instance.setDescription('add req test')
      Testmgr::TestReport.instance.getReq('Dynamic Req')

      t = Testmgr::TestReport.instance.getReq('Dynamic Req')

      puts __FILE__ + (__LINE__).to_s + " t => #{t.class.to_s}"

      expect(t.instance_of?(Testmgr::TestComposite))

      tc = Testmgr::TestReport.instance.getReq('Dynamic Req').testcase('Peter')
      expect(tc.instance_of?(Testmgr::TestCase))
    end
  end

  it 'should set description' do
    s=Testmgr::TestReport.instance.setDescription('Peter')
    expect(true)
  end

  it 'should add passing assertion' do
    Testmgr::TestReport.instance.setup("XYZ")
    Testmgr::TestReport.instance.setEnvironment(:qa)
    expect(Testmgr::TestReport.instance.add(true, "Add a passing assertion"))
    Testmgr::TestReport.instance.generateReport()
  end

  it 'should create 1 requirement with 1 test case' do
    req = Testmgr::TestComposite.new("Req-000")
    req.add(Testmgr::TestCase.new('TC-A', 'Add account'))
    req.print
    puts "RESULT => " + req.getResult().to_s
    puts '-' * 72
  end

  it 'get nonexisting Req' do
    req=Testmgr::TestReport.instance.getReq('XYZ-123')
    expect(req.nil?)
  end

  it 'should create dynamically' do
    Testmgr::TestReport.instance.addRequirement('REQ-ABC')
    req=Testmgr::TestReport.instance.getReq('REQ-ABC')
    expect(req.instance_of?(Testmgr::TestComposite))

    Testmgr::TestReport.instance.getReq('REQ-ABC').add(Testmgr::TestCase.new('visible_when', "Dynamic"))

    tc = Testmgr::TestReport.instance.getReq('REQ-ABC').tc('visible_when').add(true, 'Must be true')
    expect(tc.instance_of?(Testmgr::TestCase))


    Testmgr::TestReport.instance.getReq('REQ-ABC').tc('visible_when').add(false, 'Must be false')

    Testmgr::TestReport.instance.report()


  end


  it 'should create 1 requirement with 1 test case and 1 assertion' do
    reqX = Testmgr::TestComposite.new("Req-000")
    reqX.add(Testmgr::TestCase.new('TC-A', 'Add account'))
    reqX.get_child('TC-A').add(true, 'Add true')
    reqX.get_child('TC-A').add(true, 'Add true2')
    reqX.print
    puts "RESULT => " + reqX.getResult().to_s
    puts '-' * 72

    expect(reqX.getResult())
  end

  it 'should create qtest' do
    req = Testmgr::TestComposite.new("Req-000")

    tc = Testmgr::TestCase.new("TC_00", "User must provide valid password to login")

    req.add(tc)


    tc2 = Testmgr::TestCase.new("TC_100", "User must provide valid userID")
    tc2.add(true, 'Check header exists')
    tc2.add(false, 'Check div2 visible')
    req.add(tc2)


    req_sub = Testmgr::TestComposite.new("Req-000.Password")
    req_sub.add(Testmgr::TestCase.new("TC_200", "Submit button must be clicked"))

    req.add(req_sub)
    req.print

    puts "RESULT => " + req.getResult().to_s

    puts '-' * 72

    req.get_child("TC_100").print

    expect(!req.getResult())


  end



end

describe 'Verify TestCase object' do

  it 'test case with 1 assertion should pass' do
    req = Testmgr::TestComposite.new("Req-999")

    tc = Testmgr::TestCase.new("TC_000", "User must provide valid password to login")
    tc.add(true, 'Passed assertion #1 added')

    req.add(tc)
    expect(tc.passed? && tc.totalAssertions()==1)
  end


  it 'test case with 1 passing and 1 failingn assertion should fail' do
    req = Testmgr::TestComposite.new("Req-1000")

    tc = Testmgr::TestCase.new("TC_000", "User must provide valid password to login")
    tc.add(true, 'Passed assertion #1 added')
    tc.add(false, 'Failed assertion #2 added')

    req.add(tc)
    expect(tc.failed? && tc.totalAssertions()==2)
  end



end