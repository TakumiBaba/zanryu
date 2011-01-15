# -*- encoding: utf-8 -*-

require 'socket'
require 'mechanize'

sfs = "https://vu8.sfc.keio.ac.jp/sfc-sfs"
lecname = "授業名"
yourphonenumber = "電話番号"
parentsphonenumber = "保護者の電話番号"
staytime = "帰宅時間"
selectroom = "棟番号"
=begin
1 => k
2 => e
3 => i
4 => o
5 => λ
6 => Δ
7 => τ
8 => Ζ
9 => ν
10 => Ω
11 =>その他
=end
selectfloor = "階数"
roomnumber = "教室番号"
reason = "残留の理由"

username ="CNSのアカウント"
password ="CNSのパスワード"

myip = Socket.getaddrinfo(Socket.gethostname,"http")
ipaddress = myip[0][2]

if(/133\.27\.\d{1,3}\.\d{1,3}/ =~ ipaddress)

agent = Mechanize.new
agent.follow_meta_refresh = true
top = agent.get('https://vu8.sfc.keio.ac.jp/sfc-sfs/index.cgi')
login_form = top.forms.first
login_form['u_login'] = username
login_form['u_pass'] = password
agent.submit(login_form)
agent.page.link_with(:text => "MY時間割" ).click
my = agent.page.at('iframe')['src']
my = my.sub(/^../,"")
agent.get(sfc,my)
classpage = agent.page.link_with(:text => lecname).click
stayp = agent.page.form_with(:action => "https://vu9.sfc.keio.ac.jp/sfc-sfs/sfs_class/stay/stay_input.cgi")
zanryu = agent.submit(stayp)
zanryu_form = zanryu.form_with(:name => 'formRoom')
zanryu_form['stay_phone'] = yourphonenumber
zanryu_form['stay_p_phone'] = parentsphonenumber
zanryu_form['stay_time'] = staytime
zanryu_form['selectRoom'] = selectroom
zanryu_form['selectFloor'] = selectfloor
zanryu_form['stay_room_other'] = roomnumber
zanryu_form['stay_reason'] = reason
agent.submit(zanryu_form)
agent.get(logouturl)
agent.page.link_with(:href => /logout/).click

end

