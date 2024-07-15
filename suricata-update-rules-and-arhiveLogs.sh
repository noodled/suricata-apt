export UAgentHTTP="Mozilla/5.0 (Windows NT 10.0; Win64; x64) Safari/537.36"
pushd /etc/suricata
curl -A "%UAgentHTTP%" -JLO "https://rules.emergingthreats.net/open/suricata-5.0/classification.config"
curl -A "%UAgentHTTP%" -JLO "https://threatfox.abuse.ch/downloads/threatfox_suricata.tar.gz"
tar xvzf threatfox_suricata.tar.gz -C "/etc/suricata/rules"
mkdir -p /etc/suricata/rules/rules.emergingthreats.net/open/suricata-5.0
pushd /etc/suricata/rules/rules.emergingthreats.net/open/suricata-5.0
echo downloading newer SIGS Suricata 5 from Emerging Threats Open
curl -A "%UAgentHTTP%" -JLO "https://rules.emergingthreats.net/open/suricata-5.0.0/emerging.rules.tar.gz"
tar xvzf emerging.rules.tar.gz -C "/etc/suricata/rules"
echo downloading abuse.ch ransomware replacement urlhaus
curl -A "%UAgentHTTP%" -JL "https://urlhaus.abuse.ch/downloads/ids/" -o urlhause.rules
echo downloading quadrantsec suricata rules
curl -A "%UAgentHTTP%" -JL "https://raw.githubusercontent.com/quadrantsec/suricata-rules/main/quadrant-suricata.rules" -o quadrant-suricata.rules
rem extra abuse.ch rules
curl -A "%UAgentHTTP%" -JL "https://raw.githubusercontent.com/quadrantsec/suricata-rules/main/quadrant-suricata.rules" -o quadrant-suricata.rules
curl -A "%UAgentHTTP%" -JL "https://sslbl.abuse.ch/blacklist/sslblacklist_tls_cert.rules" -o sslblacklist_tls_cert.rules
curl -A "%UAgentHTTP%" -JL "https://sslbl.abuse.ch/blacklist/sslipblacklist_aggressive.rules" -o sslipblacklist_aggressive.rules
curl -A "%UAgentHTTP%" -JL "https://sslbl.abuse.ch/blacklist/ja3_fingerprints.rules" -o ja3_fingerprints.rules
rem default rules
rem not on linux
echo Now Archiving old logs
sudo systemctl stop suricata
TStamp=$(date +"%Y-%m-%dT%H%M%Ss%Z")
echo Suricata Log Archiving timestamp is %TStamp%
pushd /var/log/suricata
find . -maxdepth 1 -mindepth 1 -type f -exec mv \{\} \{\}-$HOSTNAME-$TStamp \;
find . -maxdepth 1 -mindepth 1 -type f -exec gzip \{\} \;
mv *.log-$HOSTNAME-*.gz /home
sudo systemctl start suricata
sleep 4
sudo systemctl status suricata

