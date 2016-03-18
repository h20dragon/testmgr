require_relative('../lib/testmgr')


Testmgr::TestReport.instance.addRequirement('REQ-ABC')
req=Testmgr::TestReport.instance.getReq('REQ-ABC')


Testmgr::TestReport.instance.getReq('REQ-ABC').add(Testmgr::TestCase.new('visible_when', "Dynamic"))

tc = Testmgr::TestReport.instance.getReq('REQ-ABC').tc('visible_when').add(true, 'Must be true')



Testmgr::TestReport.instance.getReq('REQ-ABC').tc('visible_when').add(false, 'Must be false')

Testmgr::TestReport.instance.getReq('REQ-ABC').get_child('peter').add(true, 'Peter 1')

Testmgr::TestReport.instance.report()

puts Testmgr::TestReport.instance.getMetrics()

