Automating PT as good as possible -> as Failsave as Possible.<br>
<small>will Check for 50+ Findings with output in Findings.txt, and more are possible through RAW files</small><br>
v1.6<br>
<br>
The extern Tools were moved to <code>ext_auto_pt</code>.<br>
<br>
<b>Installation</b><br>
download this Repository to <code>/opt</code> via <b>git clone</b> <small>(full command is in 1Password with Token or via dfi)</small>.<br>
Install all requirements + X via <b>tool-install.sh</b> in <code>/opt/auto_pt</code>.<br>
<br>
<b>Updating</b><br>
in the folder <code>/opt/auto_pt/</code> do <b>git pull</b>, than run <b>tool_install.sh</b>.<br>
This updates all Scripts via git pull and updates all Tools.<br>
<br>
<b>intended usage</b><br>
First start <b>passive_recon.sh</b> for <b>netdiscover</b> (passive!), <b>PCredz</b> and 5 min <b>TCPdump</b> in tmux.<br>
tTis Script creates all necesseary Folders via <code>scripts/folder.sh</code>.<br>
<b>PCredz</b> should run during the whole test to gather all Credz -> beware it's started in <b>tmux</b> with <code>/opt/auto_pt/dfitmux.conf</code>!<br>
<small>maybe not compatible with <i>iTerm tmux</i> integration.</small><br>
<br>
<code>/root/input/ipint.txt</code> is needed as Scope <b>exit 1</b> if missing!<br>
<small><code>dns_enum.sh</code> can create it, requests DNS Server for <b>nmap</b>.</small><br>
enter <b>tmux a</b>, create a new window (<b>crtl b + c</b>) and start <b>auto_pt.sh</b>.<br>
<br>
<b>Auto_PT</b> creates <code>/root/output/runtime.txt</code> for <i>Performance and Evidence</i> in case of an <i>Incident</i>. Mind the <b>local</b> time!<br>
<b>Auto_PT</b> requests Workspace for <b>MSF</b>.<br>
<small><b>Auto_PT</b> may be stuck at Creating CME Relay list, this is a feature of CME, just press ENTER</small><br>
<br>
If <b>passive_recon.sh</b> is not/was not running and all "Modules" schould be run separately, first start <b>folder.sh</b> to create the required folders.<br>
<br>
<details><summary><h2>Auto_PT "Modules":</h2></summary>
    <h3>folder:</h3>
    <b></b>creates all (sub)folders in <code>/root/input/</code> and <code>/root/output/</code>.<br>
<br>
    <h3>active_recon:</h3>
    <b>nmap</b><code>/root/input/ipint.txt</code> -> Scope!<br>
    <b>nmap</b> -> Egress-filter<br>
    <b>nmap</b> -> IP Up Hosts<br>
    <b>nmap</b> -> default Creds<br>
    <b>nmap</b> -> Service scan<br>
    <b></b>create Service lists -> for other toolz<br>
    <b>sslscan</b> -> weak Ciphers <br>
    <b>nmap</b> -> Root login check - needs recheck!<br>
    <b>CME</b> -><code>smb_sign_off.txt</code><br>
    <b></b>create<code>relay_lists</code> -> manual use with<b>impacket-ntlmrelayx</b><br>
<br>
    <h3>autosploit:</h3>
    <b>Metasploit-framework</b><code>ressource.txt</code> in<code>/opt/hacking/resource_script/</code> Folder.<br>
<br>
    <h3>zerocheck:</h3>
    <b></b>Zerologon check with<b>MSF</b>, NetBIOS with<b>nbtscan</b>.<br>
<br>
    <h3>log4check:</h3>
    <b></b>Log4J Log4Shell check with<b>MSF</b>, resource<code>log4j.txt</code> in<code>/opt/hacking/resource_script/</code> Folder.<br>
<br>
    <h3>fast_relay:</h3>
    <b></b>5 min<b>responder</b> and<b>impacket-ntlmrelayx</b> vs<code>/root/output/list/smb_sign_off.txt</code>.<br>
<br>
    <h3>looter:</h3>
    <b></b>Collect the loot, move files to internal folders for "Automater".<br>
<br>
    <h3>counter:</h3>
    <b></b>Counts the findings and grabs the subnets in <code>/root/output/loot/intern/findings.txt</code>.<br>
<br>
    <h3>eyewitness:</h3>
    <b></b>Make some Screens in <code>/root/output/screens</code>.<br>
    <b></b>If broken maybe <code>apt install chromium-driver</code> or <code>pip3 install 'selenium<4.0.0'</code>.<br>
<br>
    <h3>def_screen_looter:</h3>
    <b></b>Looter for default Pages from Eyewitness sources.<br>
<br>
    <h3>Auto_PT DONE!</h3>
    <b></b>copy your<code>output</code> folder to your local machine for further investigation.<br>
<br>
</details>
<br>
<details><summary><h2>Additional Files</h2></summary>
    <h3>user_checks:</h3>
    <b></b>All CME checks LdapRelayScan and BH + Certipy dump with obtained user + PW OR Hash.<br>
    <b></b>Make sure DNS is working as expected!<br>
    <b></b>CME: GPP_Password, GPP_Autologin, Username=PW, get Passpol, nopac, PetitPotam (unauthenticated), DFScoerce, SMBSessions, ASRep, Kerberoasting, ldap-checker, MAQ.<br>
    <b></b>CME ldap may be broken.<br>
    <b></b>All Checks generates files in the related <code>output/loot/intern</code> folder.<br>
    <b></b>Findings.txt will <b>NOT</b> be updated.<br>
    <b></b>Use -h for Help.<br>
    <b></b>Validates IP and if providet the NThash<br>
<br>
    <h3>otscan:</h3>
    <b></b>Some Nmap scans for OT Systems, just information gathering.<br>
    <b></b>Uses <code>/root/input/ipot.txt</code> because the scan is <b>very slow</b>.<br>
<br>
    <h3>dns_enum:</h3>
    <b></b>Nmap scan for Scope gathering via DNS; all privat IPs will be checked.<br>
    <b></b>needs Nameserver/DNS-Server IP.<br>
<br>
    <h3>cleaner:</h3>
    <b></b>cleans all the LogFiles and Output generated by <b>Auto_PT</b> +X.<br>
<br>
    <h3>dfitmux.conf</h3>
    <b></b>My <b>tmux</b> Config, some kind of special, used in passive_recon.<br>
<br>
    <h3>zshrc</h3>
    <b></b>my <code>.zshrc</code>, Kali 2020.4 with "seperate command line" and 💀.<br>
<br>
    <h3>.files</h3>
    <b></b>just ignore them.<br>
<br>
</details>
<br>
