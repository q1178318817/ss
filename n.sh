＃！/ usr / bin / env bash
路径= / bin：/ sbin：/ usr / bin：/ usr / sbin：/ usr / local / bin：/ usr / local / sbin：〜/ bin
导出路径

＃================================================= =============================================
＃所需系统：CentOS 6 + / Debian 6 + / Ubuntu 14.04+
＃说明：安装ShadowsocksR mudbjson服务器
＃版本：1.0.26                            
＃	
＃================================================= =============================================

sh_ver =“ 1.0.26”
filepath = $（cd“ $（dirname” $ 0“）”; pwd）
file = $（echo -e“ $ {filepath}” | awk -F“ $ 0”'{print $ 1}'）
ssr_folder =“ / usr / local / shadowsocksr”
config_file =“ $ {ssr_folder} /config.json”
config_user_file =“ $ {ssr_folder} /user-config.json”
config_user_api_file =“ $ {ssr_folder} /userapiconfig.py”
config_user_mudb_file =“ $ {ssr_folder} /mudb.json”
ssr_log_file =“ $ {ssr_folder} /ssserver.log”
Libsodiumr_file =“ / usr / local / lib / libsodium.so”
Libsodiumr_ver_backup =“ 1.0.15”
Server_Speeder_file =“ / serverspeeder / bin / serverSpeeder.sh”
LotServer_file =“ / appex / bin / serverSpeeder.sh”
BBR_file =“ $ {file} /bbr.sh”
jq_file =“ $ {ssr_folder} / jq”

