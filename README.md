Automating PT as good as possible -> as Failsave as Possible.<br>
<small>will Check for 50+ Findings with output in Findings.txt, and more are possible through RAW files</small><br>
Some are documented in pwndoc/pwndoc-ng [my-PwnDoc-Vunerabilities](https://github.com/Elan0r/PwnDoc-Vulnerabilities)<br>
Work needs to be done, CME Checks are in v5.X and needed to be updated to v6+<br>
<br>
<b>Installation</b><br>
download this Repository to <code>/opt</code> via <b>git clone</b>.<br>
<code>/opt/autp_pt</code> is expected.
Pathes to the files are hardcoded, that is may way of test.<br>
<br>
<b>Updating</b><br>
in the folder <code>/opt/auto_pt/</code> do <b>git pull</b>, than run <b>tool_install</b> inside the menu.<br>
This updates all Scripts via git pull and updates all Tools.<br>
<br>
<b>intended usage</b><br>
Start your Tmux session and than run the <b>menu.sh</b>.<br>
<b>root required</b><br>
from there you can start the <b>status</b> in <b>new pane</b> and <b>passiv listener</b> in new window and start the Recon or what ever.<br>
<br>
<code>/root/input/ipint.txt</code> is needed as Scope, if missing the menu got u.<br>
<small><b>Host and Service Discovery</b> can create it, DNS Server Listscan with <b>nmap</b>.</small><br>
<br>
<b>Auto_PT</b> creates <code>/root/output/runtime.txt</code> for <i>Performance and Evidence</i> in case of an <i>Incident</i>. Mind the <b>local</b> time!<br>
<b>Auto_PT</b> requests Workspace for <b>MSF</b>. Should be set manually via <b>menu.sh</b>.<br>
<small><b>Auto_PT</b> may be stuck at CME checks, this is a feature of CME, just press ENTER</small><br>
<br>
