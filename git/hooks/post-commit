#!/usr/bin/env python

import smtplib
from email.mime.text import MIMEText
from subprocess import check_output

# Get the git log --stat entry of the new commit
log = check_output(['git', 'log', '-1', '--stat', 'HEAD'])

# Create a plaintext email message
msg = MIMEText("Look, I'm actually doing some work:\n\n%s" % log)

msg['Subject'] = 'Git post-commit hook notification'
msg['From'] = 'mary@example.com'
msg['To'] = 'boss@example.com'

# Send the message
SMTP_SERVER = 'smtp.example.com'
SMTP_PORT = 587

session = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
session.ehlo()
session.starttls()
session.ehlo()
session.login(msg['From'], 'secretPassword')

session.sendmail(msg['From'], msg['To'], msg.as_string())
session.quit()