Green_font_prefix =“ \ 033 [32m” && Red_font_prefix =“ \ 033 [31m” && Green_background_prefix =“ \ 033 [42; 37m” && Red_background_prefix =“ \ 033 [41; 37m” && Font_color_suffix =“ \ 033 [0m”
Info =“ $ {Green_font_prefix} [信息] $ {Font_color_suffix}”
Error =“ $ {Red_font_prefix} [错误] $ {Font_color_suffix}”
Tip =“ $ {Green_font_prefix} [注意] $ {Font_color_suffix}”
Separator_1 =“ ——————————————————————————————

check_root（）{
	[[$ EUID！= 0]] && echo -e“ $ {Error}当前账号非ROOT（或没有ROOT权限），无法继续操作，请使用$ {Green_background_prefix} sudo su $ {Font_color_suffix}来获取临时ROOT权限（执行后会提示输入当前账号的密码）。” && exit 1
}
check_sys（）{
	如果[[-f / etc / redhat-release]]; 然后
		release =“ centos”
	猫猫/ etc / issue | grep -q -E -i“ debian”; 然后
		release =“ debian”
	猫猫/ etc / issue | grep -q -E -i“ ubuntu”; 然后
		release =“ ubuntu”
	猫猫/ etc / issue | grep -q -E -i“ centos | red hat | redhat”; 然后
		release =“ centos”
	小精灵猫/ proc / version | grep -q -E -i“ debian”; 然后
		release =“ debian”
	小精灵猫/ proc / version | grep -q -E -i“ ubuntu”; 然后
		release =“ ubuntu”
	小精灵猫/ proc / version | grep -q -E -i“ centos | red hat | redhat”; 然后
		release =“ centos”
    科幻
	bit =`uname -m`
}
check_pid（）{
	PID =`ps -ef | grep -v grep | grep server.py | awk'{print $ 2}'`
}
check_crontab（）{
	[[！-e“ / usr / bin / crontab”]] && echo -e“ $ {错误}依赖Crontab，请尝试手动安装CentOS：yum install crond -y，Debian / Ubuntu：apt-get install cron -y！” &&出口1
}
SSR_installation_status（）{
	[[！-e $ {ssr_folder}]] && echo -e“ $ {Error}没有发现ShadowsocksR文件夹，请检查！” &&出口1
}
Server_Speeder_installation_status（）{
	[[！-e $ {Server_Speeder_file}]] && echo -e“ $ {错误}没有安装锐速（Server Speeder），请检查！” &&出口1
}
LotServer_installation_status（）{
	[[！-e $ {LotServer_file}]] && echo -e“ $ {错误}没有安装LotServer，请检查！” &&出口1
}
BBR_installation_status（）{
	如果[[！-e $ {BBR_file}]]; 然后
		echo -e“ $ {Error}没有发现BBR脚本，开始下载...”
		cd“ $ {文件}”
		如果！wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/bbr.sh; 然后
			echo -e“ $ {Error} BBR脚本下载失败！” &&出口1
		其他
			echo -e“ $ {Info} BBR脚本下载完成！”
			chmod + x bbr.sh
		科幻
	科幻
}
＃设置防火墙规则
Add_iptables（）{
	如果[[！-z“ $ {ssr_port}”]]; 然后
		iptables -I INPUT -m状态--state新-m tcp -p tcp --dport $ {ssr_port} -j ACCEPT
		iptables -I INPUT -m状态--state NEW -m udp -p udp –dport $ {ssr_port} -j ACCEPT
		ip6tables -I INPUT -m状态--state新-m tcp -p tcp --dport $ {ssr_port} -j ACCEPT
		ip6tables -I INPUT -m状态--state新-m udp -p udp –dport $ {ssr_port} -j ACCEPT
	科幻
}
Del_iptables（）{
	如果[[！-z“ $ {port}”]]; 然后
		iptables -D INPUT -m状态--state新-m tcp -p tcp --dport $ {port} -j ACCEPT
		iptables -D INPUT -m状态--state NEW -m udp -p udp –dport $ {port} -j ACCEPT
		ip6tables -D INPUT -m状态--state新-m tcp -p tcp --dport $ {port} -j ACCEPT
		ip6tables -D INPUT -m状态--state新-m udp -p udp –dport $ {port} -j ACCEPT
	科幻
}
Save_iptables（）{
	如果[[$ {release} ==“ centos”]]; 然后
		服务iptables保存
		服务ip6tables保存
	其他
		iptables-save> /etc/iptables.up.rules
		ip6tables-save> /etc/ip6tables.up.rules
	科幻
}
Set_iptables（）{
	如果[[$ {release} ==“ centos”]]; 然后
		服务iptables保存
		服务ip6tables保存
		chkconfig --level 2345 iptables在
		chkconfig --level 2345 ip6tables在
	其他
		iptables-save> /etc/iptables.up.rules
		ip6tables-save> /etc/ip6tables.up.rules
		echo -e'＃！/ bin / bash \ n / sbin / iptables-restore </etc/iptables.up.rules\n/sbin/ip6tables-restore </etc/ip6tables.up.rules'> / etc / network /if-pre-up.d/iptables
		chmod + x /etc/network/if-pre-up.d/iptables
	科幻
}
＃读取配置信息
Get_IP（）{
	ip = $（wget -qO- -t1 -T2 ipinfo.io/ip）
	如果[[-z“ $ {ip}”]]; 然后
		ip = $（wget -qO- -t1 -T2 api.ip.sb/ip）
		如果[[-z“ $ {ip}”]]; 然后
			ip = $（wget -qO- -t1-T2 Members.3322.org/dyndns/getip）
			如果[[-z“ $ {ip}”]]; 然后
				ip =“ VPS_IP”
			科幻
		科幻
	科幻
}
Get_User_info（）{
	Get_user_port = $ 1
	user_info_get = $（python mujson_mgr.py -l -p“ $ {Get_user_port}”）
	match_info = $（回显“ $ {user_info_get}” | grep -w“ ###用户”）
	如果[[-z“ $ {match_info}”]]; 然后
		echo -e“ $ {Error}用户信息获取失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	科幻
	user_name = $（回显“ $ {user_info_get}” | grep -w“ user：” | awk -F“ user：”'{print $ NF}'）
	port = $（echo“ $ {user_info_get}” | grep -w“ port：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'）
	密码= $（回显“ $ {user_info_get}” | grep -w“ passwd：” | awk -F“ passwd：”'{print $ NF}'）
	method = $（echo“ $ {user_info_get}” | grep -w“ method：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'）
	protocol = $（echo“ $ {user_info_get}” | grep -w“ protocol：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'）
	protocol_param = $（回显“ $ {user_info_get}” | grep -w“ protocol_param：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'）
	[[-z $ {protocol_param}]] && protocol_param =“ 0（无限）”
	obfs = $（echo“ $ {user_info_get}” | grep -w“ obfs：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'）
	#transfer_enable = $（echo“ $ {user_info_get}” | grep -w“ transfer_enable：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}' | awk -F“ ytes”'{print $ 1}'| sed's / KB / KB /; s / MB / MB /; s / GB / GB /; s / TB / TB /; s / PB / PB / '）
	#u = $（echo“ $ {user_info_get}” | grep -w“ u：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}' ）
	#d = $（echo“ $ {user_info_get}” | grep -w“ d：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}' ）
	forbidden_​​port = $（echo“ $ {user_info_get}” | grep -w“ forbidden_​​port：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'）
	[[-z $ {forbidden_​​port}]] && forbidden_​​port =“无限制”
	speed_limit_per_con = $（回显“ $ {user_info_get}” | grep -w“ speed_limit_per_con：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'
	speed_limit_per_user = $（回显“ $ {user_info_get}” | grep -w“ speed_limit_per_user：” | sed's / [[:: space：]] // g'| awk -F“：”'{print $ NF}'
	Get_User_transfer“ $ {端口}”
}
Get_User_transfer（）{
	transfer_port = $ 1
	#echo“ transfer_port = $ {transfer_port}”
	all_port = $（$ {jq_file}'。[] | .port'$ {config_user_mudb_file}）
	#echo“ all_port = $ {all_port}”
	port_num = $（echo“ $ {all_port}” | grep -nw“ $ {transfer_port}” | awk -F“：”'{print $ 1}'）
	#echo“ port_num = $ {port_num}”
	port_num_1 = $（回显$（（（$ {port_num} -1）））
	#echo“ port_num_1 = $ {port_num_1}”
	transfer_enable_1 = $（$ {jq_file}“。[$ {port_num_1}]。transfer_enable” $ {config_user_mudb_file}）
	#echo“ transfer_enable_1 = $ {transfer_enable_1}”
	u_1 = $（$ {jq_file}“。[$ {port_num_1}]。u” $ {config_user_mudb_file}）
	#echo“ u_1 = $ {u_1}”
	d_1 = $（$ {jq_file}“。[$ {port_num_1}]。d” $ {config_user_mudb_file}）
	#echo“ d_1 = $ {d_1}”
	transfer_enable_Used_2_1 = $（回显$（（（$ {u_1} + $ {d_1}））））
	#echo“ transfer_enable_Used_2_1 = $ {transfer_enable_Used_2_1}”
	transfer_enable_Used_1 = $（回显$（（（$ {transfer_enable_1}-$ {transfer_enable_Used_2_1}））））
	#echo“ transfer_enable_Used_1 = $ {transfer_enable_Used_1}”
	
	如果[[$ {transfer_enable_1} -lt 1024]]; 然后
		transfer_enable =“ $ {transfer_enable_1} B”
	elif [[$ {transfer_enable_1} -lt 1048576]]; 然后
		transfer_enable = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_1}'/'1024'}'）
		transfer_enable =“ $ {transfer_enable} KB”
	elif [[$ {transfer_enable_1} -lt 1073741824]]; 然后
		transfer_enable = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_1}'/'1048576'}'）
		transfer_enable =“ $ {transfer_enable} MB”
	elif [[$ {transfer_enable_1} -lt 1099511627776]]; 然后
		transfer_enable = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_1}'/'1073741824'}'）
		transfer_enable =“ $ {transfer_enable} GB”
	elif [[$ {transfer_enable_1} -lt 1125899906842624]]; 然后
		transfer_enable = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_1}'/'1099511627776'}'）
		transfer_enable =“ $ {transfer_enable} TB”
	科幻
	#echo“ transfer_enable = $ {transfer_enable}”
	如果[[$ {u_1} -lt 1024]]; 然后
		u =“ $ {u_1} B”
	elif [[$ {u_1} -lt 1048576]]; 然后
		u = $（awk'BEGIN {printf“％.2f \ n”，'$ {u_1}'/'1024'}'）
		u =“ $ {u} KB”
	elif [[$ {u_1} -lt 1073741824]]; 然后
		u = $（awk'BEGIN {printf“％.2f \ n”，'$ {u_1}'/'1048576'}'）
		u =“ $ {u} MB”
	elif [[$ {u_1} -lt 1099511627776]]; 然后
		u = $（awk'BEGIN {printf“％.2f \ n”，'$ {u_1}'/'1073741824'}'）
		u =“ $ {u} GB”
	elif [[$ {u_1} -lt 1125899906842624]]; 然后
		u = $（awk'BEGIN {printf“％.2f \ n”，'$ {u_1}'/'1099511627776'}'）
		u =“ $ {u} TB”
	科幻
	#echo“ u = $ {u}”
	如果[[$ {d_1} -lt 1024]]; 然后
		d =“ $ {d_1} B”
	elif [[$ {d_1} -lt 1048576]]; 然后
		d = $（awk'BEGIN {printf“％.2f \ n”，'$ {d_1}'/'1024'}'）
		d =“ $ {d} KB”
	elif [[$ {d_1} -lt 1073741824]]; 然后
		d = $（awk'BEGIN {printf“％.2f \ n”，'$ {d_1}'/'1048576'}'）
		d =“ $ {d} MB”
	elif [[$ {d_1} -lt 1099511627776]]; 然后
		d = $（awk'BEGIN {printf“％.2f \ n”，'$ {d_1}'/'1073741824'}'）
		d =“ $ {d} GB”
	elif [[$ {d_1} -lt 1125899906842624]]; 然后
		d = $（awk'BEGIN {printf“％.2f \ n”，'$ {d_1}'/'1099511627776'}'）
		d =“ $ {d} TB”
	科幻
	#echo“ d = $ {d}”
	如果[[$ {transfer_enable_Used_1} -lt 1024]]; 然后
		transfer_enable_Used =“ $ {transfer_enable_Used_1} B”
	elif [[$ {transfer_enable_Used_1} -lt 1048576]]; 然后
		transfer_enable_Used = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_1}'/'1024'}'）
		transfer_enable_Used =“ $ {transfer_enable_Used} KB”
	elif [[$ {transfer_enable_Used_1} -lt 1073741824]]; 然后
		transfer_enable_Used = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_1}'/'1048576'}'）
		transfer_enable_Used =“ $ {transfer_enable_Used} MB”
	elif [[$ {transfer_enable_Used_1} -lt 1099511627776]]; 然后
		transfer_enable_Used = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_1}'/'1073741824'}'）
		transfer_enable_Used =“ $ {transfer_enable_Used} GB”
	elif [[$ {transfer_enable_Used_1} -lt 1125899906842624]]; 然后
		transfer_enable_Used = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_1}'/'1099511627776'}'）
		transfer_enable_Used =“ $ {transfer_enable_Used} TB”
	科幻
	#echo“ transfer_enable_Used = $ {transfer_enable_Used}”
	如果[[$ {transfer_enable_Used_2_1} -lt 1024]]; 然后
		transfer_enable_Used_2 =“ $ {transfer_enable_Used_2_1} B”
	elif [[$ {transfer_enable_Used_2_1} -lt 1048576]]; 然后
		transfer_enable_Used_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_2_1}'/'1024'}'）
		transfer_enable_Used_2 =“ $ {transfer_enable_Used_2} KB”
	elif [[$ {transfer_enable_Used_2_1} -lt 1073741824]]; 然后
		transfer_enable_Used_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_2_1}'/'1048576'}'）
		transfer_enable_Used_2 =“ $ {transfer_enable_Used_2} MB”
	elif [[$ {transfer_enable_Used_2_1} -lt 1099511627776]]; 然后
		transfer_enable_Used_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_2_1}'/'1073741824'}'）
		transfer_enable_Used_2 =“ $ {transfer_enable_Used_2} GB”
	elif [[$ {transfer_enable_Used_2_1} -lt 1125899906842624]]; 然后
		transfer_enable_Used_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_2_1}'/'1099511627776'}'）
		transfer_enable_Used_2 =“ $ {transfer_enable_Used_2} TB”
	科幻
	#echo“ transfer_enable_Used_2 = $ {transfer_enable_Used_2}”
}
Get_User_transfer_all（）{
	如果[[$ {transfer_enable_Used_233} -lt 1024]]; 然后
		transfer_enable_Used_233_2 =“ $ {transfer_enable_Used_233} B”
	elif [[$ {transfer_enable_Used_233} -lt 1048576]]; 然后
		transfer_enable_Used_233_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_233}'/'1024'}'）
		transfer_enable_Used_233_2 =“ $ {transfer_enable_Used_233_2} KB”
	elif [[$ {transfer_enable_Used_233} -lt 1073741824]]; 然后
		transfer_enable_Used_233_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_233}'/'1048576'}'）
		transfer_enable_Used_233_2 =“ $ {transfer_enable_Used_233_2} MB”
	elif [[$ {transfer_enable_Used_233} -lt 1099511627776]]; 然后
		transfer_enable_Used_233_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_233}'/'1073741824'}'）
		transfer_enable_Used_233_2 =“ $ {transfer_enable_Used_233_2} GB”
	elif [[$ {transfer_enable_Used_233} -lt 1125899906842624]]; 然后
		transfer_enable_Used_233_2 = $（awk'BEGIN {printf“％.2f \ n”，'$ {transfer_enable_Used_233}'/'1099511627776'}'）
		transfer_enable_Used_233_2 =“ $ {transfer_enable_Used_233_2} TB”
	科幻
}
urlsafe_base64（）{
	date = $（echo -n“ $ 1” | base64 | sed'：a; N; s / \ n / / g; ta'| sed's / // g; s / = // g; s / + / -/ g; s / \ // _ / g'）
	echo -e“ $ {date}”
}
ss_link_qr（）{
	SSbase64 = $（urlsafe_base64“ $ {方法}：$ {密码} @ $ {ip}：$ {端口}”）
	SSurl =“ ss：// $ {SSbase64}”
	SSQRcode =“ http://doub.pw/qr/qr.php?text=${SSurl}”
	ss_link =“ SS链接：$ {Green_font_prefix} $ {SSurl} $ {Font_color_suffix} \ n SS二维码：$ {Green_font_prefix} $ {SSQRcode} $ {Font_color_suffix}”
}
ssr_link_qr（）{
	SSRprotocol = $（echo $ {protocol} | sed's / _compatible // g'）
	SSRobfs = $（echo $ {obfs} | sed's / _compatible // g'）
	SSRPWDbase64 = $（urlsafe_base64“ $ {password}”）
	SSRbase64 = $（urlsafe_base64“ $ {ip}：$ {port}：$ {SSRprotocol}：$ {method}：$ {SSRobfs}：$ {SSRPWDbase64}”）
	SSRurl =“ ssr：// $ {SSRbase64}”
	SSRQRcode =“ http://doub.pw/qr/qr.php?text=${SSRurl}”
	ssr_link =“ SSR链接：$ {Red_font_prefix} $ {SSRurl} $ {Font_color_suffix} \ n SSR二维码：$ {Red_font_prefix} $ {SSRQRcode} $ {Font_color_suffix} \ n”
}
ss_ssr_determine（）{
	protocol_suffix =`echo $ {protocol} | awk -F“ _”'{print $ NF}'`
	obfs_suffix =`echo $ {obfs} | awk -F“ _”'{print $ NF}'`
	如果[[$ {protocol} =“ origin”]]; 然后
		如果[[$ {obfs} =“普通”]]; 然后
			ss_link_qr
			ssr_link =“”
		其他
			如果[[$ {obfs_suffix}！=“ compatible”]]; 然后
				ss_link =“”
			其他
				ss_link_qr
			科幻
		科幻
	其他
		如果[[$ {protocol_suffix}！=“ compatible”]]; 然后
			ss_link =“”
		其他
			如果[[$ {obfs_suffix}！=“ compatible”]]; 然后
				如果[[$ {obfs_suffix} =“普通”]]; 然后
					ss_link_qr
				其他
					ss_link =“”
				科幻
			其他
				ss_link_qr
			科幻
		科幻
	科幻
	ssr_link_qr
}
＃显示配置信息
View_User（）{
	SSR_installation_status
	List_port_user
	虽然真实
	做
		echo -e“请输入要查看账号信息的用户范围”
		读取-e -p“（默认：取消）：” View_user_port
		[[-z“ $ {View_user_port}”]] && echo -e“已取消...” &&退出1
		View_user = $（cat“ $ {config_user_mudb_file}” | grep'“ port”：'“ $ {View_user_port}”'，'）
		如果[[！-z $ {View_user}]]; 然后
			Get_User_info“ $ {View_user_port}”
			查看用户信息
			打破
		其他
			echo -e“ $ {Error}请输入正确的端口！”
		科幻
	完成
}
View_User_info（）{
	ip = $（cat $ {config_user_api_file} | grep“ SERVER_PUB_ADDR =” | awk -F“ [']”'{print $ 2}'）
	[[-z“ $ {ip}”]] && Get_IP
	ss_ssr_determine
	清除&&回声“ ============================================= =====“ &&回声
	echo -e“用户[$ {user_name}]的配置信息：” && echo
	echo -e“ IP \ t：$ {Green_font_prefix} $ {ip} $ {Font_color_suffix}”
	echo -e“扩展\ t：$ {Green_font_prefix} $ {port} $ {Font_color_suffix}”
	echo -e“密码\ t：$ {Green_font_prefix} $ {password} $ {Font_color_suffix}”
	echo -e“加密\ t：$ {Green_font_prefix} $ {method} $ {Font_color_suffix}”
	echo -e“协议\ t：$ {Red_font_prefix} $ {protocol} $ {Font_color_suffix}”
	echo -e“重建\ t：$ {Red_font_prefix} $ {obfs} $ {Font_color_suffix}”
	echo -e“设备数限制：$ {Green_font_prefix} $ {protocol_param} $ {Font_color_suffix}”
	echo -e“单线程限速：$ {Green_font_prefix} $ {speed_limit_per_con} KB / S $ {Font_color_suffix}”
	echo -e“用户总限速：$ {Green_font_prefix} $ {speed_limit_per_user} KB / S $ {Font_color_suffix}”
	echo -e“禁止的端口：$ {Green_font_prefix} $ {forbidden_​​port} $ {Font_color_suffix}”
	回声
	echo -e“已使用流量：上传：$ {Green_font_prefix} $ {u} $ {Font_color_suffix} +下载：$ {Green_font_prefix} $ {d} $ {Font_color_suffix} = $ {Green_font_prefix} $ {transfer_enable_Used_2} $ {Font_color_suffix} ”
	echo -e“剩余的流量：$ {Green_font_prefix} $ {transfer_enable_Used} $ {Font_color_suffix}”
	echo -e“用户总流量：$ {Green_font_prefix} $ {transfer_enable} $ {Font_color_suffix}”
	echo -e“ $ {ss_link}”
	echo -e“ $ {ssr_link}”
	echo -e“ $ {Green_font_prefix}提示：$ {Font_color_suffix}
 在浏览器中，打开二维码链接，就可以看到二维码图片。
 协议和替代后面的[_compatible]，指的是兼容原版协议/替代。”
	回声&&回声“ ============================================= =====“
}
＃设置配置信息
Set_config_user（）{
	echo“请输入要设置的用户用户名（请勿重复，用于区分，不支持中文，空格，会报错！）”
	读取-e -p“（或：comebey）：” ssr_user
	[[-z“ $ {ssr_user}”]] && ssr_user =“ comebey”
	ssr_user = $（回显“ $ {ssr_user}” | sed's / // g'）
	echo && echo $ {Separator_1} && echo -e“用户名：$ {Green_font_prefix} $ {ssr_user} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
}
Set_config_port（）{
	虽然真实
	做
	echo -e“请输入要设置的用户扩展（不要重复，用于区分）”
	读取-e -p“（默认：5210）：” ssr_port
	[[-z“ $ ssr_port”]] && ssr_port =“ 5210”
	回声$（（（$ {ssr_port} +0））＆> / dev / null
	如果[[$？== 0]]; 然后
		如果[[$ {ssr_port} -ge 1]] && [[$ {ssr_port} -le 65535]]; 然后
			echo && echo $ {Separator_1} && echo -e“扩展：$ {Green_font_prefix} $ {ssr_port} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
			打破
		其他
			echo -e“ $ {Error}请输入正确的数字（1-65535）”
		科幻
	其他
		echo -e“ $ {Error}请输入正确的数字（1-65535）”
	科幻
	完成
}
Set_config_password（）{
	echo“请输入要设置的用户密码”
	读取-e -p“（或：comebey）：” ssr_password
	[[-z“ $ {ssr_password}”]] && ssr_password =“ comebey”
	echo &&回声$ {Separator_1} &&回声-e“密码：$ {Green_font_prefix} $ {ssr_password} $ {Font_color_suffix}” &&回声$ {Separator_1} &&回声
}
Set_config_method（）{
	echo -e“请选择要设置的用户加密方式
	
 $ {Green_font_prefix} 1。$ {Font_color_suffix}无
 $ {Tip}如果使用auth_chain_ *系列协议，建议加密方式选择none（该系列协议自带RC4加密），则可以随意
 
 $ {Green_font_prefix} 2。$ {Font_color_suffix} rc4
 $ {Green_font_prefix} 3。$ {Font_color_suffix} rc4-md5
 $ {Green_font_prefix} 4。$ {Font_color_suffix} rc4-md5-6
 
 $ {Green_font_prefix} 5。$ {Font_color_suffix} aes-128-ctr
 $ {Green_font_prefix} 6。$ {Font_color_suffix} aes-192-ctr
 $ {Green_font_prefix} 7。$ {Font_color_suffix} aes-256-ctr
 
 $ {Green_font_prefix} 8。$ {Font_color_suffix} aes-128-cfb
 $ {Green_font_prefix} 9。$ {Font_color_suffix} aes-192-cfb
 $ {Green_font_prefix} 10。$ {Font_color_suffix} aes-256-cfb
 
 $ {Green_font_prefix} 11。$ {Font_color_suffix} aes-128-cfb8
 $ {Green_font_prefix} 12。$ {Font_color_suffix} aes-192-cfb8
 $ {Green_font_prefix} 13。$ {Font_color_suffix} aes-256-cfb8
 
 $ {Green_font_prefix} 14。$ {Font_color_suffix} salsa20
 $ {Green_font_prefix} 15。$ {Font_color_suffix} chacha20
 $ {Green_font_prefix} 16。$ {Font_color_suffix} chacha20-ietf
 $ {Tip} salsa20 / chacha20- *系列加密方式，需要额外安装依赖libsodium，否则会无法启动ShadowsocksR！“ && echo
	读取-e -p“（最小值：5. aes-128-ctr）：” ssr_method
	[[-z“ $ {ssr_method}”]] && ssr_method =“ 5”
	如果[[$ {ssr_method} ==“ 1”]]; 然后
		ssr_method =“ none”
	elif [[$ {ssr_method} ==“ 2”]]; 然后
		ssr_method =“ rc4”
	elif [[$ {ssr_method} ==“ 3”]]; 然后
		ssr_method =“ rc4-md5”
	elif [[$ {ssr_method} ==“ 4”]]; 然后
		ssr_method =“ rc4-md5-6”
	elif [[$ {ssr_method} ==“ 5”]]; 然后
		ssr_method =“ aes-128-ctr”
	elif [[$ {ssr_method} ==“ 6”]]; 然后
		ssr_method =“ aes-192-ctr”
	elif [[$ {ssr_method} ==“ 7”]]; 然后
		ssr_method =“ aes-256-ctr”
	elif [[$ {ssr_method} ==“ 8”]]; 然后
		ssr_method =“ aes-128-cfb”
	elif [[$ {ssr_method} ==“ 9”]]; 然后
		ssr_method =“ aes-192-cfb”
	elif [[$ {ssr_method} ==“ 10”]]; 然后
		ssr_method =“ aes-256-cfb”
	elif [[$ {ssr_method} ==“ 11”]]; 然后
		ssr_method =“ aes-128-cfb8”
	elif [[$ {ssr_method} ==“ 12”]]; 然后
		ssr_method =“ aes-192-cfb8”
	elif [[$ {ssr_method} ==“ 13”]]; 然后
		ssr_method =“ aes-256-cfb8”
	elif [[$ {ssr_method} ==“ 14”]]; 然后
		ssr_method =“ salsa20”
	elif [[$ {ssr_method} ==“ 15”]]; 然后
		ssr_method =“ chacha20”
	elif [[$ {ssr_method} ==“ 16”]]; 然后
		ssr_method =“ chacha20-ietf”
	其他
		ssr_method =“ aes-128-ctr”
	科幻
	echo && echo $ {Separator_1} && echo -e“加密：$ {Green_font_prefix} $ {ssr_method} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
}
Set_config_protocol（）{
	echo -e“请选择要设置的用户协议插件
	
 $ {Green_font_prefix} 1。$ {Font_color_suffix}来源
 $ {Green_font_prefix} 2。$ {Font_color_suffix} auth_sha1_v4
 $ {Green_font_prefix} 3。$ {Font_color_suffix} auth_aes128_md5
 $ {Green_font_prefix} 4。$ {Font_color_suffix} auth_aes128_sha1
 $ {Green_font_prefix} 5。$ {Font_color_suffix} auth_chain_a
 $ {Green_font_prefix} 6。$ {Font_color_suffix} auth_chain_b
 $ {Tip}如果使用auth_chain_ *系列协议，建议加密方式选择none（该系列协议自带RC4加密），则可以随意“ && echo
	读取-e -p“（最小值：3. auth_aes128_md5）：” ssr_protocol
	[[-z“ $ {ssr_protocol}”]] && ssr_protocol =“ 3”
	如果[[$ {ssr_protocol} ==“ 1”]]; 然后
		ssr_protocol =“ origin”
	elif [[$ {ssr_protocol} ==“ 2”]]; 然后
		ssr_protocol =“ auth_sha1_v4”
	elif [[$ {ssr_protocol} ==“ 3”]]; 然后
		ssr_protocol =“ auth_aes128_md5”
	elif [[$ {ssr_protocol} ==“ 4”]]; 然后
		ssr_protocol =“ auth_aes128_sha1”
	elif [[$ {ssr_protocol} ==“ 5”]]; 然后
		ssr_protocol =“ auth_chain_a”
	elif [[$ {ssr_protocol} ==“ 6”]]; 然后
		ssr_protocol =“ auth_chain_b”
	其他
		ssr_protocol =“ auth_aes128_md5”
	科幻
	echo && echo $ {Separator_1} && echo -e“协议：$ {Green_font_prefix} $ {ssr_protocol} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
	如果[[$ {ssr_protocol}！=“起源”]]; 然后
		如果[[$ {ssr_protocol} ==“ auth_sha1_v4”]]; 然后
			阅读-e -p“是否设置协议插件兼容原版（_compatible）？[Y / n]” ssr_protocol_yn
			[[-z“ $ {ssr_protocol_yn}”]] && ssr_protocol_yn =“ y”
			[[$ ssr_protocol_yn == [Yy]]] && ssr_protocol = $ {ssr_protocol}“ _ compatible”
			回声
		科幻
	科幻
}
Set_config_obfs（）{
	echo -e“请选择要设置的用户替换插件
	
 $ {Green_font_prefix} 1。$ {Font_color_suffix}普通
 $ {Green_font_prefix} 2。$ {Font_color_suffix} http_simple
 $ {Green_font_prefix} 3。$ {Font_color_suffix} http_post
 $ {Green_font_prefix} 4。$ {Font_color_suffix} random_head
 $ {Green_font_prefix} 5。$ {Font_color_suffix} tls1.2_ticket_auth
 $ {Tip}如果使用ShadowsocksR代理游戏，建议选择替换兼容的原版或plain替代，然后客户端选择plain，否则会增加延迟！
 另外，如果您选择了tls1.2_ticket_auth，那么客户端可以选择tls1.2_ticket_fastauth，这样即能伪装又不会增加延迟！
 如果您是在日本，美国等热门地区建造，那么选择plain可能会被墙几率升高！“ && echo
	读取-e -p“（最小值：1.普通）：” ssr_obfs
	[[-z“ $ {ssr_obfs}”]] && ssr_obfs =“ 1”
	如果[[$ {ssr_obfs} ==“ 1”]]; 然后
		ssr_obfs =“普通”
	elif [[$ {ssr_obfs} ==“ 2”]]; 然后
		ssr_obfs =“ http_simple”
	elif [[$ {ssr_obfs} ==“ 3”]]; 然后
		ssr_obfs =“ http_post”
	elif [[$ {ssr_obfs} ==“ 4”]]; 然后
		ssr_obfs =“ random_head”
	elif [[$ {ssr_obfs} ==“ 5”]]; 然后
		ssr_obfs =“ tls1.2_ticket_auth”
	其他
		ssr_obfs =“普通”
	科幻
	回声&&回声$ {Separator_1} &&回声-e“重构：$ {Green_font_prefix} $ {ssr_obfs} $ {Font_color_suffix}” &&回声$ {Separator_1} &&回声
	如果[[$ {ssr_obfs}！=“普通”]]; 然后
			读取-e -p“是否设置可以插入插件兼容原版（_compatible）？[Y / n]” ssr_obfs_yn
			[[-z“ $ {ssr_obfs_yn}”]] && ssr_obfs_yn =“ y”
			[[$ ssr_obfs_yn == [Yy]]] && ssr_obfs = $ {ssr_obfs}“ _ compatible”
			回声
	科幻
}
Set_config_protocol_param（）{
	虽然真实
	做
	echo -e“请输入要设置的用户限制设备的数量（$ {Green_font_prefix} auth_ *系列协议不兼容原版才有效$ {Font_color_suffix}）”
	echo -e“ $ {Tip}设备数量限制：每个端口同时时间能链接的客户端数量（多端口模式，每个端口都是独立计算），建议最少2个。”
	读取-e -p“（最小：无限）：” ssr_protocol_param
	[[-z“ $ ssr_protocol_param”]] && ssr_protocol_param =“” && echo && break
	回声$（（$ {ssr_protocol_param} +0））＆> / dev / null
	如果[[$？== 0]]; 然后
		如果[[$ {ssr_protocol_param} -ge 1]] && [[$ {ssr_protocol_param} -le 9999]]; 然后
			echo && echo $ {Separator_1} && echo -e“设备数限制：$ {Green_font_prefix} $ {ssr_protocol_param} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
			打破
		其他
			echo -e“ $ {Error}请输入正确的数字（1-9999）”
		科幻
	其他
		echo -e“ $ {Error}请输入正确的数字（1-9999）”
	科幻
	完成
}
Set_config_speed_limit_per_con（）{
	虽然真实
	做
	echo -e“请输入要设置的用户单线程限速上限（单位：KB / S）”
	echo -e“ $ {Tip}单线程限速：每个端口单线程的限速上限，多线程即无效。”
	读取-e -p“（最小：无限）：” ssr_speed_limit_per_con
	[[-z“ $ ssr_speed_limit_per_con”]] && ssr_speed_limit_per_con = 0 && echo && break
	回声$（（（$ {ssr_speed_limit_per_con} +0））＆> / dev / null
	如果[[$？== 0]]; 然后
		如果[[$ {ssr_speed_limit_per_con} -ge 1]] && [[$ {ssr_speed_limit_per_con} -le 131072]]; 然后
			echo && echo $ {Separator_1} && echo -e“单线程限速：$ {Green_font_prefix} $ {ssr_speed_limit_per_con} KB / S $ {Font_color_suffix}” && echo $ {Separator_1} && echo
			打破
		其他
			echo -e“ $ {Error}请输入正确的数字（1-131072）”
		科幻
	其他
		echo -e“ $ {Error}请输入正确的数字（1-131072）”
	科幻
	完成
}
Set_config_speed_limit_per_user（）{
	虽然真实
	做
	回声
	echo -e“请输入要设置的用户总速度限速上限（单位：KB / S）”
	echo -e“ $ {Tip}进入总限速：每个端口总速度限速上限，部分端口整体限速。”
	读取-e -p“（最小：无限）：” ssr_speed_limit_per_user
	[[-z“ $ ssr_speed_limit_per_user”]] && ssr_speed_limit_per_user = 0 && echo && break
	回声$（（$ {ssr_speed_limit_per_user} +0））＆> / dev / null
	如果[[$？== 0]]; 然后
		如果[[$ {ssr_speed_limit_per_user} -ge 1]] && [[$ {ssr_speed_limit_per_user} -le 131072]]; 然后
			echo && echo $ {Separator_1} && echo -e“用户总限速：$ {Green_font_prefix} $ {ssr_speed_limit_per_user} KB / S $ {Font_color_suffix}” && echo $ {Separator_1} && echo
			打破
		其他
			echo -e“ $ {Error}请输入正确的数字（1-131072）”
		科幻
	其他
		echo -e“ $ {Error}请输入正确的数字（1-131072）”
	科幻
	完成
}
Set_config_transfer（）{
	虽然真实
	做
	回声
	echo -e“请输入要设置的用户可使用的总流量上限（单位：GB，1-838868 GB）”
	读取-e -p“（默认：无限）：” ssr_transfer
	[[-z“ $ ssr_transfer”]] && ssr_transfer =“ 838868” && echo && break
	回声$（（（$ {ssr_transfer} +0））＆> / dev / null
	如果[[$？== 0]]; 然后
		如果[[$ {ssr_transfer} -ge 1]] && [[$ {ssr_transfer} -le 838868]]; 然后
			echo && echo $ {Separator_1} && echo -e“用户总流量：$ {Green_font_prefix} $ {ssr_transfer} GB $ {Font_color_suffix}” && echo $ {Separator_1} && echo
			打破
		其他
			echo -e“ $ {Error}请输入正确的数字（1-838868）”
		科幻
	其他
		echo -e“ $ {Error}请输入正确的数字（1-838868）”
	科幻
	完成
}
Set_config_forbid（）{
	echo“请输入要设置的用户禁止访问的端口”
	echo -e“ $ {Tip}禁止的端口：例如可以直接访问25端口，用户无法通过SSR代理访问邮件端口25了，如果禁止了80,443那么用户将无法正常访问http / https网站。
封禁特定端口格式：25
封禁多个端口格式：23,465
封禁上限段格式：233-266
封禁多种格式端口：25,465,233-666（不带冒号:)“
	读取-e -p“（默认为空不禁止访问任何端口）：” ssr_forbid
	[[-z“ $ {ssr_forbid}”]] && ssr_forbid =“”
	echo && echo $ {Separator_1} && echo -e“禁止的端口：$ {Green_font_prefix} $ {ssr_forbid} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
}
Set_config_enable（）{
	user_total = $（回显$（（（$ {user_total} -1）））
	for（（整数= 0;整数<= $ {user_total};整数++））
	做
		echo -e“ integer = $ {integer}”
		port_jq = $（$ {jq_file}“。[$ {integer}]。port”“ $ {config_user_mudb_file}”）
		echo -e“ port_jq = $ {port_jq}”
		如果[[“ $ {ssr_port}” ==“ $ {port_jq}”]]; 然后
			enable = $（$ {jq_file}“。[$ {integer}]。enable”“ $ {config_user_mudb_file}”））
			echo -e“ enable = $ {enable}”
			[[“” $ {enable}“ ==” null“]] && echo -e” $ {Error}获取当前端口[$ {ssr_port}]的位置状态失败！” &&出口1
			ssr_port_num = $（cat“ $ {config_user_mudb_file}” | grep -n'“ port”：'$ {ssr_port}'，'| awk -F“：”'{print $ 1}'）
			echo -e“ ssr_port_num = $ {ssr_port_num}”
			[[“” $ {ssr_port_num}“ ==” null“]] && echo -e” $ {Error}获取当前端口[$ {ssr_port}]的行数失败！” &&出口1
			ssr_enable_num = $（echo $（（（$ {ssr_port_num} -5）））
			echo -e“ ssr_enable_num = $ {ssr_enable_num}”
			打破
		科幻
	完成
	如果[[“ $ {enable}” ==“ 1”]]; 然后
		echo -e“端口[$ {ssr_port}]的帐户状态为：$ {Green_font_prefix}启用$ {Font_color_suffix}，是否切换为$ {Red_font_prefix} $$ {Font_color_suffix}？[Y / n]”
		读取-e -p“（最小值：Y）：” ssr_enable_yn
		[[-z“ $ {ssr_enable_yn}”]] && ssr_enable_yn =“ y”
		如果[[“ $ {ssr_enable_yn}” == [Yy]]]; 然后
			ssr_enable =“ 0”
		其他
			echo“取消...” &&退出0
		科幻
	elif [[“ $ {enable}” ==“ 0”]]; 然后
		echo -e“端口[$ {ssr_port}]的帐户状态为：$ {Green_font_prefix}放置$ {Font_color_suffix}，是否切换为$ {Red_font_prefix}启用$ {Font_color_suffix}？[Y / n]”
		读取-e -p“（最小值：Y）：” ssr_enable_yn
		[[-z“ $ {ssr_enable_yn}”]] && ssr_enable_yn =“ y”
		如果[[“ $ {ssr_enable_yn}” == [Yy]]]; 然后
			ssr_enable =“ 1”
		其他
			echo“取消...” &&退出0
		科幻
	其他
		echo -e“ $ {Error}当前端口的局部状态异常[$ {enable}]！” &&出口1
	科幻
}
Set_user_api_server_pub_addr（）{
	addr = $ 1
	如果[[“ $ {addr}” ==“修改”]]; 然后
		server_pub_addr = $（cat $ {config_user_api_file} | grep“ SERVER_PUB_ADDR =” | awk -F“ [']”'{print $ 2}'）
		如果[[-z $ {server_pub_addr}]]; 然后
			echo -e“ $ {Error}获取当前配置的服务器IP或域名失败！” &&退出1
		其他
			echo -e“ $ {Info}当前配置的服务器IP或域名为：$ {Green_font_prefix} $ {server_pub_addr} $ {Font_color_suffix}”
		科幻
	科幻
	echo“请输入用户配置中要显示的服务器IP或域名（当服务器有多个IP时，可以指定用户配置中显示的IP或域名）”
	读取-e -p“（自动自动检测外网IP）：” ssr_server_pub_addr
	如果[[-z“ $ {ssr_server_pub_addr}”]]; 然后
		取得IP
		如果[[$ {ip} ==“ VPS_IP”]]; 然后
			虽然真实
			做
			阅读-e -p“ $ {Error}自动检测外网IP失败，请手动输入服务器IP或域名” ssr_server_pub_addr
			如果[[-z“ $ ssr_server_pub_addr”]]; 然后
				echo -e“ $ {Error}不能为空！”
			其他
				打破
			科幻
			完成
		其他
			ssr_server_pub_addr =“ $ {ip}”
		科幻
	科幻
	echo && echo $ {Separator_1} && echo -e“ IP或域名：$ {Green_font_prefix} $ {ssr_server_pub_addr} $ {Font_color_suffix}” && echo $ {Separator_1} && echo
}
Set_config_all（）{
	lal = $ 1
	如果[[“ $ {lal}” ==“修改”]]; 然后
		Set_config_password
		Set_config_method
		Set_config_protocol
		Set_config_obfs
		Set_config_protocol_param
		Set_config_speed_limit_per_con
		Set_config_speed_limit_per_user
		Set_config_transfer
		Set_config_forbid
	其他
		Set_config_user
		Set_config_port
		Set_config_password
		Set_config_method
		Set_config_protocol
		Set_config_obfs
		Set_config_protocol_param
		Set_config_speed_limit_per_con
		Set_config_speed_limit_per_user
		Set_config_transfer
		Set_config_forbid
	科幻
}
＃修改配置信息
Modify_config_password（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -k“ $ {ssr_password}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户密码修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户密码修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_method（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -m“ $ {ssr_method}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户加密方式修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户加密方式修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_protocol（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -O“ $ {ssr_protocol}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户协议修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户协议修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_obfs（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -o“ $ {ssr_obfs}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户无法修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户可以修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_protocol_param（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -G“ $ {ssr_protocol_param}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户协议参数（设备数限制）修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户议定参数（设备数限制）修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_speed_limit_per_con（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -s“ $ {ssr_speed_limit_per_con}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户单线程限速修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户单线程限速修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_speed_limit_per_user（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -S“ $ {ssr_speed_limit_per_user}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户端口总限速修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户端口总限速修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_connect_verbose_info（）{
	sed -i's /“ connect_verbose_info”：'“ $（echo $ {connect_verbose_info}）”'，/“ connect_verbose_info”：'“ $（echo $ {ssr_connect_verbose_info}）”'，/ g'$ {config_user_file}
}
Modify_config_transfer（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -t“ $ {ssr_transfer}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户总流量修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户总流量修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_forbid（）{
	match_edit = $（python mujson_mgr.py -e -p“ $ {ssr_port}” -f“ $ {ssr_forbid}” | grep -w“编辑用户”）
	如果[[-z“ $ {match_edit}”]]; 然后
		echo -e“ $ {Error}用户禁止访问端口修改失败$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}” &&退出1
	其他
		echo -e“ $ {Info}用户禁止访问端口修改成功$ {Green_font_prefix} [端口：$ {ssr_port}] $ {Font_color_suffix}（注意：可能需要十秒左右才会应用最新配置）”
	科幻
}
Modify_config_enable（）{
	sed -i“ $ {ssr_enable_num}”的/“启用”：'“ $（echo $ {enable}）”'，/“ enable”：'“ $（echo $ {ssr_enable}）”'，/'$ {config_user_mudb_file}
}
Modify_user_api_server_pub_addr（）{
	sed -i“ s / SERVER_PUB_ADDR ='$ {server_pub_addr}'/ SERVER_PUB_ADDR ='$ {ssr_server_pub_addr}'/” $ {config_user_api_file}
}
Modify_config_all（）{
	Modify_config_password
	Modify_config_method
	Modify_config_protocol
	Modify_config_obfs
	Modify_config_protocol_param
	Modify_config_speed_limit_per_con
	Modify_config_speed_limit_per_user
	Modify_config_transfer
	Modify_config_forbid
}
Check_python（）{
	python_ver =`python -h`
	如果[[-z $ {python_ver}]]; 然后
		echo -e“ $ {Info}没有安装Python，开始安装...”
		如果[[$ {release} ==“ centos”]]; 然后
			百胜安装-y python
		其他
			apt-get install -y python
		科幻
	科幻
}
Centos_yum（）{
	百胜更新
	cat / etc / redhat-release | grep 7 \ .. * | grep -i centos> / dev / null
	如果[[$？= 0]]; 然后
		yum install -y vim解压缩crond网络工具
	其他
		yum install -y vim解压缩crond
	科幻
}
Debian_apt（）{
	apt-get更新
	cat / etc / issue | grep 9 \ .. *> / dev / null
	如果[[$？= 0]]; 然后
		apt-get install -y vim解压缩cron网络工具
	其他
		apt-get install -y vim解压缩cron
	科幻
}
＃下载ShadowsocksR
下载_SSR（）{
	cd“ / usr / local”
	wget -N --no-check-certificate“ https://github.com/ToyoDAdoubiBackup/shadowsocksr/archive/manyuser.zip”
	#git config --global http.sslVerify否
	#env GIT_SSL_NO_VERIFY = true git clone -b manyuser https://github.com/ToyoDAdoubiBackup/shadowsocksr.git
	＃[[！-e $ {ssr_folder}]] && echo -e“ $ {错误} ShadowsocksR服务端下载失败！” &&出口1
	[[！-e“ manyuser.zip”]] && echo -e“ $ {Error} ShadowsocksR服务端压缩包下载失败！” && rm -rf manyuser.zip &&退出1
	解压缩“ manyuser.zip”
	[[！-e“ / usr / local / shadowsocksr-manyuser /”]] && echo -e“ $ {Error} ShadowsocksR服务端解压失败！” && rm -rf manyuser.zip &&退出1
	mv“ / usr / local / shadowsocksr-manyuser /”“ / usr / local / shadowsocksr /”
	[[！-e“ / usr / local / shadowsocksr /”]] && echo -e“ $ {错误} ShadowsocksR服务端重命名失败！” && rm -rf manyuser.zip && rm -rf“ / usr / local / shadowsocksr-manyuser /” &&退出1
	rm -rf manyuser.zip
	cd“ shadowsocksr”
	cp“ $ {ssr_folder} /config.json”“ $ {config_user_file}”
	cp“ $ {ssr_folder} /mysql.json”“ $ {ssr_folder} /usermysql.json”
	cp“ $ {ssr_folder} /apiconfig.py”“ $ {config_user_api_file}”
	[[！-e $ {config_user_api_file}]] && echo -e“ $ {错误} ShadowsocksR服务端apiconfig.py复制失败！” &&出口1
	sed -i“ s / API_INTERFACE ='sspanelv2'/ API_INTERFACE ='mudbjson'/” $ {config_user_api_file}
	server_pub_addr =“ 127.0.0.1”
	Modify_user_api_server_pub_addr
	#sed -i“ s / SERVER_PUB_ADDR ='127.0.0.1'/ SERVER_PUB_ADDR ='$ {ip}'/” $ {config_user_api_file}
	sed -i's / \ / \ /仅在多用户模式下工作// g'“ $ {config_user_file}”
	echo -e“ $ {Info} ShadowsocksR服务端下载完成！”
}
Service_SSR（）{
	如果[[$ {release} =“ centos”]]; 然后
		如果！wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/service/ssrmu_centos -O /etc/init.d/ssrmu; 然后
			echo -e“ $ {Error} ShadowsocksR服务管理脚本下载失败！” &&出口1
		科幻
		chmod + x /etc/init.d/ssrmu
		chkconfig-添加ssrmu
		chkconfig ssrmu上
	其他
		如果！wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/service/ssrmu_debian -O /etc/init.d/ssrmu; 然后
			echo -e“ $ {Error} ShadowsocksR服务管理脚本下载失败！” &&出口1
		科幻
		chmod + x /etc/init.d/ssrmu
		update-rc.d -f ssrmu默认值
	科幻
	echo -e“ $ {Info} ShadowsocksR服务管理脚本下载完成！”
}
＃安装JQ解析器
JQ_install（）{
	如果[[！-e $ {jq_file}]]; 然后
		cd“ $ {ssr_folder}”
		如果[[$ {bit} =“ x86_64”]]; 然后
			mv“ jq-linux64”“ jq”
			#wget --no-check-certificate“ https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64” -O $ {jq_file}
		其他
			mv“ jq-linux32”“ jq”
			#wget --no-check-certificate“ https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32” -O $ {jq_file}
		科幻
		[[！-e $ {jq_file}]] && echo -e“ $ {错误} JQ解析器重命名失败，请检查！” &&出口1
		chmod + x $ {jq_file}
		echo -e“ $ {Info} JQ解析器安装完成，继续...” 
	其他
		echo -e“ $ {Info} JQ解析器已安装，继续...”
	科幻
}
＃安装依赖
Installation_dependency（）{
	如果[[$ {release} ==“ centos”]]; 然后
		Centos_yum
	其他
		Debian_apt
	科幻
	[[！-e“ / usr / bin / unzip”]] && echo -e“ $ {错误}依赖解压缩（解压压缩包）安装失败，多半是众多源的问题，请检查！” &&出口1
	Check_python
	#echo“名称服务器8.8.8.8”> /etc/resolv.conf
	#echo“名称服务器8.8.4.4” >> /etc/resolv.conf
	\ cp -f / usr / share / zoneinfo /亚洲/上海/ etc / localtime
	如果[[$ {release} ==“ centos”]]; 然后
		/etc/init.d/crond重新启动
	其他
		/etc/init.d/cron重新启动
	科幻
}
Install_SSR（）{
	check_root
	[[-e $ {ssr_folder}] && echo -e“ $ {Error} ShadowsocksR文件夹已存在，请检查（如安装失败或存在旧版本，请先卸载）！” &&出口1
	echo -e“ $ {Info}开始设置ShadowsocksR账号配置...”
	Set_user_api_server_pub_addr
	Set_config_all
	echo -e“ $ {Info}开始安装/配置ShadowsocksR依赖...”
	安装依赖
	echo -e“ $ {Info}开始下载/安装ShadowsocksR文件...”
	下载_SSR
	echo -e“ $ {Info}开始下载/安装ShadowsocksR服务脚本（init）...”
	服务_SSR
	echo -e“ $ {Info}开始下载/安装JSNO解析器JQ ...”
	JQ_install
	echo -e“ $ {Info}开始添加初始用户...”
	Add_port_user“安装”
	echo -e“ $ {Info}开始设置iptables防火墙...”
	Set_iptables
	echo -e“ $ {Info}开始添加iptables防火墙规则...”
	Add_iptables
	echo -e“ $ {Info}开始保存iptables防火墙规则...”
	Save_iptables
	echo -e“ $ {Info}所有步骤安装完毕，开始启动ShadowsocksR服务端...”
	开始_SSR
	Get_User_info“ $ {ssr_port}”
	查看用户信息
}
Update_SSR（）{
	SSR_installation_status
	echo -e“因破娃暂停更新ShadowsocksR服务端，所以此功能临时增加。”
	#cd $ {ssr_folder}
	#git pull
	#Restart_SSR
}
Uninstall_SSR（）{
	[[！-e $ {ssr_folder}]] && echo -e“ $ {错误}没有安装ShadowsocksR，请检查！” &&出口1
	回声“确定要卸载ShadowsocksR？[y / N]” &&回声
	读取-e -p“（最小值：n）：” unyn
	[[-z $ {unyn}]] && unyn =“ n”
	如果[[$ {unyn} == [Yy]]]; 然后
		check_pid
		[[！-z“ $ {PID}”]] &&杀死-9 $ {PID}
		user_info = $（python mujson_mgr.py -l）
		user_total = $（回显“ $ {user_info}” | wc -l）
		如果[[！-z $ {user_info}]]; 然后
			for（（整数= 1;整数<= $ {user_total};整数++））
			做
				port = $（echo“ $ {user_info}” | sed -n“ $ {integer} p” | awk'{print $ 4}'）
				Del_iptables
			完成
			Save_iptables
		科幻
		如果[[！-z $（crontab -l | grep“ ssrmu.sh”）]]; 然后
			crontab_monitor_ssr_cron_stop
			Clear_transfer_all_cron_stop
		科幻
		如果[[$ {release} =“ centos”]]; 然后
			chkconfig --del ssrmu
		其他
			update-rc.d -f ssrmu删除
		科幻
		rm -rf $ {ssr_folder} && rm -rf /etc/init.d/ssrmu
		回声&&回声“ ShadowsocksR卸载完成！” &&回声
	其他
		回声&&回声“卸载已取消...” &&回声
	科幻
}
Check_Libsodium_ver（）{
	echo -e“ $ {Info}开始获取libsodium最新版本...”
	Libsodiumr_ver = $（wget -qO-“ https://github.com/jedisct1/libsodium/tags"|grep” / jedisct1 / libsodium / releases / tag /“ | head -1 | sed -r's /.* tag \ /（。+）\“>。* / \ 1 /'）
	[[-z $ {Libsodiumr_ver}]] && Libsodiumr_ver = $ {Libsodiumr_ver_backup}
	echo -e“ $ {Info} libsodium最新版本为$ {Green_font_prefix} $ {Libsodiumr_ver} $ {Font_color_suffix}！”
}
Install_Libsodium（）{
	如果[[-e $ {Libsodiumr_file}]]; 然后
		echo -e“ $ {Error} libsodium已安装，是否覆盖安装（更新）？[y / N]”
		读取-e -p“（最小值：n）：” yn
		[[-z $ {yn}]] && yn =“ n”
		如果[[$ {yn} == [Nn]]]；然后
			回声“已取消...” &&退出1
		科幻
	其他
		echo -e“ $ {Info} libsodium未安装，开始安装...”
	科幻
	Check_Libsodium_ver
	如果[[$ {release} ==“ centos”]]; 然后
		百胜更新
		echo -e“ $ {Info}安装依赖...”
		yum -y groupinstall“开发工具”
		echo -e“ $ {Info}下载...”
		wget --no-check-certificate -N“ https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz”
		echo -e“ $ {Info}解压...”
		tar -xzf libsodium-$ {Libsodiumr_ver} .tar.gz && cd libsodium-$ {Libsodiumr_ver}
		echo -e“ $ {Info}编译安装...”
		./configure --disable-maintainer-mode && make -j2 && make安装
		回显/ usr / local / lib> /etc/ld.so.conf.d/usr_local_lib.conf
	其他
		apt-get更新
		echo -e“ $ {Info}安装依赖...”
		apt-get install -y build-essential
		echo -e“ $ {Info}下载...”
		wget --no-check-certificate -N“ https://github.com/jedisct1/libsodium/releases/download/${Libsodiumr_ver}/libsodium-${Libsodiumr_ver}.tar.gz”
		echo -e“ $ {Info}解压...”
		tar -xzf libsodium-$ {Libsodiumr_ver} .tar.gz && cd libsodium-$ {Libsodiumr_ver}
		echo -e“ $ {Info}编译安装...”
		./configure --disable-maintainer-mode && make -j2 && make安装
	科幻
	ldconfig
	cd .. && rm -rf libsodium-$ {Libsodiumr_ver} .tar.gz && rm -rf libsodium-$ {Libsodiumr_ver}
	[[！-e $ {Libsodiumr_file}]] && echo -e“ $ {错误} libsodium安装失败！” &&出口1
	echo && echo -e“ $ {Info} libsodium安装成功！” &&回声
}
＃显示连接信息
debian_View_user_connection_info（）{
	格式_1 = $ 1
	user_info = $（python mujson_mgr.py -l）
	user_total = $（回显“ $ {user_info}” | wc -l）
	[[-z $ {user_info}]] && echo -e“ $ {Error}没有发现用户，请检查！” &&出口1
	IP_total =`netstat -anp | grep'ESTABLISHED'| grep'python'| grep'tcp6'| awk'{print $ 5}'| awk -F“：”'{print $ 1}'| sort -u | grep -E -o“（[[0-9] {1,3} [\。]）{3} [0-9] {1,3}” | wc -l`
	user_list_all =“”
	for（（整数= 1;整数<= $ {user_total};整数++））
	做
		user_port = $（回显“ $ {user_info}” | sed -n“ $ {integer} p” | awk'{print $ 4}'）
		user_IP_1 =`netstat -anp | grep'ESTABLISHED'| grep'python'| grep'tcp6'| grep“：$ {user_port}” | awk'{print $ 5}'| awk -F“：”'{print $ 1} '| sort -u | grep -E -o“（[[0-9] {1,3} [\。]）{3} [0-9] {1,3}”`
		如果[[-z $ {user_IP_1}]]; 然后
			user_IP_total =“ 0”
		其他
			user_IP_total =`echo -e“ $ {user_IP_1}” | wc -l`
			如果[[$ {format_1} ==“ IP地址”]]; 然后
				get_IP_address
			其他
				user_IP =`echo -e“ \ n $ {user_IP_1}”`
			科幻
		科幻
		user_info_233 = $（python mujson_mgr.py -l | grep -w“ $ {user_port}” | awk'{print $ 2}'| sed's / \ [// g; s / \] // g'）
		user_list_all = $ {user_list_all}“用户名：$ {Green_font_prefix}” $ {user_info_233}“ $ {Font_color_suffix} \ t时间：$ {Green_font_prefix}” $ {user_port}“ $ {Font_color_suffix} \ t链接IP数量：$ { Green_font_prefix}“ $ {user_IP_total}” $ {Font_color_suffix} \ t当前链接IP：$ {Green_font_prefix} $ {user_IP} $ {Font_color_suffix} \ n“
		user_IP =“”
	完成
	echo -e“用户总数：$ {Green_background_prefix}” $ {user_total}“ $ {Font_color_suffix}链接IP总和：$ {Green_background_prefix}” $ {IP_total}“ $ {Font_color_suffix}”
	echo -e“ $ {user_list_all}”
}
centos_View_user_connection_info（）{
	格式_1 = $ 1
	user_info = $（python mujson_mgr.py -l）
	user_total = $（回显“ $ {user_info}” | wc -l）
	[[-z $ {user_info}]] && echo -e“ $ {Error}没有发现用户，请检查！” &&出口1
	IP_total =`netstat -anp | grep'ESTABLISHED'| grep'python'| grep'tcp'| grep':: ffff：'| awk'{print $ 5}'| awk -F“：”'{{print $ 4}'| sort -u | grep -E -o“（[[0-9] {1,3} [\。]）{3} [0-9] {1,3}“ | wc -l`
	user_list_all =“”
	for（（整数= 1;整数<= $ {user_total};整数++））
	做
		user_port = $（回显“ $ {user_info}” | sed -n“ $ {integer} p” | awk'{print $ 4}'）
		user_IP_1 =`netstat -anp | grep'ESTABLISHED'| grep'python'| grep'tcp'| grep“：$ {user_port}” | grep':: ffff：'| awk'{print $ 5}'| awk -F “：”'{print $ 4}'|排序-u | grep -E -o“（[[0-9] {1,3} [\。]）{3} [0-9] {1,3}” `
		如果[[-z $ {user_IP_1}]]; 然后
			user_IP_total =“ 0”
		其他
			user_IP_total =`echo -e“ $ {user_IP_1}” | wc -l`
			如果[[$ {format_1} ==“ IP地址”]]; 然后
				get_IP_address
			其他
				user_IP =`echo -e“ \ n $ {user_IP_1}”`
			科幻
		科幻
		user_info_233 = $（python mujson_mgr.py -l | grep -w“ $ {user_port}” | awk'{print $ 2}'| sed's / \ [// g; s / \] // g'）
		user_list_all = $ {user_list_all}“用户名：$ {Green_font_prefix}” $ {user_info_233}“ $ {Font_color_suffix} \ t时间：$ {Green_font_prefix}” $ {user_port}“ $ {Font_color_suffix} \ t链接IP数量：$ { Green_font_prefix}“ $ {user_IP_total}” $ {Font_color_suffix} \ t当前链接IP：$ {Green_font_prefix} $ {user_IP} $ {Font_color_suffix} \ n“
		user_IP =“”
	完成
	echo -e“用户总数：$ {Green_background_prefix}” $ {user_total}“ $ {Font_color_suffix}链接IP总和：$ {Green_background_prefix}” $ {IP_total}“ $ {Font_color_suffix}”
	echo -e“ $ {user_list_all}”
}
View_user_connection_info（）{
	SSR_installation_status
	echo && echo -e“请选择要显示的格式：
 $ {Green_font_prefix} 1。$ {Font_color_suffix}显示IP格式
 $ {Green_font_prefix} 2。$ {Font_color_suffix}显示IP + IP归属地格式” && echo
	读取-e -p“（最小值：1）：” ssr_connection_info
	[[-z“ $ {ssr_connection_info}”]] && ssr_connection_info =“ 1”
	如果[[$ {ssr_connection_info} ==“ 1”]]; 然后
		View_user_connection_info_1“”
	elif [[$ {ssr_connection_info} ==“ 2”]]; 然后
		echo -e“ $ {Tip}检测IP归属地（ipip.net），如果IP较长，可能时间会比较长...”
		View_user_connection_info_1“ IP地址”
	其他
		echo -e“ $ {Error}请输入正确的数字（1-2）” &&退出1
	科幻
}
View_user_connection_info_1（）{
	格式= $ 1
	如果[[$ {release} =“ centos”]]; 然后
		cat / etc / redhat-release | grep 7 \ .. * | grep -i centos> / dev / null
		如果[[$？= 0]]; 然后
			debian_View_user_connection_info“ $ format”
		其他
			centos_View_user_connection_info“ $ format”
		科幻
	其他
		debian_View_user_connection_info“ $ format”
	科幻
}
get_IP_address（）{
	#echo“ user_IP_1 = $ {user_IP_1}”
	如果[[！-z $ {user_IP_1}]]; 然后
	#echo“ user_IP_total = $ {user_IP_total}”
		for（（整数_1 = $ {user_IP_total};整数_1> = 1;整数_1--））
		做
			IP =`echo“ $ {user_IP_1}” | sed -n“ $ integer_1” p`
			#echo“ IP = $ {IP}”
			IP_地址=`wget -qO- -t1-T2 http://freeapi.ipip.net/${IP}|sed's / \“ // g; s /，// g; s / \ [// g ; s / \] // g'`
			#echo“ IP_address = $ {IP_address}”
			user_IP =“ $ {user_IP} \ n $ {IP}（$ {IP_address}）”
			#echo“ user_IP = $ {user_IP}”
			睡1秒
		完成
	科幻
}
＃修改用户配置
Modify_port（）{
	List_port_user
	虽然真实
	做
		echo -e“请输入要修改的用户范围”
		读取-e -p“（默认：取消）：” ssr_port
		[[-z“ $ {ssr_port}”]] && echo -e“已取消...” &&退出1
		Modify_user = $（cat“ $ {config_user_mudb_file}” | grep'“ port”：'“ $ {ssr_port}”'，'）
		如果[[！-z $ {Modify_user}]]; 然后
			打破
		其他
			echo -e“ $ {Error}请输入正确的端口！”
		科幻
	完成
}
Modify_Config（）{
	SSR_installation_status
	echo && echo -e“你要做什么？
 $ {Green_font_prefix} 1。$ {Font_color_suffix}添加用户配置
 $ {Green_font_prefix} 2。$ {Font_color_suffix}删除用户配置
—————修改用户配置——————
 $ {Green_font_prefix} 3。$ {Font_color_suffix}修改用户密码
 $ {Green_font_prefix} 4。$ {Font_color_suffix}修改加密方式
 $ {Green_font_prefix} 5。$ {Font_color_suffix}修改协议插件
 $ {Green_font_prefix} 6。$ {Font_color_suffix}修改替代插件
 $ {Green_font_prefix} 7。$ {Font_color_suffix}修改设备数限制
 $ {Green_font_prefix} 8。$ {Font_color_suffix}修改单线程限速
 $ {Green_font_prefix} 9。$ {Font_color_suffix}修改用户总限速
 $ {Green_font_prefix} 10。$ {Font_color_suffix}修改用户总流量
 $ {Green_font_prefix} 11。$ {Font_color_suffix}修改用户位置端口
 $ {Green_font_prefix} 12。$ {Font_color_suffix}修改全部配置
——————其他——————
 $ {Green_font_prefix} 13。$ {Font_color_suffix}修改用户配置中显示的IP或域名
 
 $ {Tip}用户的用户名和端口是无法修改，如果需要修改请使用脚本的手动修改功能！“ && echo
	读取-e -p“（默认：取消）：” ssr_modify
	[[-z“ $ {ssr_modify}”]] && echo“已取消...” &&退出1
	如果[[$ {ssr_modify} ==“ 1”]]; 然后
		Add_port_user
	elif [[$ {ssr_modify} ==“ 2”]]; 然后
		Del_port_user
	elif [[$ {ssr_modify} ==“ 3”]]; 然后
		Modify_port
		Set_config_password
		Modify_config_password
	elif [[$ {ssr_modify} ==“ 4”]]; 然后
		Modify_port
		Set_config_method
		Modify_config_method
	elif [[$ {ssr_modify} ==“ 5”]]; 然后
		Modify_port
		Set_config_protocol
		Modify_config_protocol
	elif [[$ {ssr_modify} ==“ 6”]]; 然后
		Modify_port
		Set_config_obfs
		Modify_config_obfs
	elif [[$ {ssr_modify} ==“ 7”]]; 然后
		Modify_port
		Set_config_protocol_param
		Modify_config_protocol_param
	elif [[$ {ssr_modify} ==“ 8”]]; 然后
		Modify_port
		Set_config_speed_limit_per_con
		Modify_config_speed_limit_per_con
	elif [[$ {ssr_modify} ==“ 9”]]; 然后
		Modify_port
		Set_config_speed_limit_per_user
		Modify_config_speed_limit_per_user
	elif [[$ {ssr_modify} ==“ 10”]]; 然后
		Modify_port
		Set_config_transfer
		Modify_config_transfer
	elif [[$ {ssr_modify} ==“ 11”]]; 然后
		Modify_port
		Set_config_forbid
		Modify_config_forbid
	elif [[$ {ssr_modify} ==“ 12”]]; 然后
		Modify_port
		Set_config_all“修改”
		Modify_config_all
	elif [[$ {ssr_modify} ==“ 13”]]; 然后
		Set_user_api_server_pub_addr“修改”
		Modify_user_api_server_pub_addr
	其他
		echo -e“ $ {Error}请输入正确的数字（1-13）” &&退出1
	科幻
}
List_port_user（）{
	user_info = $（python mujson_mgr.py -l）
	user_total = $（回显“ $ {user_info}” | wc -l）
	[[-z $ {user_info}]] && echo -e“ $ {Error}没有发现用户，请检查！” &&出口1
	user_list_all =“”
	for（（整数= 1;整数<= $ {user_total};整数++））
	做
		user_port = $（回显“ $ {user_info}” | sed -n“ $ {integer} p” | awk'{print $ 4}'）
		user_username = $（echo“ $ {user_info}” | sed -n“ $ {integer} p” | awk'{print $ 2}'| sed's / \ [// g; s / \] // g'）
		Get_User_transfer“ $ {user_port}”
		transfer_enable_Used_233 = $（回声$（（（$ {transfer_enable_Used_233} + $ {transfer_enable_Used_2_1}）））
		user_list_all = $ {user_list_all}“用户名：$ {Green_font_prefix}” $ {user_username}“ $ {Font_color_suffix} \ t时间：$ {Green_font_prefix}” $ {user_port}“ $$ {Font_color_suffix} \ t流量情况（已用+剩余=总）：$ {Green_font_prefix} $ {transfer_enable_Used_2} $ {Font_color_suffix} + $ {Green_font_prefix} $ {transfer_enable_Used} $ {Font_color_suffix} = $ {Green_font_prefix} $ {transfer_enable} $ {Font_color_s“
	完成
	Get_User_transfer_all
	echo && echo -e“ ===用户总数$ {Green_background_prefix}” $ {user_total}“ $ {Font_color_suffix}”
	echo -e $ {user_list_all}
	echo -e“ ===当前所有用户已使用流量总和：$ {Green_background_prefix} $ {transfer_enable_Used_233_2} $ {Font_color_suffix} \ n”
}
Add_port_user（）{
	lalal = $ 1
	如果[[“ $ lalal” ==“安装”]]; 然后
		match_add = $（python mujson_mgr.py -a -u“ $ {ssr_user}” -p“ $ {ssr_port}” -k“ $ {ssr_password}” -m“ $ {ssr_method}” -O“ $ {ssr_protocol}” -G“ $ {ssr_protocol_param}” -o“ $ {ssr_obfs}” -s“ $ {ssr_speed_limit_per_con}” -S“ $ {ssr_speed_limit_per_user}” -t“ $ {ssr_transfer}” -f“ $ {ssr_forbid}” | grep -w“添加用户信息”）
	其他
		虽然真实
		做
			Set_config_all
			match_port = $（python mujson_mgr.py -l | grep -w“端口$ {ssr_port} $”）
			[[！-z“ $ {match_port}”]] && echo -e“ $ {Error}该端口[$ {ssr_port}]已存在，请勿重复添加！” &&出口1
			match_username = $（python mujson_mgr.py -l | grep -w“用户\ [$ {ssr_user}]”）
			[[！-z“ $ {match_username}”]] && echo -e“ $ {Error}该用户名[$ {ssr_user}]已存在，请勿重复添加！” &&出口1
			match_add = $（python mujson_mgr.py -a -u“ $ {ssr_user}” -p“ $ {ssr_port}” -k“ $ {ssr_password}” -m“ $ {ssr_method}” -O“ $ {ssr_protocol}” -G“ $ {ssr_protocol_param}” -o“ $ {ssr_obfs}” -s“ $ {ssr_speed_limit_per_con}” -S“ $ {ssr_speed_limit_per_user}” -t“ $ {ssr_transfer}” -f“ $ {ssr_forbid}” | grep -w“添加用户信息”）
			如果[[-z“ $ {match_add}”]]; 然后
				echo -e“ $ {Error}用户添加失败$ {Green_font_prefix} [用户名：$ {ssr_user}，扩展：$ {ssr_port}] $ {Font_color_suffix}”
				打破
			其他
				Add_iptables
				Save_iptables
				echo -e“ $ {Info}用户添加成功$ {Green_font_prefix} [用户名：$ {ssr_user}，扩展：$ {ssr_port}] $ {Font_color_suffix}”
				回声
				阅读-e -p“是否继续添加用户配置？[Y / n]：” addyn
				[[-z $ {addyn}]] && addyn =“ y”
				如果[[$ {addyn} == [Nn]]]；然后
					Get_User_info“ $ {ssr_port}”
					查看用户信息
					打破
				其他
					echo -e“ $ {Info}继续添加用户配置...”
				科幻
			科幻
		完成
	科幻
}
Del_port_user（）{
	List_port_user
	虽然真实
	做
		echo -e“请输入要删除的用户范围”
		读取-e -p“（默认：取消）：” del_user_port
		[[-z“ $ {del_user_port}”]] && echo -e“已取消...” &&退出1
		del_user = $（cat“ $ {config_user_mudb_file}” | grep'“ port”：'“ $ {del_user_port}”'，'）
		如果[[！-z $ {del_user}]]; 然后
			端口= $ {del_user_port}
			match_del = $（python mujson_mgr.py -d -p“ $ {del_user_port}” | grep -w“删除用户”）
			如果[[-z“ $ {match_del}”]]; 然后
				echo -e“ $ {Error}用户删除失败$ {Green_font_prefix} [端口：$ {del_user_port}] $ {Font_color_suffix}”
			其他
				Del_iptables
				Save_iptables
				echo -e“ $ {Info}用户删除成功$ {Green_font_prefix} [端口：$ {del_user_port}] $ {Font_color_suffix}”
			科幻
			打破
		其他
			echo -e“ $ {Error}请输入正确的端口！”
		科幻
	完成
}
Manually_Modify_Config（）{
	SSR_installation_status
	vi $ {config_user_mudb_file}
	echo“是否现在重启ShadowsocksR？[Y / n]” && echo
	读-e -p“（最小值：y）：” yn
	[[-z $ {yn}]] && yn =“ y”
	如果[[$ {yn} == [Yy]]]；然后
		重启_SSR
	科幻
}
Clear_transfer（）{
	SSR_installation_status
	echo && echo -e“你要做什么？
 $ {Green_font_prefix} 1。$ {Font_color_suffix}清零个别用户已使用流量
 $ {Green_font_prefix} 2。$ {Font_color_suffix}清零所有用户已使用流量（不可挽回）
 $ {Green_font_prefix} 3。$ {Font_color_suffix}启动定时所有用户流量清零
 $ {Green_font_prefix} 4。$ {Font_color_suffix}停止定时定时所有用户流量清零
 $ {Green_font_prefix} 5。$ {Font_color_suffix}修改定时所有用户流量清零“ && echo
	读取-e -p“（默认：取消）：” ssr_modify
	[[-z“ $ {ssr_modify}”]] && echo“已取消...” &&退出1
	如果[[$ {ssr_modify} ==“ 1”]]; 然后
		Clear_transfer_one
	elif [[$ {ssr_modify} ==“ 2”]]; 然后
		echo“确定要清零所有用户已使用流量？[y / N]” && echo
		读取-e -p“（最小值：n）：” yn
		[[-z $ {yn}]] && yn =“ n”
		如果[[$ {yn} == [Yy]]]；然后
			Clear_transfer_all
		其他
			回声“取消...”
		科幻
	elif [[$ {ssr_modify} ==“ 3”]]; 然后
		check_crontab
		Set_crontab
		Clear_transfer_all_cron_start
	elif [[$ {ssr_modify} ==“ 4”]]; 然后
		check_crontab
		Clear_transfer_all_cron_stop
	elif [[$ {ssr_modify} ==“ 5”]]; 然后
		check_crontab
		Clear_transfer_all_cron_modify
	其他
		echo -e“ $ {Error}请输入正确的数字（1-5）” &&退出1
	科幻
}
Clear_transfer_one（）{
	List_port_user
	虽然真实
	做
		echo -e“请输入要清零已使用流量的用户范围”
		读取-e -p“（默认：取消）：” Clear_transfer_user_port
		[[-z“ $ {Clear_transfer_user_port}”]] && echo -e“已取消...” &&退出1
		Clear_transfer_user = $（cat“ $ {config_user_mudb_file}” | grep'“ port”：'“ $ {Clear_transfer_user_port}”'，'）
		如果[[！-z $ {Clear_transfer_user}]]; 然后
			match_clear = $（python mujson_mgr.py -c -p“ $ {Clear_transfer_user_port}” | grep -w“清除用户”）
			如果[[-z“ $ {match_clear}”]]; 然后
				echo -e“ $ {Error}用户已使用流量清零失败$ {Green_font_prefix} [端口：$ {Clear_transfer_user_port}] $ {Font_color_suffix}”
			其他
				echo -e“ $ {Info}用户已使用流量清零成功$ {Green_font_prefix} [端口：$ {Clear_transfer_user_port}] $ {Font_color_suffix}”
			科幻
			打破
		其他
			echo -e“ $ {Error}请输入正确的端口！”
		科幻
	完成
}
Clear_transfer_all（）{
	cd“ $ {ssr_folder}”
	user_info = $（python mujson_mgr.py -l）
	user_total = $（回显“ $ {user_info}” | wc -l）
	[[-z $ {user_info}]] && echo -e“ $ {Error}没有发现用户，请检查！” &&出口1
	for（（整数= 1;整数<= $ {user_total};整数++））
	做
		user_port = $（回显“ $ {user_info}” | sed -n“ $ {integer} p” | awk'{print $ 4}'）
		match_clear = $（python mujson_mgr.py -c -p“ $ {user_port}” | grep -w“清除用户”）
		如果[[-z“ $ {match_clear}”]]; 然后
			echo -e“ $ {Error}用户已使用流量清零失败$ {Green_font_prefix} [端口：$ {user_port}] $ {Font_color_suffix}”
		其他
			echo -e“ $ {Info}用户已使用流量清零成功$ {Green_font_prefix} [端口：$ {user_port}] $ {Font_color_suffix}”
		科幻
	完成
	echo -e“ $ {Info}所有用户流量清零完成！”
}
Clear_transfer_all_cron_start（）{
	crontab -l>“ $ file / crontab.bak”
	sed -i“ /ssrmu.sh/d”“ $ file / crontab.bak”
	echo -e“ \ n $ {Crontab_time} / bin / bash $ file / ssrmu.sh clearall” >>“ $ file / crontab.bak”
	crontab“ $ file / crontab.bak”
	rm -r“ $ file / crontab.bak”
	cron_config = $（crontab -l | grep“ hasan.sh”）
	如果[[-z $ {cron_config}]]; 然后
		echo -e“ $ {Error}定时所有用户流量清零启动失败！” &&出口1
	其他
		echo -e“ $ {Info}定时所有用户流量清零启动成功！”
	科幻
}
Clear_transfer_all_cron_stop（）{
	crontab -l>“ $ file / crontab.bak”
	sed -i“ /ssrmu.sh/d”“ $ file / crontab.bak”
	crontab“ $ file / crontab.bak”
	rm -r“ $ file / crontab.bak”
	cron_config = $（crontab -l | grep“ hasan.sh”）
	如果[[！-z $ {cron_config}]]; 然后
		echo -e“ $ {Error}定时所有用户流量清零停止失败！” &&出口1
	其他
		echo -e“ $ {Info}定时所有用户流量清零停止成功！”
	科幻
}
Clear_transfer_all_cron_modify（）{
	Set_crontab
	Clear_transfer_all_cron_stop
	Clear_transfer_all_cron_start
}
Set_crontab（）{
		echo -e“请输入流量清零时间间隔
 ===格式说明===
 * * * * *分别对应分钟小时日份月份星期二
 $ {Green_font_prefix} 0 2 1 * * $ {Font_color_suffix}代表每月1日2点0分清零已使用流量
 $ {Green_font_prefix} 0 2 15 * * $ {Font_color_suffix}代表每月15日2点0分清零已使用流量
 $ {Green_font_prefix} 0 2 * / 7 * * $ {Font_color_suffix}代表每7天2点0分清零已使用流量
 $ {Green_font_prefix} 0 2 * * 0 $ {Font_color_suffix}代表每个星期日（7）清零已使用流量
 $ {Green_font_prefix} 0 2 * * 3 $ {Font_color_suffix}代表每个星期三（3）清零已使用流量“ && echo
	读取-e -p“（至少0 2 1 * *每月1日2点0分）：” Crontab_time
	[[-z“ $ {Crontab_time}”]] && Crontab_time =“ 0 2 1 * *”
}
Start_SSR（）{
	SSR_installation_status
	check_pid
	[[！-z $ {PID}]] && echo -e“ $ {错误} ShadowsocksR正在运行！” &&出口1
	/etc/init.d/ssrmu开始
}
Stop_SSR（）{
	SSR_installation_status
	check_pid
	[[-z $ {PID}]] && echo -e“ $ {错误} ShadowsocksR未运行！” &&出口1
	/etc/init.d/ssrmu停止
}
Restart_SSR（）{
	SSR_installation_status
	check_pid
	[[！-z $ {PID}]] && /etc/init.d/ssrmu停止
	/etc/init.d/ssrmu开始
}
查看日志（）{
	SSR_installation_status
	[[！-e $ {ssr_log_file}]] && echo -e“ $ {错误} ShadowsocksR日志文件不存在！” &&出口1
	echo && echo -e“ $ {Tip}按$ {Red_font_prefix} Ctrl + C $ {Font_color_suffix}终止查看日志” && echo -e”如果需要查看完整日志内容，请用$ {Red_font_prefix} cat $ {ssr_log_file} $ {Font_color_suffix}命令。” &&回声
	tail -f $ {ssr_log_file}
}
＃锐速
Configure_Server_Speeder（）{
	echo && echo -e“你要做什么？
 $ {Green_font_prefix} 1。$ {Font_color_suffix}安装锐速
 $ {Green_font_prefix} 2。$ {Font_color_suffix}卸载锐速
————————
 $ {Green_font_prefix} 3。$ {Font_color_suffix}启动锐速
 $ {Green_font_prefix} 4。$ {Font_color_suffix}停止锐速
 $ {Green_font_prefix} 5。$ {Font_color_suffix}重新启动锐速
 $ {Green_font_prefix} 6。$ {Font_color_suffix}查看锐速状态
 
 注意：锐速和LotServer不能同时安装/启动！” && echo
	读取-e -p“（默认：取消）：” server_speeder_num
	[[-z“ $ {server_speeder_num}”]] && echo“已取消...” &&退出1
	如果[[$ {server_speeder_num} ==“ 1”]]; 然后
		Install_ServerSpeeder
	elif [[$ {server_speeder_num} ==“ 2”]]; 然后
		Server_Speeder_installation_status
		Uninstall_ServerSpeeder
	elif [[$ {server_speeder_num} ==“ 3”]]; 然后
		Server_Speeder_installation_status
		$ {Server_Speeder_file}开始
		$ {Server_Speeder_file}状态
	elif [[$ {server_speeder_num} ==“ 4”]]; 然后
		Server_Speeder_installation_status
		$ {Server_Speeder_file}停止
	elif [[$ {server_speeder_num} ==“ 5”]]; 然后
		Server_Speeder_installation_status
		$ {Server_Speeder_file}重新启动
		$ {Server_Speeder_file}状态
	elif [[$ {server_speeder_num} ==“ 6”]]; 然后
		Server_Speeder_installation_status
		$ {Server_Speeder_file}状态
	其他
		echo -e“ $ {Error}请输入正确的数字（1-6）” &&退出1
	科幻
}
Install_ServerSpeeder（）{
	[[-e $ {Server_Speeder_file}]] && echo -e“ $ {错误}锐速（Server Speeder）已安装！” &&出口1
	＃借用91yun.rog的开心版锐速
	wget --no-check-certificate -qO /tmp/serverspeeder.sh https://raw.githubusercontent.com/91yun/serverspeeder/master/serverspeeder.sh
	[[！-e“ /tmp/serverspeeder.sh”]] && echo -e“ $ {错误}锐速安装脚本下载失败！” &&出口1
	bash /tmp/serverspeeder.sh
	睡2s
	PID =`ps -ef | grep -v grep | grep“ serverspeeder” | awk'{print $ 2}'`
	如果[[！-z $ {PID}]]; 然后
		rm -rf /tmp/serverspeeder.sh
		rm -rf / tmp / 91yunserverspeeder
		rm -rf /tmp/91yunserverspeeder.tar.gz
		echo -e“ $ {Info}锐速（服务器加速器）安装完成！” &&出口1
	其他
		echo -e“ $ {Error}锐速（Server Speeder）安装失败！” &&出口1
	科幻
}
Uninstall_ServerSpeeder（）{
	echo“确定要卸载锐速（Server Speeder）？[y / N]” && echo
	读取-e -p“（最小值：n）：” unyn
	[[-z $ {unyn}]] && echo && echo“已取消...” &&退出1
	如果[[$ {unyn} == [Yy]]]; 然后
		chattr -i / serverspeeder / etc / apx *
		/serverspeeder/bin/serverSpeeder.sh卸载-f
		回声&&回声“锐速（Server Speeder）卸载完成！” &&回声
	科幻
}
＃LotServer
Configure_LotServer（）{
	echo && echo -e“你要做什么？
 $ {Green_font_prefix} 1。$ {Font_color_suffix}安装LotServer
 $ {Green_font_prefix} 2。$ {Fo nt_color_suffix}卸载LotServer
————————
 $ {Green_font_prefix} 3。$ {Font_color_suffix}启动LotServer
 $ {Green_font_prefix} 4。$ {Font_color_suffix}停止LotServer
 $ {Green_font_prefix} 5。$ {Font_color_suffix}重新启动LotServer
 $ {Green_font_prefix} 6。$ {Font_color_suffix}查看LotServer状态
 
 注意：锐速和LotServer不能同时安装/启动！” && echo
	读取-e -p“（默认：取消）：” lotserver_num
	[[-z“ $ {lotserver_num}”]] && echo“已取消...” &&退出1
	如果[[$ {lotserver_num} ==“ 1”]]; 然后
		Install_LotServer
	elif [[$ {lotserver_num} ==“ 2”]]; 然后
		LotServer_installation_status
		Uninstall_LotServer
	elif [[$ {lotserver_num} ==“ 3”]]; 然后
		LotServer_installation_status
		$ {LotServer_file}开始
		$ {LotServer_file}状态
	elif [[$ {lotserver_num} ==“ 4”]]; 然后
		LotServer_installation_status
		$ {LotServer_file}停止
	elif [[$ {lotserver_num} ==“ 5”]]; 然后
		LotServer_installation_status
		$ {LotServer_file}重新启动
		$ {LotServer_file}状态
	elif [[$ {lotserver_num} ==“ 6”]]; 然后
		LotServer_installation_status
		$ {LotServer_file}状态
	其他
		echo -e“ $ {Error}请输入正确的数字（1-6）” &&退出1
	科幻
}
Install_LotServer（）{
	[[-e $ {LotServer_file}] && echo -e“ $ {错误} LotServer已安装！” &&出口1
	#Github：https：//github.com/0oVicero0/serverSpeeder_Install
	wget --no-check-certificate -qO /tmp/appex.sh“ https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh”
	[[！-e“ /tmp/appex.sh”]] && echo -e“ $ {错误} LotServer安装脚本下载失败！” &&出口1
	bash /tmp/appex.sh'安装'
	睡2s
	PID =`ps -ef | grep -v grep | grep“ appex” | awk'{print $ 2}'`
	如果[[！-z $ {PID}]]; 然后
		echo -e“ $ {Info} LotServer安装完成！” &&出口1
	其他
		echo -e“ $ {Error} LotServer安装失败！” &&出口1
	科幻
}
Uninstall_LotServer（）{
	回声“确定要卸载LotServer？[y / N]” &&回声
	读取-e -p“（最小值：n）：” unyn
	[[-z $ {unyn}]] && echo && echo“已取消...” &&退出1
	如果[[$ {unyn} == [Yy]]]; 然后
		wget --no-check-certificate -qO /tmp/appex.sh“ https://raw.githubusercontent.com/0oVicero0/serverSpeeder_Install/master/appex.sh” && bash /tmp/appex.sh'卸载'
		回声&&回声“ LotServer卸载完成！” &&回声
	科幻
}
＃BBR
Configure_BBR（）{
	echo && echo -e“你要做什么？
	
 $ {Green_font_prefix} 1。$ {Font_color_suffix}安装BBR
————————
 $ {Green_font_prefix} 2。$ {Font_color_suffix}启动BBR
 $ {Green_font_prefix} 3。$ {Font_color_suffix}停止BBR
 $ {Green_font_prefix} 4。$ {Font_color_suffix}查看BBR状态“ && echo
echo -e“ $ {Green_font_prefix} [安装前请注意] $ {Font_color_suffix}
1.安装开启BBR，需要更换内核，存在更换失败等风险（重启后无法开机）
2.本脚本仅支持Debian / Ubuntu系统更换内核，OpenVZ和Docker不支持更换内核
3. Debian更换内核过程中会提示[是否终止卸载内核]，请选择$ {Green_font_prefix}否$ {Font_color_suffix}“ && echo
	读取-e -p“（默认：取消）：” bbr_num
	[[-z“ $ {bbr_num}”]] && echo“已取消...” &&退出1
	如果[[$ {bbr_num} ==“ 1”]]; 然后
		安装_BBR
	elif [[$ {bbr_num} ==“ 2”]]; 然后
		Start_BBR
	elif [[$ {bbr_num} ==“ 3”]]; 然后
		Stop_BBR
	elif [[$ {bbr_num} ==“ 4”]]; 然后
		状态_BBR
	其他
		echo -e“ $ {Error}请输入正确的数字（1-4）” &&退出1
	科幻
}
Install_BBR（）{
	[[$ {release} =“ centos”]] && echo -e“ $ {Error}本脚本不支持CentOS系统安装BBR！” &&出口1
	BBR_installation_status
	bash“ $ {BBR_file}”
}
Start_BBR（）{
	BBR_installation_status
	bash“ $ {BBR_file}”开始
}
Stop_BBR（）{
	BBR_installation_status
	bash“ $ {BBR_file}”停止
}
Status_BBR（）{
	BBR_installation_status
	bash“ $ {BBR_file}”状态
}
＃其他功能
Other_functions（）{
	echo && echo -e“你要做什么？
	
  $ {Green_font_prefix} 1。$ {Font_color_suffix}配置BBR
  $ {Green_font_prefix} 2。$ {Font_color_suffix}配置锐速（ServerSpeeder）
  $ {Green_font_prefix} 3。$ {Font_color_suffix}配置LotServer（锐速母公司）
  $ {Tip}锐速/ LotServer / BBR不支持OpenVZ！
  $ {Tip}锐速和LotServer不能共存！
————————————
  $ {Green_font_prefix} 4。$ {Font_color_suffix}一键封禁BT / PT / SPAM（iptables）
  $ {Green_font_prefix} 5。$ {Font_color_suffix}一键解封BT / PT / SPAM（iptables）
————————————
  $ {Green_font_prefix} 6。$ {Font_color_suffix}切换ShadowsocksR日志输出模式
  -说明：SSR默认仅输出错误日志，该可切换为输出详细的访问日志。
  $ {Green_font_prefix} 7。$ {Font_color_suffix}监控ShadowsocksR服务端运行状态
  -说明：该功能适合于SSR服务端经常进行结束，启动该功能后会每分钟检测一次，当进程不存在则自动启动SSR服务端。” && echo
	读取-e -p“（默认：取消）：” other_num
	[[-z“ $ {other_num}”]] && echo“已取消...” &&退出1
	如果[[$ {other_num} ==“ 1”]]; 然后
		配置_BBR
	elif [[$ {other_num} ==“ 2”]]; 然后
		Configure_Server_Speeder
	elif [[$ {other_num} ==“ 3”]]; 然后
		Configure_LotServer
	elif [[$ {other_num} ==“ 4”]]; 然后
		BanBTPTSPAM
	elif [[$ {other_num} ==“ 5”]]; 然后
		UnBanBTPTSPAM
	elif [[$ {other_num} ==“ 6”]]; 然后
		Set_config_connect_verbose_info
	elif [[$ {other_num} ==“ 7”]]; 然后
		设置_crontab_monitor_ssr
	其他
		echo -e“ $ {Error}请输入正确的数字[1-7]” &&退出1
	科幻
}
＃封禁BT PT SPAM
BanBTPTSPAM（）{
	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ban_iptables.sh && chmod + x ban_iptables.sh && bash ban_iptables.sh banall
	rm -rf ban_iptables.sh
}
＃解封BT PT SPAM
UnBanBTPTSPAM（）{
	wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ban_iptables.sh && chmod + x ban_iptables.sh && bash ban_iptables.sh unbanall
	rm -rf ban_iptables.sh
}
Set_config_connect_verbose_info（）{
	SSR_installation_status
	[[！-e $ {jq_file}]] && echo -e“ $ {错误} JQ解析器不存在，请检查！” &&出口1
	connect_verbose_info =`$ {jq_file}'.connect_verbose_info'$ {config_user_file}`
	如果[[$ {connect_verbose_info} =“ 0”]]; 然后
		echo && echo -e“当前日志模式：$ {Green_font_prefix}简单模式（$输出字体错误后缀）$ {Font_color_suffix}” && echo
		echo -e“确定要切换为$ {Green_font_prefix}详细模式（$ font_color_suffix}？[y / N]”）
		读取-e -p“（最小值：n）：” connect_verbose_info_ny
		[[-z“ $ {connect_verbose_info_ny}”]] && connect_verbose_info_ny =“ n”
		如果[[$ {connect_verbose_info_ny} == [Yy]]]; 然后
			ssr_connect_verbose_info =“ 1”
			Modify_config_connect_verbose_info
			重启_SSR
		其他
			回声&&回声“已取消...” &&回声
		科幻
	其他
		echo && echo -e“当前日志模式：$ {Green_font_prefix}详细模式（$ {Font_color_suffix}”）&& echo
		echo -e“确定要切换为$ {Green_font_prefix}简单模式$$ [Font_color_suffix}？[y / N]”
		读取-e -p“（最小值：n）：” connect_verbose_info_ny
		[[-z“ $ {connect_verbose_info_ny}”]] && connect_verbose_info_ny =“ n”
		如果[[$ {connect_verbose_info_ny} == [Yy]]]; 然后
			ssr_connect_verbose_info =“ 0”
			Modify_config_connect_verbose_info
			重启_SSR
		其他
			回声&&回声“已取消...” &&回声
		科幻
	科幻
}
Set_crontab_monitor_ssr（）{
	SSR_installation_status
	crontab_monitor_ssr_status = $（crontab -l | grep“ ssrmu.sh监视器”）
	如果[[-z“ $ {crontab_monitor_ssr_status}”]]；然后
		echo && echo -e“当前监控模式：$ {Green_font_prefix}未开启$ {Font_color_suffix}” && echo
		echo -e“确定要开启为$ {Green_font_prefix} ShadowsocksR服务端运行状态监控$ {Font_color_suffix}功能吗？（当逐步关闭则自动启动SSR服务端）[Y / n]”
		读取-e -p“（最小值：y）：” crontab_monitor_ssr_status_ny
		[[-z“ $ {crontab_monitor_ssr_status_ny}”]] && crontab_monitor_ssr_status_ny =“ y”
		如果[[$ {crontab_monitor_ssr_status_ny} == [Yy]]]；然后
			crontab_monitor_ssr_cron_start
		其他
			回声&&回声“已取消...” &&回声
		科幻
	其他
		echo && echo -e“当前监控模式：$ {Green_font_prefix}已开启$ {Font_color_suffix}” && echo
		echo -e“确定要关闭为$ {Green_font_prefix} ShadowsocksR服务端运行状态监控$ {Font_color_suffix}功能吗？（当逐步关闭则自动启动SSR服务端）[y / N]”
		读取-e -p“（最小值：n）：” crontab_monitor_ssr_status_ny
		[[-z“ $ {crontab_monitor_ssr_status_ny}”]] && crontab_monitor_ssr_status_ny =“ n”
		如果[[$ {crontab_monitor_ssr_status_ny} == [Yy]]]；然后
			crontab_monitor_ssr_cron_stop
		其他
			回声&&回声“已取消...” &&回声
		科幻
	科幻
}
crontab_monitor_ssr（）{
	SSR_installation_status
	check_pid
	如果[[-z $ {PID}]]; 然后
		echo -e“ $ {Error} [$（date” +％Y-％m-％d％H：％M：％S％u％Z“）]检测到ShadowsocksR服务端未运行，开始启动... “ | tee -a $ {ssr_log_file}
		/etc/init.d/ssrmu开始
		睡1秒
		check_pid
		如果[[-z $ {PID}]]; 然后
			echo -e“ $ {Error} [$（date” +％Y-％m-％d％H：％M：％S％u％Z“）] ShadowsocksR服务端启动失败...” | tee -a $ {ssr_log_file} &&退出1
		其他
			echo -e“ $ {Info} [$（date” +％Y-％m-％d％H：％M：％S％u％Z“）] ShadowsocksR服务端启动成功...” | tee -a $ {ssr_log_file} &&退出1
		科幻
	其他
		echo -e“ $ {Info} [$（date” +％Y-％m-％d％H：％M：％S％u％Z“）] ShadowsocksR服务端进程运行正常...”退出0
	科幻
}
crontab_monitor_ssr_cron_start（）{
	crontab -l>“ $ file / crontab.bak”
	sed -i“ /ssrmu.sh monitor / d”“ $ file / crontab.bak”
	echo -e“ \ n * * * * * / bin / bash $ file / ssrmu.sh监视器” >>“ $ file / crontab.bak”
	crontab“ $ file / crontab.bak”
	rm -r“ $ file / crontab.bak”
	cron_config = $（crontab -l | grep“ ssrmu.sh监视器”）
	如果[[-z $ {cron_config}]]; 然后
		echo -e“ $ {Error} ShadowsocksR服务端运行状态监控功能启动失败！” &&出口1
	其他
		echo -e“ $ {Info} ShadowsocksR服务端运行状态监控功能启动成功！”
	科幻
}
crontab_monitor_ssr_cron_stop（）{
	crontab -l>“ $ file / crontab.bak”
	sed -i“ /ssrmu.sh monitor / d”“ $ file / crontab.bak”
	crontab“ $ file / crontab.bak”
	rm -r“ $ file / crontab.bak”
	cron_config = $（crontab -l | grep“ hasan.sh monitor”）
	如果[[！-z $ {cron_config}]]; 然后
		echo -e“ $ {Error} ShadowsocksR服务端运行状态监控功能停止失败！” &&出口1
	其他
		echo -e“ $ {Info} ShadowsocksR服务端运行状态监控功能停止成功！”
	科幻
}
Update_Shell（）{
	sh_new_ver = $（wget --no-check-certificate -qO- -t1 -T3“ https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh"|grep'sh_ver =”'| awk- F“ =”'{print $ NF}'| sed's / \“ // g'| head -1）&& sh_new_type =” github“
	[[-z $ {sh_new_ver}]] && echo -e“ $ {错误}无法链接到Github！” &&退出0
	如果[[-e“ /etc/init.d/hasan”]]; 然后
		rm -rf /etc/init.d/hasan
		服务_SSR
	科幻
	cd“ $ {文件}”
	wget -N --no-check-certificate“ https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/ssrmu.sh” && chmod + x ssrmu.sh
	echo -e“脚本已更新为最新版本[$ {sh_new_ver}]！（注意：因为更新方式为直接覆盖当前运行的脚本，所以可能下面会提示一些报错，无视即可）” && exit 0
}
＃显示菜单状态
menu_status（）{
	如果[[-e $ {ssr_folder}]]; 然后
		check_pid
		如果[[！-z“ $ {PID}”]]; 然后
			echo -e“当前状态：$ {Green_font_prefix}已安装$ {Font_color_suffix}并$ {Green_font_prefix}已启动$ {Font_color_suffix}”
		其他
			echo -e“当前状态：$ {Green_font_prefix}已安装$ {Font_color_suffix}但$ {Red_font_prefix}未启动$ {Font_color_suffix}”
		科幻
		cd“ $ {ssr_folder}”
	其他
		echo -e“当前状态：$ {Red_font_prefix}未安装$ {Font_color_suffix}”
	科幻
}
check_sys
[[$ {release}！=“ debian”]] && [[$ $ release}！=“ ubuntu”]] && [[$ $ release]！=“ centos”]] && echo -e“ $ {Error}本脚本不支持当前系统$ {release}！“ &&出口1
动作= $ 1
如果[[“ $ {action}” ==“ clearall”]]; 然后
	Clear_transfer_all
