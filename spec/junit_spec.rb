require 'rspec'
require 'spec_helper'  # Needed for resolving Testmgr classes


describe Testmgr do


  it 'create testreport' do
    Testmgr::TestReport.instance.setDescription('ScoutUI Test')
    Testmgr::TestReport.instance.setEnvironment(:qa, "MyTests")

    Testmgr::TestReport.instance.setHost('http://voteforpedro.com')
    Testmgr::TestReport.instance.setBrowserUnderTest('firefox')
    Testmgr::TestReport.instance.addRequirement('UI')
    Testmgr::TestReport.instance.getReq('UI').add(Testmgr::TestCase.new('visible_when', "visible_when"))
    Testmgr::TestReport.instance.addRequirement('Command')
    Testmgr::TestReport.instance.getReq('Command').add(Testmgr::TestCase.new('isValid', "isValid"))


    Testmgr::TestReport.instance.getReq('UI').testcase('visible_when').add(true, "Pass 1")
    Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(true, "Pass 2")
    Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(true, "Pass 3")
    Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(true, "Pass 4")
    Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(true, "Pass 5")
    Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(false, "Failed 6")

    Testmgr::TestReport.instance.getReq('UI').get_child('visible_when').add(nil, "This was skipped 7")

    Testmgr::TestReport.instance.getReq('GOV123').get_child('Blah').add(nil, "This was skipped 7")
  end


  it 'should create TAP object' do
    rc=Testmgr::TestReport.instance.junitReport()
    puts __FILE__ + (__LINE__).to_s + " => #{rc.to_s}"
    expect(rc).not_to be_nil
  end


  it 'should create JUNIT XML file' do
    expect(Testmgr::TestReport.instance.junitReport('/tmp/junit.example.xml')).to be true
  end

end

