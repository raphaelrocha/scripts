#/bin/sh
sudo lsof -i :8081
sudo launchctl list | grep {PID}
sudo launchctl remove com.mcafee.agent.macmn