elif [[“ $ {action}” ==“ monitor”]]; 然后
	crontab_monitor_ssr
其他
	echo -e“ ShadowsocksR ComeBey一键管理脚本$ {Red_font_prefix} [v $ {sh_ver}] $ {Font_color_suffix}
          ＃youtube关注https://www.youtube.com/c/HasanW＃
          ＃Twitter关注免费天气预报获取https://twitter.com/WangTao_Im＃
          ＃Instagram关注https://www.instagram.com/wangtao.lm/＃

  $ {Green_font_prefix} 1。$ {Font_color_suffix}安装ShadowsocksR
  $ {Green_font_prefix} 2。$ {Font_color_suffix}更新ShadowsocksR
  $ {Green_font_prefix} 3。$ {Font_color_suffix}卸载ShadowsocksR
  $ {Green_font_prefix} 4。$ {Font_color_suffix}安装libsodium（chacha20）
————————————
  $ {Green_font_prefix} 5。$ {Font_color_suffix}查看账号信息
  $ {Green_font_prefix} 6。$ {Font_color_suffix}显示连接信息
  $ {Green_font_prefix} 7。$ {Font_color_suffix}设置用户配置
  $ {Green_font_prefix} 8。$ {Font_color_suffix}手动修改配置
  $ {Green_font_prefix} 9。$ {Font_color_suffix}配置流量清零
