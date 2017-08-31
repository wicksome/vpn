import imaplib
import re
from commands import *
import time
import sys

IMAP = sys.argv[1]
MAIL_ID = sys.argv[2]
MAIL_PWD = sys.argv[3]

KEYWORD_OF_MAIL_TITLE_FOR_SEARCH = sys.argv[4]
REGEX_FOR_GETTING_PASSWORD = sys.argv[5]


mail = imaplib.IMAP4_SSL(IMAP)
mail.login(MAIL_ID, MAIL_PWD)


def get_opt():
    try:
        mail.select('INBOX')
        result, data = mail.search(
            None, '(UNSEEN SUBJECT "%s")' % KEYWORD_OF_MAIL_TITLE_FOR_SEARCH)
        id_list = data[0].split()
        latest_email_id = id_list[-1]  # get the latest

        result, data = mail.fetch(
            latest_email_id, "(BODY.PEEK[HEADER.FIELDS (SUBJECT)])")
        m = re.search(REGEX_FOR_GETTING_PASSWORD, data[0][1])
        print(m.group(1))

        for mail_id in id_list:
            mail.store(mail_id, '+FLAGS', '\\Deleted')

        return True
    except IndexError:
        pass
    except Exception as e:
        raise
    finally:
        try:
            mail.store(latest_email_id, 'FLAGS', '(\SEEN)')
            mail.close()
            mail.logout()
        except:
            pass

    return False


time.sleep(5)
count = 0
while (count < 25):
    if get_opt() == True:
        break
    else:
        count = count + 1
        time.sleep(0.5)
