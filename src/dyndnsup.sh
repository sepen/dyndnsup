#!#SHEBANG#
#
# Copyright (c) 2007 by Jose V. Beneyto, sepen at users dot sourceforge dot net
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

msgError() {
  echo "Error, $@" 2>&1
  exit 1
}

msgVersion() {
  echo "$APPNAME v$APPVERSION by Jose V Beneyto"
  exit 0
}

msgUsage() {
  echo "Usage: $APPNAME [-v] | [-h] | [-c | --config file]"
  echo "Read the manual for futher information: $APPNAME(1)"
  exit 0
}

getIP() {
  local iface="$1"
  local platform="$(uname)"
  local ip
  case $platform in 
    Linux)
      ip="$(ifconfig $iface | grep 'inet addr' | awk '{print $2}' | sed -e 's/.*://')"
      ;;
    OpenBSD)
      ip="$(ifconfig $iface | grep 'inet ' | awk '{print $2}')"
      ;;
    SunOS)
      ip="$(ifconfig $iface | grep 'inet' | awk '{print $2}')"
      ;;
    *)
      msgError "platform $platform is not yet supported"
      ;;
  esac
	DD_IP=$ip
}

updateIP() {
  local dd_user="$1"
  local dd_pass="$2"
  local dd_server="$3"
  local dd_system="$4"
  local dd_hostname="$5"
  local dd_ip="$6"
	DD_RETCODE="$(curl -s "http://${dd_user}:${dd_pass}@$dd_server/nic/update?system=$dd_system&hostname=$dd_hostname&myip=$dd_ip" |  awk '{print $1}')"
}

printMessage() {
  local code="$1"
  [ "$code" == "" ] && msgError "no return code, update not take effects!"
  case $code in
    # update syntax errors
    badsys)		
      echo "The system parameter given is not valid."
      echo "Valid system parameters are dyndns, statdns and custom."
      ;;
    badagent) 	
      echo "The user agent that was sent has been blocked for not"
      echo "following these specifications, or no user agent was specified."
      ;;
    # account-related errors
    badauth)
      echo "The username or password specified are incorrect."
      ;;
    !donator)	
      echo "An option available only to credited users (such as offline URL)"
      echo "was specified, but the user is not a credited user. If multiple hosts"
      echo "were specified, only a single !donator will be returned."
      ;;
    # update complete
    good)
      echo "The update was successful, and the hostname is now updated."
      ;;
    nochg)
      echo "The update changed no settings, and is considered abusive."
      echo "Additional nochg updates will cause the hostname to become blocked."
      ;;
    # hostname-related errors
    notfqdn)
      echo "The hostname specified is not a fully-qualified domain name"
      echo "(not in the form hostname.dyndns.org or domain.com)."
      ;;
    nohost)
      echo "The hostname specified does not exist (or is not in the service"
      echo "specified in the system parameter)"
      ;;
    !yours)
      echo "The hostname specified exists, but not under the username specified."
      ;;
    numhost)
      echo "Too many or too few hosts found"
      ;;
    abuse)
      echo "The hostname specified is blocked for update abuse."
      ;;
    # server error conditions
    dnserr)
      echo "DNS error encountered"
      ;;
    911)
      echo "There is a serious problem on our side, such as a database or DNS server failure."
      ;;
  esac
}

writeLog() {
  local date="$(date +'%D %T')"
  echo -ne "[$date] " >>$LOG_FILE
  cat - >>$LOG_FILE
}

main() {
  local dd_ip=""
  if [ $# -gt 0 ]; then
    case $1 in
      -c) CONFIG_FILE="$2" ;;
       *) msgUsage ;;
    esac
  fi
  [ ! -r "$CONFIG_FILE" ] && msgError "can't read config file '$CONFIG_FILE'"
  . $CONFIG_FILE
  getIP $DD_IFACE
  updateIP "$DD_USERNAME" "$DD_PASSWORD" "$DD_SERVER" "$DD_SYSTEM" "$DD_HOSTNAME" "$DD_IP"
  printMessage $DD_RETCODE
}

APPNAME="$(basename $0)"
APPVERSION="0.2.1"

CONFIG_FILE="#ETCDIR#/$APPNAME.conf"
LOG_FILE="#LOGDIR#/$APPNAME.log"

DD_IP=""
DD_RETCODE=""

main $@ 2>&1 | writeLog

# End of File