————————————
 $ {Green_font_prefix} 10。$ {Font_color_suffix}启动ShadowsocksR
 $ {Green_font_prefix} 11。$ {Font_color_suffix}停止ShadowsocksR
 $ {Green_font_prefix} 12。$ {Font_color_suffix}重新启动ShadowsocksR
 $ {Green_font_prefix} 13。$ {Font_color_suffix}查看ShadowsocksR日志
————————————
 $ {Green_font_prefix} 14。$ {Font_color_suffix}其他功能
 $ {Green_font_prefix} 15。$ {Font_color_suffix}升级脚本
 ”
	menu_status
	回声&&读取-e -p“请输入数字[1-15]：”
情况为“ $ num”
	1）
	安装_SSR
	;;
	2）
	更新_SSR
	;;
	3）
	卸载_SSR
	;;
	4）
	Install_Libsodium
	;;
	5）
	View_User
	;;
	6）
	查看用户连接信息
	;;
	7）
	Modify_Config
	;;
	8）
	Manually_Modify_Config
	;;
	9）
	清除转移
	;;
	10）
	开始_SSR
	;;
	11）
	Stop_SSR
	;;
	12）
	重启_SSR
	;;
	13）
	查看日志
	;;
	14）
	其他功能
	;;
	15）
	Update_Shell
	;;
	*）
	echo -e“ $ {Error}请输入正确的数字[1-15]”
	;;
埃萨克
科幻
