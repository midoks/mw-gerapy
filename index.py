# coding:utf-8

import sys
import io
import os
import time

sys.path.append(os.getcwd() + "/class/core")
import mw

app_debug = False
if mw.isAppleSystem():
    app_debug = True


def getPluginName():
    return 'gerapy'


def getPluginDir():
    return mw.getPluginDir() + '/' + getPluginName()


def getServerDir():
    return mw.getServerDir() + '/' + getPluginName()


def getInitDFile():
    if app_debug:
        return '/tmp/' + getPluginName()
    return '/etc/init.d/' + getPluginName()


def getInitDTpl():
    path = getPluginDir() + "/scripts/init.d/" + getPluginName() + ".tpl"
    return path


def getInitDScrapydTpl():
    path = getPluginDir() + "/scripts/init.d/scrapyd.tpl"
    return path


def getArgs():
    args = sys.argv[2:]
    tmp = {}
    args_len = len(args)

    if args_len == 1:
        t = args[0].strip('{').strip('}')
        t = t.split(':')
        tmp[t[0]] = t[1]
    elif args_len > 1:
        for i in range(len(args)):
            t = args[i].split(':')
            tmp[t[0]] = t[1]

    return tmp


def status():
    data = mw.execShell(
        "ps -ef|grep gerapy |grep -v grep | grep -v mdserver-web | awk '{print $2}'")

    if data[0] == '':
        return 'stop'
    return 'start'


def initDreplace():

    file_tpl = getInitDTpl()
    service_path = os.path.dirname(os.getcwd())

    initD_path = getServerDir() + '/init.d'
    if not os.path.exists(initD_path):
        os.mkdir(initD_path)
    file_bin = initD_path + '/' + getPluginName()

    # initd replace
    content = mw.readFile(file_tpl)
    content = content.replace('{$SERVER_PATH}', service_path)
    mw.writeFile(file_bin, content)
    mw.execShell('chmod +x ' + file_bin)

    file_tpl = getInitDScrapydTpl()
    file_bin_scr = initD_path + '/scrapyd'
    content = mw.readFile(file_tpl)
    content = content.replace('{$SERVER_PATH}', service_path)
    mw.writeFile(file_bin_scr, content)
    mw.execShell('chmod +x ' + file_bin_scr)

    return file_bin, file_bin_scr


def start():
    file, file_scr = initDreplace()
    data = mw.execShell(file + ' start')
    mw.execShell(file_scr + ' start')
    if data[1] == '':
        return 'ok'
    return 'fail'


def stop():
    file, file_scr = initDreplace()
    data = mw.execShell(file + ' stop')
    mw.execShell(file_scr + ' stop')
    if data[1] == '':
        return 'ok'
    return 'fail'


def reload():
    file, file_scr = initDreplace()
    data = mw.execShell(file + ' reload')
    mw.execShell(file_scr + ' reload')
    if data[1] == '':
        return 'ok'
    return 'fail'


def initdStatus():
    if not app_debug:
        if mw.isAppleSystem():
            return "Apple Computer does not support"

    initd_bin = getInitDFile()
    if not os.path.exists(initd_bin):
        return 'fail'

    if not os.path.exists(initd_bin):
        return 'fail'
    return 'ok'


def initdInstall():
    import shutil
    if not app_debug:
        if mw.isAppleSystem():
            return "Apple Computer does not support"

    source_bin = initDreplace()
    initd_bin = getInitDFile()
    shutil.copyfile(source_bin, initd_bin)
    mw.execShell('chmod +x ' + initd_bin)
    mw.execShell('chkconfig --add ' + getPluginName())

    mw.execShell("chmod +x /etc/init.d/scrapyd")
    mw.execShell('chkconfig --add scrapyd')

    return 'ok'


def initdUinstall():
    if not app_debug:
        if mw.isAppleSystem():
            return "Apple Computer does not support"

    mw.execShell('chkconfig --del ' + getPluginName())
    initd_bin = getInitDFile()
    os.remove(initd_bin)

    mw.execShell('chkconfig --del scrapyd')
    os.remove("/etc/init.d/scrapyd")

    return 'ok'


def runLog():
    return getServerDir() + '/logs.pl'


def scrLog():
    return getServerDir() + '/scrapyd.pl'

if __name__ == "__main__":
    func = sys.argv[1]
    if func == 'status':
        print(status())
    elif func == 'start':
        print(start())
    elif func == 'stop':
        print(stop())
    elif func == 'restart':
        print(restart())
    elif func == 'reload':
        print(reload())
    elif func == 'initd_status':
        print(initdStatus())
    elif func == 'initd_install':
        print(initdInstall())
    elif func == 'initd_uninstall':
        print(initdUinstall())
    elif func == 'run_log':
        print(runLog())
    elif func == 'scr_log':
        print(scrLog())
    else:
        print('error')
