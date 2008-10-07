#!#SHEBANG#
#
# Copyright (c) 2008 by Jose V. Beneyto, sepen at users dot sourceforge dot net
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

msgUsage() {
  echo "Usage: $APPNAME [-h] | [-c file]"
  echo "Read the manual for futher information: $APPNAME(1)"
  exit 0
}

main() {
  local dhost dconf
  if [ $# -gt 0 ]; then
    case $1 in
      -c) CONFIG_FILE="$2" ;;
       *) msgUsage ;;
    esac
  fi
  [ ! -r "$CONFIG_FILE" ] && msgError "can't read config file '$CONFIG_FILE'"
  while read line; do
    if [ "$(echo $line | grep -ve '^#')" ]; then
    dhost="$(echo $line | awk '{print $1}')"
    dconf="$(echo $line | awk '{print $2}')"
    [ -z "$dhost" -a -z "$dconf" ] && msgError "while parsing '$CONFIG_FILE'"
    [ ! -r "$CONFIG_FILE" ] && msgError "can't read config file '$dconf'"
    host $i 2>&1 >/dev/null
    if [ $? -ne 0 ]; then
        $DYNDNSUP_BIN -v -c $dconf
  fi
  done < $CONFIG_FILE
}

APPNAME="$(basename $0)"
APPVERSION="0.2.2"

CONFIG_FILE="#ETCDIR#/$APPNAME.conf"
DYNDNSUP_BIN="#DYNDNSUP#"

main $@ 2>&1

# End of file
