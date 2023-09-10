import time
from AccessToken import *
from collections import OrderedDict
import sys
import os
import pyperclip
Role_Attendee = 0
Role_Publisher = 1
Role_Subscriber = 2
Role_Admin = 101

class RtcTokenBuilder:
    @staticmethod
    def buildTokenWithUid(appId, appCertificate, channelName, uid, role, privilegeExpiredTs):
        return RtcTokenBuilder.buildTokenWithAccount(appId, appCertificate, channelName, uid, role, privilegeExpiredTs)

    @staticmethod
    def buildTokenWithAccount(appId, appCertificate, channelName, account, role, privilegeExpiredTs):
        token = AccessToken(appId, appCertificate, channelName, account)
        token.addPrivilege(kJoinChannel, privilegeExpiredTs)
        if (role == Role_Attendee) | (role == Role_Admin) | (role == Role_Publisher):
            token.addPrivilege(kPublishVideoStream, privilegeExpiredTs)
            token.addPrivilege(kPublishAudioStream, privilegeExpiredTs)
            token.addPrivilege(kPublishDataStream, privilegeExpiredTs)
        return token.build()

# Values
appID = "7b3cd04a567540fdab2dccc136b7c628"
appCertificate = "a42a69ac900d4bb7a61e365a5bc1292e"
channelName = "CallToken"  # Replace with your channel name
uid = 1
role = Role_Publisher
privilegeExpireTs = int(time.time()) + 3600  # Token will expire in 1 hour

# Generate the token
token = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpireTs)

print(token)
pyperclip.copy(token)
