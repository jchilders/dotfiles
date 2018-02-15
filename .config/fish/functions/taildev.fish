function taildev
  ssh -t webuser@smsdev.inbcu.com 'tail -n 200 -f /opt/www/tomcat/sms/logs/sms.log'
end

