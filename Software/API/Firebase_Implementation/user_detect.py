#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os

# os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/ads.sh ' + "abcddd" + ' ' + 'https://i.pinimg.com/originals/8a/c0/4f/8ac04fb2af0efb66e07641f4dd335c4f.jpg' )

import threading
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import requests
# import getmac
import datetime
import time

# Use a service account
cred = credentials.Certificate('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/flashapp-7027e-firebase-adminsdk-fz2rt-714ca34e83.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

# macAddr = getmac.get_mac_address()
macAddr = u'b8:27:eb:88:85:92'

rpi_ref = db.collection(u'signage units').document(macAddr)
ads_ref = rpi_ref.collection(u'advertisements')

rpi_mac = rpi_ref.get()
if rpi_mac.exists: 
    print("device exists")
else:
    rpi_ref.set({
        u'isUserTargeting':False,
    })


# Create an Event for notifying main thread.
callback_done = threading.Event()

# Create a callback on_snapshot function to capture changes
def on_snapshot(doc_snapshot, changes, read_time):
    for doc in doc_snapshot:
        adStates_dict = doc.to_dict()

        if adStates_dict["isUserTargeting"]:
            print("do targetting")
            showAd(adStates_dict["ad_type"],adStates_dict["ad_age"])
        else:
            #delete all slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

    callback_done.set()

# Watch the document
doc_watch = rpi_ref.on_snapshot(on_snapshot)    

#function to show ad from firestore
def showAd(adType,adAge):

    if adType == 'male':
        if adAge == '(25,32)':
            #delete all slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')
            #create slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/male_slides_2532.sh')
        else:
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

    elif adType == 'female':
        if adAge == '(25,32)':
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')
            #create slides
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/female_slides_2532.sh')
        else:
            os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')

    elif adType == 'generic':
        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')
        #create slides
        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/generic_slide.sh')

    else:
        os.system('/home/viraj/Desktop/Project-Signage/Digital-Signage-Based-User-Targerd-Advertising/Software/API/Firebase_Implementation/delete_slides.sh')


# Keep the app running
while True:

    time.sleep(1)
